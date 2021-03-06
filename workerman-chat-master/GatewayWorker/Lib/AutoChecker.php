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
header("Content-Type:text/html;charset=gb2312");

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
define('PLAN_STATUS_TIMEOUT', 4, true);
define('MAX_WORK_DISK_NUM',15,true);
define('TBL_DEVICE',"gui_device",true);
define('MAX_CHECK_TIME',5,true);

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
    public $tbl_start_date = 'gui_check_start_time';
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
            return;
        }
        //如果当前没有自检计划,返回
        $plan = $this->getCurrPlan();
        if (!$plan) {
            return;
        }

        if ($plan['status'] == PLAN_STATUS_WAITING) {
            //尝试启动自检计划,如果启动失败则返回
            if (!$this->startCheck($plan))
                return;
        } elseif ($plan['status'] == PLAN_STATUS_WORKING) {
            //检查自检时间是否已经更新,如果未更新则更新
            $curr_start_t = $db->select("start_date")->from($this->tbl_start_date)->where("type=:T and is_current=:C")->bindValues(array('T' => $this->type, 'C' => 1))->single();

            if (!$curr_start_t || (int)$plan['start_time'] - (int)$curr_start_t > (24 * 3600)) {
                $this->updateStartDate($plan['start_time']);
            }
        }
        //获取存储柜信息
        $cabs = $this->getCabQueue();
        //检查是否有未更新自检状态的磁盘，并予以更新，以防止堵塞
        $this->checkCmdStatus($plan);
        //return;
        //如果已经无盘可查
        if ($check_finished = $this->checkDisk($cabs) || $this->isCheckDue($plan)) {
            //更新信息,进入下一轮
            if(!$this->isCheckFinished() && !$this->isCheckDue($plan)){
                return;
            }
            $this->RunLog("Check over.".$check_finished);
            $this->updateChecker($plan, $cabs);
        }
        
    }

    /**********
     * @param $sts proxy推送的状态
     * @return bool true:健康,false:异常
     */
    public function getCabHealth($sts){
        if($sts['elec_sts']){
            if((int)$sts['elec_sts'] == 2)
                return false;
        }
        if($sts['curr_sts']){
            if((int)$sts['curr_sts'] == 2)
                return false;
        }
        if($sts['volt_sts']){
            if((int)$sts['volt_sts'] == 2)
                return false;
        }
        return true;
    }
    /**********
     * @param $sts proxy推送的状态
     * @return bool true:健康,false:异常
     */
    public function getLvlHealth($sts){
        //湿度异常
        if($sts['hum_sts']){
            if((int)$sts['hum_sts'] == 2)
                return false;
        }
        //温度异常
        if($sts['temp_sts']){
            if((int)$sts['temp_sts'] == 2)
                return false;
        }
        //串口异常
        if($sts['chan_sts']){
            if((int)$sts['volt_sts'] == 1)
                return false;
        }
        return true;
    }
    private function getBusyDisks(){
        $db = $this->db;
        $cond = "gui_cmd_log.finished=0";
        $dsks = $this->db->select("gui_cmd_disk.*,gui_cmd_log.cmd")
            ->from('gui_cmd_disk')
            ->innerJoin("gui_cmd_log", "gui_cmd_disk.cmd_id = gui_cmd_log.id")
            ->orderBy(array("cab"))->where($cond)->query();
        return $dsks;
    }
    private function isDiskBusy($dsks,$cab,$lvl,$grp){
       foreach ($dsks as $item){
           if($item['db_cab_id'] == $cab &&  $item['level'] == $lvl && $item['group'] == $grp){
               return true;
           }
       }
        return false;
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

        $is_check_finished = true;
        $grp_busy = null;
        $grp_skipped = null;
        $db = $this->db;
        //记录正在自检或忙碌的硬盘数量
        $busy_disks = $this->getBusyDisks();
        foreach ($cabs as $cab) {
            $cab_id = (int)$cab['sn'];
            $db_cab_id = $cab['id'];
            $busy_num = $this->checkBusyNum($cab_id);
            if($busy_num > MAX_WORK_DISK_NUM){
                continue;
            }
            $cab_status = json_decode($cab['status'], true);
            $levels = $cab_status['levels'];
            if(!$this->getCabHealth($cab_status)){
                //存储柜健康异常,跳过
                $this->RunLog("Cabinet $cab_id status error. Aborting.");
                continue;
            }
            for ($l = 0; $l < $cab['level_cnt']; $l++) {
                $level_health = true;
                $lvl = $l + 1;
                //检查该层的健康状况,如果健康状况不佳则跳过
                if ($levels) {
                    foreach ($levels as $item) {
                        if ((int)$item['id'] == $lvl) {
                            $level_health = $this->getLvlHealth($item);
                            break;
                        }
                    }
                }
                if(!$level_health){
                    //故障,跳过
                    $this->RunLog("Level $lvl status error. Aborting.");
                    continue;
                }
                for ($g = 0; $g < $cab['group_cnt']; $g++) {
                    $grp_busy = false;
                    $grp_skipped = false;
                    $grp = $g + 1;
                    if($this->isDiskBusy($busy_disks, $db_cab_id, $lvl, $grp)){
                        $grp_busy = true;
                    }
                    //按照优先级排序
                    $dsks = $db->select("*")->from('gui_device')->where("cab_id=$cab_id and level=$lvl and zu=$grp and loaded=1")->query();//orderby(priority)
                    //检查有没有正在工作的
                    if (!$dsks) {
                        continue;
                    }
                    foreach ($dsks as $dsk) {
                        if (!is_null($dsk[$this->type . '_status']) && $dsk[$this->type . '_status'] == PLAN_STATUS_WORKING) {
                            $is_check_finished = false;
                            $grp_busy = true;

                           // break;
                        }
                       // $this->RunLog("Status working: ".$grp_busy);
                        //磁盘操作中或者桥接中
                        if($dsk['busy'] === 1 || $dsk['bridged'] === 1){
                            $grp_busy = true;
                        }
                       // $this->RunLog("Commond or bridged: ".$grp_busy);
                        //检查是否有漏网之鱼
                        if($dsk[$this->type . '_status'] < PLAN_STATUS_FINISHED){
                            $is_check_finished = false;
                        }
                        

                        if($this->type == 'md5' && $dsk['md5_skipped'] == 1){
                            if(time() - (int)$dsk['md5_skip_time'] > 24 * 3600){
                            $this->setDiskNoSkip($dsk);
                            }
                            else{
                                $grp_skipped = true;
                                $this->RunLog("Group is skipped at:".date("Y-m-d H:i:s",(int)$dsk['md5_skip_time']));
                            }
                        }

                    }
                    if($grp_busy)
                    $this->RunLog("Group $cab_id-$lvl-$grp is busy");
                    //如果此组硬盘中有正在工作的硬盘，则跳过

                    if (!$grp_busy && !$grp_skipped) {
                        foreach ($dsks as $dsk) {
                            if($busy_num >= MAX_WORK_DISK_NUM){
                                break;
                            }
                            $dsk['db_cab_id'] = $db_cab_id;
                            if ($this->tryStartDisk($dsk)) {
                                //更新磁盘状态
                                $busy_num = $busy_num + 1;
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
    private function isCheckFinished(){
        $db =  $this->db;
        $dsks = $db->select("*")->from('gui_device')->where("loaded=1")->query();//orderby(priority)
        if(!$dsks){
            $this->RunLog("Error: No disk found.");
            return false;
        }
        $status = $this->type."_status";
        foreach ($dsks as $dsk){
            if($dsk[$status] == PLAN_STATUS_WORKING || $dsk[$status] == PLAN_STATUS_WAITING){
                return false;
                break;
            }
        }
        return true;
    }
    private function isCheckDue($plan){
        $tbl = "gui_check_start_time";
        $items = $this->db->select("*")->from("gui_check_start_time")->where("type=:T and is_current=:C")->bindValues(array('T' => $this->type, 'C' => 1))->query();
        $time_limit = 0;
        //MD5需要2倍的时间
        if($this->type == 'md5')
            $time_limit = 10 * 24 * 3600;
        else
            $time_limit = 5 * 24 * 3600;
        //如果有时间,更新
        if ($items) {
            $item = $items[0];
            $used_time = time() - (int)$item['start_date'];
            if($used_time > $time_limit){
                return true;
            }
            else{
                return false;
            }
        }
        return true;
    }
    private function setDiskNoSkip($dsk){
        if(!$dsk){
            return;
        }
        $dsk['md5_skipped'] = 0;
        $dsk['md5_skip_time'] = '';
        $cond = "id=:I";
        $bind = array("I"=>$dsk['id']);
        $this->db->update("gui_device")->cols($dsk)->where($cond)->bindValues($bind)->query();
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
            if ($this->type == 'md5' && $dsk['md5_skipped'] == 1) {

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
            if ($this->sendCmd($dsk, $this->type,$dsk['db_cab_id'])) {
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
        $plans = $db->select("id")->from($this->tbl_plan)->where('status=:F')->bindValues(array('F' => PLAN_STATUS_WORKING))->query();
        if (!$plans) {
            return false;
        }
        return true;
    }

    public function resetDiskStatus()
    {
        $status = $this->type . "_status";

        $dsks = $this->db->select("id," . $this->type . "_cmd_id," . $this->type . "_status")->from("gui_device")->where("loaded=:L")->bindValues(array('L' => 1))->query();
        foreach ($dsks as $dsk) {
            if ($dsk[$status] !== PLAN_STATUS_WORKING) {
                $dsk[$status] = PLAN_STATUS_WAITING;
                $dsk['md5_skipped'] = 0;
                $this->db->update("gui_device")->cols($dsk)->where("id=:I")->bindValues(array('I' => $dsk['id']))->query();
            }
        }

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
        if ($this->isCabBusy()) {
            $this->RunLog("The cab is busy. Waiting for the cab to be free.");
            return false;
        }
        //更改当前计划状态
        $plan['status'] = PLAN_STATUS_WORKING;
        $rst = $this->db->update($this->tbl_plan)->cols($plan)->where("id={$plan['id']}")->query();//修改状态
        if (!$rst) {
            $this->RunLog("Error: Failed to start the plan :( Will try again later.");
        } else {
            $this->broadCheckStatus($plan);
            $this->updateStartDate();
            $this->resetDiskStatus();
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
        $items = $this->db->select("*")->from("gui_check_start_time")->where("type=:T and is_current=:C")->bindValues(array('T' => $this->type, 'C' => 1))->query();
        $rst = true;
        //如果有时间,更新
        if ($items) {
            $item = $items[0];
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
        $used_time = time() - (int)$plan['start_time'];
        $configs = $db->select("*")->from($this->tbl_conf)->where("type=:T and is_current=:C")->bindValues(array('T' => $this->type, 'C' => 1))->query();

        if ($configs) {
            $config = $configs[0];
            $unit = 0;
            switch($config['unit']){
                case 'day':
                    $unit = 1;
                    break;
                case 'week':
                    $unit = 7;
                    break;
                case 'month':
                    $unit = 30;
                    break;
                case 'season':
                    $unit = 90;
                    break;
            }
            if($unit*$config['cnt']*3600 < $used_time){
                //设置为超时
                $plan['status'] = PLAN_STATUS_TIMEOUT;
                $this->db->update($this->tbl_plan)->cols($plan)->where("id=:I")->bindValues(array('I'=>$plan['id']))->query();
                return false;
            }
        }
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

    public function updateChecker($plan, $cabs)
    {
        $db = $this->db;
        $cols = array();
        $cols['status'] = PLAN_STATUS_FINISHED;
        $cols['finish_time'] = time();
        $conn = "id=:I";
        $bind = array('I' => $plan['id']);
        $db->update($this->tbl_plan)->cols($cols)->where($conn)->bindValues($bind)->query();
        $this->resetDiskStatus();
        $this->broadCheckStatus($cols);
    }

    public function broadCheckStatus($plan)
    {
        $rst = array('type' => 'self_check', 'status' => $plan['status']);
        ExtendGateWay::sendToAll(json_encode($rst));
    }
    public function setDiskFree($dsks){

        foreach($dsks as $dsk) {

            if ($dsk['busy'] == 1) {
                $busy = true;
                $cmds = $this->db->select("*")->from("gui_cmd_log")->where("id=:I")->bindValues(array('I' => $dsk["busy_cmd_id"]))->query();
                if ($cmds) {
                    $cmd = $cmds[0];
                    //命令已经结束或者超时
                    $time_limit = 24 * 3600;
                    if ($cmd['finished'] === 1 || time() - (int)$cmd['start_time'] > $time_limit) {
                        $busy = false;
                    }
                } else {
                    $busy = false;
                }
                if (!$busy) {

                    $cols = array('busy'=>0,
                        'busy_cmd_id'=>0);
                    //$dsk['busy'] = 0;
                    //$dsk['busy_cmd_id'] = 0;
                        $cond = "id=:I";
                        $bind = array("I" => $dsk['id']);
                        $this->db->update("gui_device")->cols($cols)->where($cond)->bindValues($bind)->query();
                    $dsk = $this->db->select("busy,busy_cmd_id,md5_status")->from(TBL_DEVICE)->where($cond)->bindValues($bind)->query();
                    $this->RunLog("Dsk status:".$dsk[0]['md5_status']);

                }
            }
        }
    }
    public function checkCmdStatus($plan)
    {
        //如果自检小于1天则返回
        $time_limit = $this->type == 'md5' ? 48 * 3600 : 3600;


        $dsks = $this->db->select("*")->from("gui_device")->where("loaded=:L")->bindValues(array('L' => 1))->query();
        if ($dsks) {
            $this->setDiskFree($dsks);
            foreach ($dsks as $dsk) {
                if($dsk[$this->type.'_status'] == PLAN_STATUS_WORKING){
                    $check_done = false;
                    $cmds = $this->db->select("*")->from("gui_cmd_log")->where("id=:I")->bindValues(array('I' => $dsk[$this->type . "_cmd_id"]))->query();
                    if ($cmds) {
                        $cmd = $cmds[0];
                        //命令已经结束或者超时
                        if ($cmd['finished'] === 1 || time() - (int)$cmd['start_time'] > $time_limit) {
                            $check_done = true;
                        }
                    } else {
                        $check_done = true;
                    }
                    if ($check_done) {
                        $dsk[$this->type . "_status"] = PLAN_STATUS_FINISHED;
                        $dsk[$this->type . "_cmd_id"] = 0;
                        if ($cmds) {
                            switch ($cmds[0]['status']) {
                                case 0:
                                    //Success
                                    break;
                                case -2:
                                    //取消
                                    $this->RunLog("Disk skipped");
                                    if($this->type == 'md5')
                                    {
                                        $dsk[$this->type . "_skipped"] = 1;
                                        $dsk[$this->type . "_skip_time"] = time();
                                    }
                                    $dsk[$this->type . "_status"] = PLAN_STATUS_WAITING;
                                    break;

                                default:
                                    //超时或失败,取消本次自检
                                    $dsk[$this->type . "_status"] = PLAN_STATUS_CANCELED;
                                    break;
                            }
                        }
                        $this->db->update("gui_device")->cols($dsk)->where("id=:I")->bindValues(array('I' => $dsk["id"]))->query();
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

    /********************
     * @param $cab_id
     * @return int 忙碌磁盘的数量
     */
    public function checkBusyNum($cab_id){
        $num = 0;
        $db = $this->db;
        $dsks = $db->select("*")->from('gui_device')->where("cab_id=$cab_id and loaded=1")->query();
        foreach($dsks as $item){
            if($item[$this->type . '_status'] === PLAN_STATUS_WORKING){
                $num = $num + 1;
            }
        }
        return $num;
    }
    //检查
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
        $config = null;
        $configs = $db->select("*")->from($this->tbl_conf)->where("type=:T and is_current=:C")->bindValues(array('T' => $type, 'C' => 1))->query();

        if ($configs) {
            $config = $configs[0];
            //根据配置生成新的plan
            if (!$start_t) {
                $items = $db->select("start_date")->from($this->tbl_start_date)->where("type=:T and is_current=:C")->bindValues(array('T' => $type, 'C' => 1))->query();
                if (!$items) {
                    return null;
                }
                $start_t = (int)$items[0]['start_date'];
            }

            $plan = $this->getPlan($config, $start_t);
            if (!$plan) {
                return null;
            }
            $plan_id = $db->insert($this->tbl_plan)->cols($plan)->query();
            if (!$plan_id) {
                $plan = null;
            } else {
                $plan['id'] = $plan_id;
            }
        }
        return $plan;
    }

    /********************
     * @param $dsk 磁盘信息
     * @param $db_cab_id 磁盘实际所属柜子数据库序列号
     * @param $cmd_id 命令ID,便于索引
     */
    public function setDiskBusy($dsk,$db_cab_id,$cmd_id){
        $tbl = "gui_cmd_disk";
        $data = array(
            'cmd_id'=>$cmd_id,
            'db_cab_id'=>$db_cab_id,
            'cab'=>$dsk['cab_id'],
            'level'=>$dsk['level'],
            'grp'=>$dsk['zu'],
            'disk'=>$dsk['disk']
        );
        $this->db->insert($tbl)->cols($data)->query();
    }
    public function updateCmdLog($dsk,$db_cab_id)
    {
        $cmd = $this->type == 'md5' ? 'MD5' : 'DISKINFO';
        $db = $this->db;
        $tbl_cmd_log = "gui_cmd_log";
        //增加忙碌磁盘记录

        $new_cmd = array(
            'cmd' => $cmd,
            'sub_cmd' => 'START',
            'user_id' => '0',
            'status' => PLAN_STATUS_WAITING,
            'start_time' => time(),
            'db_cab_id'=>$db_cab_id,
            'finished' => 0
        );
        $cmd_id = $db->insert($tbl_cmd_log)->cols($new_cmd)->query();
        if ($cmd_id) {
            $cols = array($this->type . "_cmd_id" => $cmd_id, $this->type . "_status" => PLAN_STATUS_WORKING);
            $cond = "id=:I";
            $bindV = array("I" => $dsk['id']);
            $rst = $db->update("gui_device")->cols($cols)->where($cond)->bindValues($bindV)->query();
            //如果更新磁盘状态失败，则停止操作，删除日志，以免阻塞或者冲突
            if (!$rst) {
                //删除命令日志
                $cond = "id=:I";
                $bindV = array("I" => $cmd_id);
                $db->delete($tbl_cmd_log)->where($cond)->bindValues($bindV)->query();
                return false;
            }
            else{
                $data = array(
                    'cmd' => $cmd,
                    'CMD_ID' => $cmd_id,
                    'device_id' => $dsk['cab_id'],
                    'level' => $dsk['level'],
                    'group' => $dsk['zu'],
                    'disk' => $dsk['disk'],
                    'subcmd' => 'START'
                );
                $new_cmd = array('msg' => json_encode($data));
                $db->update($tbl_cmd_log)->cols($new_cmd)->where('id=:I')->bindValues(array('I' => $cmd_id))->query();
                //将disk设为忙碌,避免冲突
                $busy_disk = array(
                    'cmd_id'=>$cmd_id,
                    'cab'=>$dsk['cab_id'],
                    'level'=>$dsk['level'],
                    'grp'=>$dsk['zu'],
                    'disk'=>$dsk['disk'],
                    'db_cab_id'=>$db_cab_id
                );
                $db->insert("gui_cmd_disk")->cols($busy_disk)->query();
            }
        }
        return $cmd_id;
    }

    public function sendCmd($dsk, $type,$db_cab_id)
    {
        //生成cmd,插入CmdLog
        $cmd = $this->type == 'md5' ? 'MD5' : 'DISKINFO';
        $db = $this->db;
        $tbl_cmd_log = "gui_cmd_log";
        if ($cmd_id = $this->updateCmdLog($dsk,$db_cab_id)) {
            $ch = curl_init();
            $url = $this->app_addr;
            $header = array(
                'Content-Type:application/json'//x-www-form-urlencoded'
            );
            $data = array(
                'cmd' => $cmd,
                'CMD_ID' => $cmd_id,
                'device_id' => $dsk['cab_id'],
                'level' => $dsk['level'],
                'group' => $dsk['zu'],
                'disk' => $dsk['disk'],
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
            // 通知前端
            $rst = $db->select('*')->from($tbl_cmd_log)->where('id=:I')->bindValues(array('I' => $cmd_id))->query();

            if ($rst) {
                $attached = array('type' => 'say', 'username' => 'system');
                $rst = array_merge($rst, $attached);
                ExtendGateWay::sendToAll(json_encode($rst));
            }
            return true;
        } else {
            $this->RunLog("Sendding commond: Failed to add commond log.");
            return false;
        }
    }
}
