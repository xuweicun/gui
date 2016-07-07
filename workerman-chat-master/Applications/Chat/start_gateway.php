<?php
/**
 * This file is part of workerman.
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the MIT-LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author walkor<walkor@workerman.net>
 * @copyright walkor<walkor@workerman.net>
 * @link http://www.workerman.net/
 * @license http://www.opensource.org/licenses/mit-license.php MIT License
 */
use \Workerman\Worker;
use \GatewayWorker\Gateway;
use \Workerman\Autoloader;
use \Workerman\Lib\Timer;
use \GatewayWorker\Lib\Db;
use \GatewayWorker\Lib\Gateway as ExtendGateWay;

// 自动加载类
require_once __DIR__ . '/../../Workerman/Autoloader.php';
Autoloader::setRootPath(__DIR__);
define('PLAN_STATUS_WORKING', 0, true);
define('PLAN_STATUS_WAITING', -1, true);
define('PLAN_STATUS_FINISHED', 1, true);
define('PLAN_STATUS_SUCCESS', 1, true);
define('PLAN_STATUS_CANCELED', 2, true);
define('PLAN_STATUS_SKIPPED', 2, true);
define('PLAN_STATUS_OTHER', 3, true);

Class AutoChecker
{
    //类型:md5 or sn
    public $type = 'md5';
    //当前状态
    public $status = PLAN_STATUS_WAITING;
    //定时器间隔
    public $timerInterval = 60;
    public $plan_id = 0;
    //下一计划
    public $next_plan = 0;
    public $db = null;
    //数据库表名
    public $tbl_plan = 'gui_check_plan';
    public $tbl_conf = 'gui_check_conf';

    /****
     * @param $_t type
     * @param $_i interval
     */
    public function init($_t, $_i, $_db)
    {
        $this->RunLog("Initializing the self check status\n Checker Type:".$_t." \nTime interval: ".$_i."Seconds.");
        $this->timerInterval = $_i;
        $this->type = $_t;
        $this->db = $_db;
        if ($plan = $this->getCurrPlan()) {
            $this->plan_id = $plan['id'];
        }

    }
    public function RunLog($str){
        $msg = array('type' => 'check_status', 'msg'=>"Type: {$this->type}. Status: ".$str);
        ExtendGateWay::sendToAll(json_encode($msg));
    }
    /***
     * 定时器
     */
    public function Run()
    {
        $this->RunLog("Starting the timer.");
        Timer::add($this->timerInterval, array($this, 'mainCheck'));
    }

    public function getCurrPlan()
    {
        $db = $this->db;
        $plan = null;
        if ($this->plan_id == 0) {
            $plans = $db->select('*')->from($this->tbl_plan)->where("status=-1 and type='{$this->type}'")->orderby(array('start_time'))->query();
            if ($plans) {
                $plan = $plans[0];
            } else {
                //根据配置项增加新计划
                $plan = $this->addNewPlan();
            }
        } else {
            $plan = $db->select('*')->from($this->tbl_plan)->where("id={$this->plan_id}")->single();
        }
        if (!$plan) {
            $this->plan_id = 0;
        } else {
            $this->plan_id = $plan['id'];
            $this->status = $plan['status'];
        }
        return $plan;
    }

    /****
     * 自检函数
     */
    public function mainCheck()
    {
        $db = $this->db;
        if (!$db) {
            $this->RunLog("Database not connected.");
            return;
        }
        //如果当前没有自检计划,返回
        $this->RunLog("Retriving the plan.");
        $plan = $this->getCurrPlan();
        if (!$plan) {
            return;
        }
        //检查当前计划是否仍有效
        if (!$this->isAlive($plan)) {
            $this->updateChecker();
            return;
        }
        //如果当前计划未开始,检查是否已到时间
        if ($this->status == PLAN_STATUS_WAITING) {
            //尝试启动自检计划,如果启动失败则返回
            if (!$this->startCheck($plan))
                return;
        }
        //获取存储柜信息
        $cabs = $this->getCabQueue();
        //如果已经无盘可查
        if (!self::checkDisk($cabs)) {
            //更新信息,进入下一轮
            $this->updateChecker();
        }
    }

    /********************************
     * @param $cabs 存储柜信息
     * @return bool 如果返回值为假，说明所有硬盘已经自检完成，本次自检完美结束
     */
    public function checkDisk($cabs)
    {
        if (!$cabs) return false;
        $is_check_finished = true;
        $db = $this->db;
        foreach ($cabs as $cab) {
            $cab_id = $cab['sn'];
            for ($l = 0; $l < $cab['lvl_cnt']; $l++) {
                $lvl = $l + 1;
                for ($g = 0; $g < $cab['grp_cnt']; $g++) {
                    $grp_busy = false;
                    $grp = $g + 1;
                    //按照优先级排序
                    $dsks = $db->select("*")->from('gui_device')->where("cab_id=$cab_id and level=$lvl and zu=$grp and loaded=1")->query();//orderby(priority)
                    //检查有没有正在工作的
                    if (!$dsks) {
                        continue;
                    }
                    foreach ($dsks as $dsk) {
                        if ($dsk[$this->type . '_status'] == PLAN_STATUS_WORKING) {
                            $is_check_finished = false;
                            $grp_busy = true;
                            break;
                        }
                    }
                    //如果此组硬盘中有正在工作的硬盘，则跳过
                    //否则遍历该组硬盘，找到第一个可以发起自检的
                    if (!$grp_busy) {
                        foreach ($dsks as $dsk) {
                            if ($this->tryStartDisk($dsk)) {
                                //更新磁盘状态
                                $is_check_finished = false;
                                break;
                            }
                        }
                    }
                }
            }
        }
        return $is_check_finished;
    }

    /****
     * @param $sn_time SN更新时间
     * @return bool SN是否是最近更新的
     */
    public function isSnNew($sn_time)
    {
        $now_time = time();
        if ($now_time - (int)$sn_time > 300) {
            return false;
        }
        return true;
    }

    /*****
     * @param $dsk 待启动的盘位
     * @return bool 可启动返回真,不可启动返回false,不可启动的盘位被跳过
     */
    public function tryStartDisk(&$dsk)
    {
        $status = $dsk[$this->type . '_status'];
        $db = $this->db;
        if ($status == PLAN_STATUS_WAITING) {
            //如果该盘被标记为跳过,检查是否到达跳过时间
            if ($dsk[$this->type . '_skipped'] == 1) {
                $time = date('Y-m-d', time());
                $skip_time = date('Y-m-d', (int)$dsk[$this->type . '_skip_time']);
                $time = explode('-', $time);
                $skip_time = explode('-', $skip_time);
                //如果年月日完全相同，说明未到达第二个自然日
                if (!array_diff($time, $skip_time)) {
                    return false;
                }
            }
            if ($this->type == 'md5') {
                $dsk_info = $this->db->select('sn_time')->from("gui_disk")->where('id=:I')->bindValues(array('I' => $dsk['disk_id']))->single();
                //检查SN是否是最新的
                if (!$this->isSnNew($dsk_info['sn_time'])) {
                    if ($dsk['sn_check_status'] != PLAN_STATUS_WORKING) {
                        //发送SN检查指令
                        if ($this->sendCmd($dsk, 'SN')) {
                            //发送成功:更新硬盘状态
                            $db->update("gui_device")->cols(array('sn_check_status' => PLAN_STATUS_WORKING))->where("id={$dsk['id']}")->query();
                            return true;
                        } else {
                            //发送失败:下次再试
                            return false;
                        }
                    } else {
                        //正在检查,表示已经启动
                        return true;
                    }
                }

            }
            if ($this->sendCmd($dsk, $this->type)) {
                //$dsk[$this->type . '_status'] = PLAN_STATUS_WORKING;
                $db->update("gui_device")->cols(array($this->type . '_status' => PLAN_STATUS_WORKING))->where("id={$dsk['id']}")->query();
                return true;
            } else {
                return false;
            }


        } else {
            return false;
        }
    }

    /******
     * @param $plan 当前计划的时间
     * @return bool 为真表示已到预定时间,自检开始
     */
    public function isChecking($plan)
    {
        //如果已经开始,返回真
        if ($plan['status'] == PLAN_STATUS_WORKING) {
            return true;
        }
        //如果未开始,检查是否到达预定时间
        $curr_time = time();

        //时间已到,而且当前没有其他自检计划正在进行
        if ($curr_time >= int($plan['time'])) {
            if ($this->isCabBusy())
                return false;
            $this->startCheck($plan);
            return true;
        } else {
            return false;
        }
    }

    /*****
     * @return mixed 检查当前是否有正在执行的计划,如果有,则暂停启动本计划
     */
    public function isCabBusy()
    {
        $db = $this->db;
        $plans = $db->select("id")->from($this->tbl_plan)->where('status=:F')->bindValue(array('F' => PLAN_STATUS_WORKING))->query();
        if (!$plans) {
            return false;
        }
        return true;
    }

    /******
     * @param $plan 启动计划
     */
    public function startCheck($plan)
    {
        //更改当前计划状态
        $this->status = $plan['status'] = PLAN_STATUS_WORKING;
        $this->db->update($this->tbl_plan)->cols($plan)->where("id={$plan['id']}")->query();//修改状态
        //如果尚未增加新计划
        if ($this->next_plan == 0) {
            if ($next_plan = $this->addNewPlan()) {
                $this->next_plan = $next_plan['id'];
            }
        }
    }

    //检查当前计划是否已经结束：超时、被终结、其他计划已开始等
    public function isAlive($plan)
    {
        $db = $this->db;
        //如果处于非工作非等待状态
        if ($plan['status'] > PLAN_STATUS_WORKING) {
            $this->RunLog("This plan has finished or timed out.");
            return false;
        }
        $plans = $db->select('*')->from($this->tbl_plan)->where("status=-1 and type='{$this->type}'")->orderby(array('start_time'))->query();//修改状态
        //如果不存在其他计划,不正常,退出;
        if (!$plans) {
            //增加计划
            //$this->addNewPlan();
            return true;
        }
        foreach ($plans as $item) {
            //找到下一个计划
            if ($item['id'] != $plan['id']) {
                //如果已到下一个计划的时间,则当前计划终止
                if (time() > (int)$item['start_time']) {
                    $this->RunLog("Next plan has dued. This plan is finishing.");
                    return false;
                }
                return true;
            }
        }
        return true;
    }

    public function updateChecker()
    {
        $db = $this->db;
        if (!$cabs = $this->getCabQueue())
            return;
        $this->RunLog("Plan over. Resetting the status of disks.");
        //遍历每个硬盘,如果状态为未完成,设为完成,priority+1;如果已完成,priority=0;
        foreach ($cabs as $cab) {
            $cab_id = $cab['sn'];
            for ($l = 0; $l < $cab['lvl_cnt']; $l++) {
                $lvl = $l + 1;
                for ($g = 0; $g < $cab['grp_cnt']; $g++) {
                    $grp = $g + 1;
                    for ($d = 0; $d < $cab['dsk_cnt']; $d++) {
                        $idx = $d + 1;
                        $dsks = $db->select("*")->from('gui_device')->where("cab_id=$cab_id and level=$lvl and zu=$grp and disk=$idx and loaded=1")->query();
                        if ($dsks) {
                            $status = $this->type == 'md5' ? $dsks[0]['md5_status'] : $dsks[0]['sn_status'];
                            if ($status == PLAN_STATUS_WAITING) {
                                $dsks[0][$this->type . '_priority'] = (int)$dsks[0][$this->type . '_priority'] + 1;
                            } else {
                                $dsks[0][$this->type . "_status"] = PLAN_STATUS_WAITING;
                            }
                            //update
                            $dsk = $dsks[0];
                            $dsk['sn_check_status'] = PLAN_STATUS_WAITING;
                            $db->update('gui_device')->cols($dsk)->where("id={$dsk['id']}")->query();
                        }

                    }
                }
            }
        }
        //将原先的计划
        $this->status = PLAN_STATUS_WAITING;
        if ($this->next_plan == 0) {
            //增加新计划
            $new_plan = $this->addNewPlan();
            $this->plan_id = $new_plan['id'];
        } else {
            $this->plan_id = $this->next_plan;
        }
        $this->next_plan = 0;
    }

    public function getCabQueue()
    {
        $db = $this->db;
        $cab_tbl = "gui_cab";
        $cabs = $db->select("*")->from($cab_tbl)->where("loaded=1")->query();
        return $cabs;
    }

    public function getPlan($config, $start_t)
    {
        //根据配置信息获取时间
        //Unit是天时
        $plan_t = null;
        $start_t = strtotime(date('Y-m-d', $start_t));
        switch ($config['unit']) {
            case 'day':
                //$start_t = time();//strtotime($start_date);
                $plan_t = $start_t + $config['cnt'] * 24 * 3600 + $config['start_time'] * 3600;//开始日期加天数加起始时间
                break;
            case 'week':
                // $start_t = time();
                $plan_t = $start_t + $config['cnt'] * 7 * 24 * 3600 + $config['start_time'] * 3600;//开始日期加天数加起始时间
                break;
            case 'month':
                //获取月份
                $start_date = date("Y-m-d", $start_t);
                $date_param = explode('-', $start_date);
                $yr = (int)$date_param[0] + floor(((int)$date_param[1] + $config['cnt']) / 12);
                $mth = ((int)$date_param[1] + $config['cnt']) % 12;
                if ($mth == 0) {
                    $mth = 12;
                }
                $day_cnt = self::getDaysPerMonth($yr, $mth);
                $day = (int)$date_param[2] <= $day_cnt ? (int)$date_param[2] : $day_cnt;
                $plan_t = strtotime($yr . "-" . $mth . "-" . $day);
                $plan_t = $plan_t + +$config['start_time'] * 3600;
                break;
            case 'season':
                $start_date = date("Y-m-d", $start_t);
                $date_param = explode('-', $start_date);
                $yr = (int)$date_param[0] + floor(((int)$date_param[1] + $config['cnt'] * 3) / 12);
                $mth = ((int)$date_param[1] + $config['cnt'] * 3) % 12;
                if ($mth == 0) {
                    $mth = 12;
                }
                $day_cnt = self::getDaysPerMonth($yr, $mth);
                $day = (int)$date_param[2] <= $day_cnt ? (int)$date_param[2] : $day_cnt;
                $plan_t = strtotime($yr . "-" . $mth . "-" . $day);
                $plan_t = $plan_t + +$config['start_time'] * 3600;

        }
        //生成计划
        $plan = array(
            'modify_time' => time(),
            'start_time' => $plan_t,
            'status' => PLAN_STATUS_WAITING,
            'type' => $config['type']);
        // $this->db->insert($this->tbl_plan)->cols($plan)->query();
        return $plan;
    }

    public function getDaysPerMonth($y, $m)
    {
        if ($m >= 12) {
            return 30;
        }
        $next_mth = $m + 1;
        $t = (strtotime("1-" . $next_mth . "-" . $y) - strtotime("1-" . $m . "-" . $y));
        $days = $t / (60 * 60 * 24);
        //  echo $days;
        return $days;
    }

    /*****
     * @param null $start_t 计划的相对时间，默认为空
     * @return array|null 返回新增的计划
     */
    public function addNewPlan($start_t = null)
    {
        $this->RunLog("Inserting new plan.");
        $type = $this->type;
        $db = $this->db;
        $plan = null;
        $config = $db->select("*")->from($this->tbl_conf)->where("type=:T and is_current=1")->bindValues(array('T' => $type))->single();
        if ($config) {
            //根据配置生成新的plan
            if (!$start_t) {
                $start_t = time();
            }
            $plan = $this->getPlan($config, $start_t);
            $plan_id = $db->insert($this->tbl_plan)->cols($plan)->query();
            if (!$plan_id) {
                $plan = null;
            } else {
                $plan['id'] = $plan_id;
            }
        }
        return $plan;
    }

    public function sendCmd($dsk, $type)
    {

        //生成cmd,插入CmdLog
        $db = $this->db;
        $tbl_cmd_log = "gui_cmd_log";
        $new_cmd = array(
            'cmd' => strtoupper($type),
            'sub_cmd' => 'START',
            'user_id' => '0',
            'status' => PLAN_STATUS_WAITING,
            'start_time' => time(),
            'finished' => 0
        );
        $this->RunLog("Sending commond: Adding commond log.");
        $cmd_id = $db->insert($tbl_cmd_log)->cols($new_cmd)->query();
        if ($cmd_id) {
            $this->RunLog("Sending commond: Command log added.");
            $ch = curl_init();
            $url = 'localhost:8080';
            $header = array(
                'Content-Type:application/json'//x-www-form-urlencoded'
            );
            $data = array(cmd => strtoupper($type),
                'CMD_ID' => $cmd_id,
                'device_id' => $dsk['cab_id'],
                'level' => $dsk['level'],
                'group' => $dsk['zu'],
                'index' => $dsk['disk'],
                'subcmd' => 'START'
            );
            // 添加apikey到header
            curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
            // 添加参数
            curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
            // 执行HTTP请求
            curl_setopt($ch, CURLOPT_URL, $url);
            $res = curl_exec($ch);
            $this->RunLog("Sendding commond: Commond sent to app.");

            // 通知前端
            $msg = array('type' => 'selfcheck', 'user_id'=>0,'dsk'=>$dsk,'cmd'=>strtoupper($type),'subcmd'=>'START','cmd_id'=>$cmd_id);
            //$ret = array_merge($ret, $attached);
            ExtendGateWay::sendToAll(json_encode($msg));
            return true;
        } else {
            $this->RunLog("Sendding commond: Failed to add commond log.");
            return false;
        }
    }
}

