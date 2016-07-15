<?php
/**
 * This file is part of workerman.
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the MIT-LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author    walkor<walkor@workerman.net>
 * @copyright walkor<walkor@workerman.net>
 * @link      http://www.workerman.net/
 * @license   http://www.opensource.org/licenses/mit-license.php MIT License
 */
namespace GatewayWorker\Lib;


use GatewayWorker\Lib\Db;
use GatewayWorker\Lib\Gateway as ExtendGateWay;
use Exception;

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
    public $tbl_start_date = 'gui_check_start_date';
    public $start_date = null;
    public $app_addr = "localhost:8080";
    /****
     * @param $_t type
     * @param $_i interval
     */
    public function init($_t, $_i, $_db)
    {
        $this->RunLog("Initializing the self check status\n Checker Type:" . $_t . " \nTime interval: " . $_i . "Seconds.");
        $this->timerInterval = $_i;
        $this->type = $_t;
        $this->db = $_db;
        if ($plan = $this->getCurrPlan()) {
            $this->plan_id = $plan['id'];
        }

    }

    public function RunLog($str)
    {
        $msg = array('type' => 'check_status', 'msg' => "Type: {$this->type}. Status: " . $str, 'time' => time());
     //   $db = DB::instance("db1");
     //   $db->insert('gui_system_run_log')->cols($msg)->query();
        ExtendGateWay::sendToAll(json_encode($msg));
    }

    public function getCurrPlan()
    {
        $db = $this->db;
        $plan = null;
        $plans = $db->select('*')->from($this->tbl_plan)->where("status<1 and type='{$this->type}'")->orderby(array('status'))->query();
        if ($plans) {
            //取status最大的那个计划
            $plan = $plans[count($plans) - 1];
            $this->RunLog("Number of available plans: " . count($plans) . ". Status of current plan: " . $plan['status']);
        } else
            $plan = $this->addNewPlan();

        return $plan;
    }

    /****
     * 自检函数
     */
    public function mainCheck()
    {
        $db = $this->db = Db::instance('db1');
        if (!$db) {
            $this->RunLog("Database not connected.");
            return;
        } else {
            $this->RunLog("Database connected.");
        }
        //如果当前没有自检计划,返回
        $this->RunLog("Retriving the plan.");
        $plan = $this->getCurrPlan();
        if (!$plan) {
            $this->RunLog("No Plan. Aborting");
            return;
        }

        if ($plan['status'] == PLAN_STATUS_WAITING) {
            //尝试启动自检计划,如果启动失败则返回
            $this->RunLog("The check plan is not started. Trying to start it.");
            if (!$this->startCheck($plan))
                return;
        } elseif ($plan['status'] == PLAN_STATUS_WORKING) {
            $this->RunLog("Check start time.");
            //检查自检时间是否已经更新,如果未更新则更新
            $curr_start_t = null;//$db->select("start_date")->from($this->tbl_start_date)->where("type=:T and is_current=1")->bindValues(array('T' => $this->type))->single();
            $this->RunLog("Check finished");
            if($curr_start_t)
            {
                $this->RunLog("Current start time:".$curr_start_t['start_date']);
            }
            else{
                $this->RunLog("No start time available. Inserting....");
            }
            if (!$curr_start_t || (int)$plan['start_time'] - (int)$curr_start_t['start_date'] > (24 * 3600)) {
                $this->RunLog("Updating start time....");
               // $this->updateStartDate($plan['start_time']);
            }
            $this->RunLog("Check start time finished.");
        }
        $this->RunLog("Get cabinet information.");
        //获取存储柜信息
        $cabs = $this->getCabQueue();
        $this->RunLog("Start to check disks.");
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
        if (!$cabs) {
            $this->RunLog("Error: failed to get cabinet information.");
            return false;
        }
        $this->RunLog("Going to check " . count($cabs) . " cabinets.");
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
                    $this->RunLog("Working on cabinet No." . $cab_id . " Level: $lvl Group $grp .");
                    //检查有没有正在工作的
                    if (!$dsks) {
                        continue;
                    }
                    foreach ($dsks as $dsk) {
                        if ($dsk[$this->type . '_status'] == PLAN_STATUS_WORKING) {
                            $is_check_finished = false;
                            $grp_busy = true;
                            $this->RunLog("Group #" . $cab_id . "-$lvl-$grp is busy. Aborting on this group.");
                            break;
                        }
                    }
                    //如果此组硬盘中有正在工作的硬盘，则跳过
                    //否则遍历该组硬盘，找到第一个可以发起自检的
                    if (!$grp_busy) {
                        $this->RunLog("Group #" . $cab_id . "-$lvl-$grp is free.");
                        foreach ($dsks as $dsk) {
                            $this->RunLog("Trying to start checking disk #" . $cab_id . "-$lvl-$grp-" . $dsk['disk']);
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
        return true;
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
                    $this->RunLog("Disk is skipped. Will check it on some other day.");
                    return false;
                }
            }
            /*
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
*/
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
        if ($curr_time >= int($plan['start_time'])) {
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
     * @return bool 返回启动是否成功的结果
     */
    public function startCheck($plan)
    {

        if (time() <= (int)$plan['start_time']) {
            $this->RunLog("The plan will start in about " . ((int)$plan['start_time'] - time()) . " seconds.");
            return false;
        }
        //更改当前计划状态
        $plan['status'] = PLAN_STATUS_WORKING;
        $rst = $this->db->update($this->tbl_plan)->cols($plan)->where("id={$plan['id']}")->query();//修改状态
        if (!$rst) {
            $this->RunLog("Error: Failed to start the plan :( Will try again later.");
        } else {
            $this->updateStartDate();
            $this->RunLog("Congratulation: Success to start the plan :)");
        }

        //更改
        return $rst;
    }

    /******
     * 更新系统的自检启动时间: 需要检查是否更新成功
     * @param $_start_date 启动时间
     */
    public function updateStartDate($_start_date = null)
    {
        if (!$_start_date) {
            $_start_date = time();
        }
        $item = $this->db->select("*")->from("gui_check_start_time")->where("type=:T and is_current=1")->bindValues(array('T' => $this->type))->single();
        $rst = true;
        //如果有时间,更新
        if ($item) {
            $item['start_date'] = $_start_date;
            $rst = $this->db->update("gui_check_start_time")->cols($item)->where("id={$item['id']}")->query();

        } else {
            //如果没有时间,插入
            $item = array(
                'start_date' => $_start_date,
                'type' => $this->type,
                'is_current' => 1
            );
            $rst = $this->db->insert("gui_check_start_time")->cols($item)->query();
        }
        if (!$rst) {
            $this->RunLog("Error: Failed to update start date :(");
        } else {
            $this->start_date = time();
            $this->RunLog("Success: Updated start date :)");
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
        $this->RunLog("Plan status:" . $plan['status']);
        return true;
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
                        $dsk = $db->select("*")->from('gui_device')->where("cab_id=$cab_id and level=$lvl and zu=$grp and disk=$idx and loaded=1")->single();
                        if ($dsk) {
                            $dsk[$this->type . "_status"] = PLAN_STATUS_WAITING;
                            $dsk['sn_check_status'] = PLAN_STATUS_WAITING;
                            $db->update('gui_device')->cols($dsk)->where("id={$dsk['id']}")->query();
                        }

                    }
                }
            }
        }

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
                $plan_t = $start_t + $config['cnt'] * 24 * 3600 + $config['hour'] * 3600;//开始日期加天数加起始时间
                break;
            case 'week':
                // $start_t = time();
                $plan_t = $start_t + $config['cnt'] * 7 * 24 * 3600 + $config['hour'] * 3600;//开始日期加天数加起始时间
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
                $plan_t = $plan_t + +$config['hour'] * 3600;
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
                $plan_t = $plan_t + +$config['hour'] * 3600;

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
        if ($config)
            $this->RunLog("Config-information: unit-" . $config['unit'] . "-count-" . $config['cnt']);
        else {
            $this->RunLog("Error: No self check configuration available.");
        }
        if ($config) {
            //根据配置生成新的plan
            if (!$start_t) {
                $item = $db->select("start_date")->from($this->tbl_check_start_time)->where("type=:T and is_current=1")->bindValues(array('T' => $type))->single();
                if (!$item) {
                    $this->RunLog("Error: No start date was found. Quit.");
                    return null;
                }
                $start_t = (int)$item['start_date'];
            }

            $plan = $this->getPlan($config, $start_t);
            if (!$plan) {
                $this->RunLog("Error: Failed to create a new plan.");
                return null;
            }
            $plan_id = $db->insert($this->tbl_plan)->cols($plan)->query();
            if (!$plan_id) {
                $plan = null;
                $this->RunLog("Error: Failed to insert the plan into database.");
            } else {
                $this->RunLog("Success to create a new plan :) Congratulation!");
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
            $url = $this->app_addr;
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
            $msg = array('type' => 'selfcheck', 'user_id' => 0, 'dsk' => $dsk, 'cmd' => strtoupper($type), 'subcmd' => 'START', 'cmd_id' => $cmd_id);
            //$ret = array_merge($ret, $attached);
            ExtendGateWay::sendToAll(json_encode($msg));
            return true;
        } else {
            $this->RunLog("Sendding commond: Failed to add commond log.");
            return false;
        }
    }
}
