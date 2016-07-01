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
define('PLAN_STATUS_CANCELED', 2, true);
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
    public $tbl_conf = 'gui_autocheck_conf';

    /****
     * @param $_t type
     * @param $_i interval
     */
    public function init($_t, $_i, $_db)
    {
        $this->timerInterval = $_i;
        $this->type = $_t;
        $this->db = $_db;
        if ($plan = $this->getCurrPlan()) {
            $this->plan_id = $plan['id'];
        }
    }

    /***
     * 定时器
     */
    public function Run()
    {

    }

    public function getCurrPlan()
    {
        $db = $this->db;
        $plan = null;
        if ($this->plan_id == 0) {
            $plans = $db->select('*')->from($this->tbl_plan)->where("status=-1 and type='{$this->type}'")->orderby(array('time','asc'))->query();
            //->bindValues(array('statys'));
            //取时间最早的计划
            if ($plans) {
                $plan = $plans[0];
                $this->plan_id = $plan['id'];
                $this->status = $plan['status'];
            } else {
                //根据配置项增加新计划
                $plan = $this->addNewPlan();
                echo "There is no available plan.";
            }
        } else {
            $plan = $db->select('*')->from($this->tbl_plan)->where("id={$this->plan_id}")->single();
            if (!$plan) {
                $this->plan_id = 0;
                echo "The plan {$this->plan_id} has been removed";
            }
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
            echo "Database not connected.";
            return;
        }
        //如果当前没有自检计划,返回
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

    public function checkDisk($cabs)
    {
        if (!cabs) return false;
        $db = $this->db;
        foreach ($cabs as $cab) {
            $cab_id = $cab['sn'];
            for ($l = 0; $l < $cab['lvl_cnt']; $l++) {
                $lvl = $l + 1;
                for ($g = 0; $g < $cab['grp_cnt']; $g++) {
                    $grp_busy = false;
                    $grp = $g + 1;
                    //按照优先级排序
                    $dsks = $db->select("*")->from('gui_device')->where("cab_id=$cab_id and level=$lvl and zu=$grp and loaded=1")->orderby('priority desc')->query();
                    //检查有没有正在工作的
                    foreach ($dsks as $dsk) {
                        if ($dsk[$this->type . '_status'] == PLAN_STATUS_WORKING) {
                            $grp_busy = true;
                            break;
                        }
                    }
                    if ($grp_busy) {
                        break;
                    } else {
                        foreach ($dsks as $dsk) {
                            if ($this->tryStartDisk($dsk)) {
                                break;
                            }
                        }
                    }
                }
            }
        }
    }

    /*****
     * @param $dsk 待启动的盘位
     * @return bool 可启动返回真,不可启动返回false,不可启动的盘位被跳过
     */
    public function tryStartDisk($dsk)
    {
        $status = $this->type == 'md5' ? $dsk[0]['md5_status'] : $dsk[0]['sn_status'];
        if ($status == PLAN_STATUS_WAITING) {
            //如果该盘被标记为跳过,检查是否到达跳过时间
            if ($dsk[$this->type . '_skipped'] == 1) {
                $time = date('Y-m-d', time());
                $skip_time = date('Y-m-d', (int)$dsk[$this->type . '_skip_time']);
                $time = explode('-', $time);
                $skip_time = explode('-', $skip_time);
                if ((int)$time[2] - (int)$skip_time[2] <= 0) {
                    return false;
                }
            }
            if ($this->type == 'md5') {
                switch ($dsk['sn_check_status']) {
                    case PLAN_STATUS_WAITING:
                        //发送查验指令
                        $this->sendCmd($dsk, 'SN');
                        $dsk['sn_check_status'] = PLAN_STATUS_WORKING;
                        //修改查验状态
                        return true;
                        break;
                    case PLAN_STATUS_WORKING:
                        return true;
                    break;
                    case PLAN_STATUS_FINISHED:
                        $this->sendCmd($dsk,$this->type);
                        $dsk[$this->type.'_status'] = PLAN_STATUS_WORKING;
                        return true;
                        break;
                    default:
                        //SN检查未通过
                        return false;

                }
            }


            return true;

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
        if ($curr_time >= int($plan['time']) && !$this->isCabBusy()) {
            $this->startCheck($plan);
            return true;
        } else {
            return false;
        }
    }

    /*****
     * @return mixed 检查当前是否有正在执行的计划,如果有,则暂停启动本计划
     */
    public function isCabBusy(){
        $db = $this->db;
        return $db->select("*")->from($this->tbl_plan)->where('status=1')->query();

    }
    /******
     * @param $plan 启动计划
     */
    public function startCheck($plan)
    {
        //更改当前计划状态
        $this->status = $plan['status'] = PLAN_STATUS_WORKING;
        $this->db->select('*')->from($this->tbl_plan)->where("id={$plan['id']}")->update();//修改状态
        //如果尚未增加新计划
        if ($this->next_plan == 0) {
            if ($next_plan = $this->addNewPlan()) {
                $this->next_plan = $next_plan['id'];
            }
        }
    }

    //检查当前计划是否过期
    public function isAlive($plan)
    {
        $db = $this->db;
        //如果处于非工作非等待状态
        if ($plan['status'] > PLAN_STATUS_WORKING) {
            return false;
        }
        $plans = $db->select('*')->from($this->tbl_plan)->where("status=-1 and type='{$this->type}'")->orderby(array('time','asc'))->query();//修改状态
        //如果不存在其他计划,不正常,退出;
        if (!$plans) {
            //增加计划
            //$this->addNewPlan();
            return true;
        }
        foreach ($plans as $plan) {
            //找到下一个计划
            if ($plan['id'] != $this->plan_id) {
                //如果已到下一个计划的时间,则当前计划终止
                if (time() > (int)$plan['time']) {
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
                            $dsk = $dsks[0];
                            $status = $this->type == 'md5' ? $dsk[0]['md5_status'] : $dsk[0]['sn_status'];
                            if ($status == PLAN_STATUS_WAITING) {
                                $dsks[0][$this->type . '_priority'] = (int)$dsks[0][$this->type . '_priority'] + 1;
                            } else {
                                $dsks[0][$this->type . "_status"] = PLAN_STATUS_WAITING;
                            }
                            //update
                            $db->update($dsk);
                        }

                    }
                }
            }
        }
        //将原先的计划
        $this->status = PLAN_STATUS_WAITING;
        if ($this->next_plan == 0) {
            //增加新计划
            $this->plan_id = $this->addNewPlan();
        } else {
            $this->plan_id = $this->next_plan;
            $this->next_plan = 0;
        }
    }

    public function getCabQueue()
    {
        $db = $this->db;
        $cab_tbl = "gui_cab";
        $cabs = $db->select("*")->from($cab_tbl)->where("loaded=1")->query();
        return $cabs;
    }

    public function addNewPlan()
    {

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