// gateway 进程
$gateway = new Gateway("Websocket://0.0.0.0:8383");
// 设置名称，方便status时查看
$gateway->name = 'ChatGateway';
// 设置进程数，gateway进程数建议与cpu核数相同
$gateway->count = 4;
// 分布式部署时请设置成内网ip（非127.0.0.1）
$gateway->lanIp = '127.0.0.1';
// 内部通讯起始端口，假如$gateway->count=4，起始端口为4000
// 则一般会使用4000 4001 4002 4003 4个端口作为内部通讯端口 
$gateway->startPort = 2300;
// 心跳间隔
$gateway->pingInterval = 60;
// 心跳数据
$gateway->pingData = '{"type":"ping"}';
// 服务注册地址
$gateway->registerAddress = '127.0.0.1:1236';


/*
// 当客户端连接上来时，设置连接的onWebSocketConnect，即在websocket握手时的回调
$gateway->onConnect = function($connection)
{
    $connection->onWebSocketConnect = function($connection , $http_header)
    {
        // 可以在这里判断连接来源是否合法，不合法就关掉连接
        // $_SERVER['HTTP_ORIGIN']标识来自哪个站点的页面发起的websocket链接
        if($_SERVER['HTTP_ORIGIN'] != 'http://chat.workerman.net')
        {
            $connection->close();
        }
        // onWebSocketConnect 里面$_GET $_SERVER是可用的
        // var_dump($_GET, $_SERVER);
    };
}; 
*/
$gateway->onWorkerStart = function ($worker) {

    // 只在id编号为0的进程上设置定时器，其它1、2、3号进程不设置定时器
    $deviceStatusTimer = Timer::add(300, function () {
        //检查用户数量,如果无用户就不查询
        $cnt = ExtendGateWay::getAllClientCount();
        if ($cnt <= 0) {
            echo "No user";
            return;
        }
        $db = Db::instance('db1');
        //查询多进程
        $ret = $db->select('*')->from('gui_cab')->where('loaded=1')->query();
        //有连接的柜子存在
        if ($ret) {
            $num = count($ret);
            $attached = array('type' => 'status', 'num' => $num);
            $ret = array_merge($ret, $attached);
            ExtendGateWay::sendToAll(json_encode($ret));
            //查询磁盘容量
            $ret = $db->select('partition')->from('gui_device')->where('loaded=1 and bridged=1')->query();

            if (!$ret) {
                return;
            }
            $num = count($ret);
            $attached = array('type' => 'partition', 'num' => $num);
            $ret = array_merge($ret, $attached);
            ExtendGateWay::sendToAll(json_encode($ret));
        }
    });


};
// 如果不是在根目录启动，则运行runAll方法
if (!defined('GLOBAL_START')) {
    Worker::runAll();
}

