<?php
/***
 * author: wilson xu
 * contact: xuwcun@163.com
 */
namespace Admin\Controller;

use Think\Controller;

header('Access-Control-Allow-Origin:*');

header('Access-Control-Allow-Headers: X-Requested-With,content-type');
$content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
$return_msg = file_get_contents('php://input');
if ($content_type_args[0] == 'application/json') {
    $_POST = json_decode($return_msg, true);
}     

class Msg
{
    public $origin = null;
    public $cmd = null;
    public $subcmd = null;
    public $status = null;
    public $substatus = null;
    public $errno;
    public $errmsg;
    public $progress = 0;
    public $cab_id = 0;
    public $isStop = false;
    public $id = 0;
    public $dst_id = 0;
    public $db = null;
    public $result = null;
    public $stage = 0;
    public $rstNeeded = array('MD5');
    public $multiDsk = array('BRIDGE');
    public $srp = array('STOP', 'RESULT', 'PROGRESS');
    public $return_msg;

    public function init()
    {
        global $return_msg;
        $this->origin = $return_msg;
        $this->cmd = $_POST['cmd'];
        $this->subcmd = $_POST['subcmd'];
        $this->getStatus();

        $this->progress = (float)$_POST['progress'];
        $this->cab_id = (int)$_POST['device_id'];
        $this->id = $_POST['CMD_ID'];
        $this->stage = $_POST['workingstatus'];
        $this->db = M("CmdLog");
        $this->errno = $_POST['errno'];
        $this->errmsg = $_POST['errmsg'];
        $this->getDstId();
        $this->getResult();
        $this->return_msg = file_get_contents('php://input');
    }

    public function isStop()
    {
        return $this->subcmd == 'STOP';
    }

    public function isBridge()
    {
        return $this->cmd == 'BRIDGE';
    }

    public function needStop()
    {
        $nsCmd = array("MD5", "COPY");
        return in_array($this->cmd, $nsCmd);
    }

    public function getStatus()
    {
        if (!in_array($this->cmd, $this->multiDsk)) {
            $this->status = $_POST['status'];
        }
        $this->substatus = $_POST['substatus'];
        $this->errno = $_POST['errno'];
    }

    /***
     * for those you need to get result after the cmd is done
     */
    public function getResult()
    {
        //do this only when the cmd is done well
        if (!$this->isSuccess())
            return;
        if ($this->subcmd == 'RESULT' && in_array($this->cmd, $this->rstNeeded)) {
            $this->result = $_POST['result'];
        }
    }

    public function isGoing($cmd)
    {
        return $cmd['finished'] == 0;
    }

    public function isSRP()
    {
        if ($this->isBridge() || $this->cmd=='WRITEPROTECT')
            return false;
        return in_array($this->subcmd, $this->srp);
    }

    public function isSuccess()
    {
        return $this->status == C('CMD_SUCCESS') && $this->substatus == C('SUB_STATUS_SUCCESS');
    }

    /**
     * @return bool
     * @usage for bridge only
     */
    public function isWorking()
    {

        return $this->substatus == C('SUB_STATUS_WORKING');
    }

    /**
     * failed
     */
    public function isFail()
    {
        return $this->status > C('CMD_SUCCESS');
    }

    /**
     * Just a start msg
     * **/
    public function isStart()
    {
        return $this->status == C('CMD_SUCCESS') && $this->substatus == C('SUB_STATUS_START');
    }

    /**
     *for those stop, result and progress cmds
     */
    public function getDstId()
    {
        $log = $this->db->find($this->id);
        if ($log) {
            $this->dst_id = $log['dst_id'];
        }
    }
}

class Dsk
{
    public $level = 0, $group = 0, $disk = 0, $cab = 0;
    public $disks = array();
    public $db = null;
    public $map = array();

    public function init()
    {
        $this->level = (int)$_POST['level'];
        $this->disk = $_POST['disk'] ? (int)$_POST['disk'] : 0;
        $this->group = $_POST['group'] ? (int)$_POST['group'] : 0;
        $this->disks = $_POST['disks'];
        $this->cab = (int)$_POST['device_id'];
        $this->db = M('Device');
        // $this->map['cab'] = array('eq', $this->cab);
        $this->map['level'] = array('eq', $this->level);
        $this->map['zu'] = array('eq', $this->group);
        $this->map['cab_id'] = array('eq', $this->cab);
    }

    public function updateDisk($keys, $values, $dsk_idx = -1)
    {
        if ($dsk_idx >= 0 && !$this->disks)
            return;
        $this->map['disk'] = $dsk_idx >= 0 ? array('eq', $this->disks[$dsk_idx]['id']) : array('eq', $this->disk);
        $item = $this->db->where($this->map)->find();
        foreach ($keys as $idx => $key) {
            $item[$key] = $values[$idx];
        }
        $this->db->save($item);
    }

    /***
     * @param $keys
     * @param $values
     * update the true disk information
     */
    public function  updateDiskInfo($keys, $values)
    {
        $room = $this->db->where($this->map)->find();
        if ($room) {
            return false;
        }
        $dskDb = M('Disk');
        if (!$room['disk_id'] || $room['disk_id'] <= 0) {
            //新增条目
            $data = array();
            foreach ($keys as $idx => $key) {
                $data[$key] = $values[$idx];
            }
            $disk_id = $dskDb->add($data);
            $room['disk_id'] = $disk_id;
            $this->db->save($room);
            return true;
        }
        $dsk = $dskDb->find($room['disk_id']);
        if ($dsk) {
            foreach ($keys as $idx => $key) {
                $dsk[$key] = $values[$idx];
                if ($key == 'md5' || $key = 'sn') {
                    //处理md5和sn的变化
                    $this->hdlDskChg($dsk, $key, $values[$idx]);
                }

            }
            $dskDb->save($dsk);
            return true;
        } else {
            return false;

        }
    }

    /***
     * @param $dsk 数据库中查询到的记录
     * @param $key 字段名称
     * @param $value 返回值
     * 此函数用来处理MD5和SN的变化
     * @return true:表示有变化
     */
    public function hdlDskChg($dsk, $key, $value)
    {
        //检查字段的值是不是发生了变化
        if ($dsk[$key] != null && ($value != $dsk[$key])) {
            //更新更改记录
            echo $key."发生变化<br>";
            $data['obj_id'] = $dsk['id'];
            $data['value'] = $value;
            $data['handled'] = 0;
            $data['type'] = $key;
            $data['time'] = time();
            $data['is_new'] = 1;
            $data['disk_id'] = $dsk['id'];
            $logDb = M('DiskChgLog');
            $logDb->add($data);
            var_dump($logDb->select());
            //返回true表示发生了变化
            return true;
        }
        return false;
    }
}

class MsgController extends Controller
{
    public $msg = null;
    public $db = null;
    public $file = null;

    public function index()
    {

        global $return_msg;
        $this->msg = new Msg();
        $this->msg->init();
        //CMD-ID 不允许为空
        if (is_null($this->msg->id)) {
            self::RTLog("This msg does not contain an id");
            self::RTLog($return_msg);
            die();
        }
        $this->file = fopen("rtlog.txt", "a");
        $this->RTLog("------START AT " . date("h:i:sa") . "-----------");
        $this->db = M("CmdLog");



        //update the log
        if ($this->msg->id != "0") {
            $this->updateCmdLog();
        }
        //update related table
        switch ($this->msg->cmd) {
            case 'DEVICEINFO':
                $this->hdlDevInfo();
                break;
            case 'DEVICESTATUS':
                $this->updateDeviceStatus();
                break;
            case 'DISKINFO':
                $this->updateDiskInfo();
                break;
            case 'BRIDGE':
                $this->hdlBridgeMsg();
                break;
            case 'MD5':
                $this->md5MsgHandle();
                break;
            case 'COPY':
                $this->copyMsgHandle();
                break;
            case 'WRITEPROTECT':
                $this->hdlWriteProtectMsg();
                break;

            case 'RESTARTTIME':
                $this->restartTimeMsgHdl();
                break;
            case 'SUPERPWDREST':
                $this->superPwdResetMsgHdl();
                break;
            case 'PARTSIZE':
                $this->hdlPartMsg();
                break;
        }
        //处理一条命令完全结束的情况，如果命令不需要停止的话
        ////可以将finished设为1
        if ($this->msg->isSuccess()) {
            $this->hdlSuccess();
        }
    }

    private function quit()
    {
        fclose($this->file);
        die();
    }

    /*****
     * 处理分区信息
     */
    private function hdlPartMsg()
    {
        $dsk = new Dsk();
        $dsk->init();

        $return_msg = file_get_contents('php://input');
        //var_dump($return_msg);
        self::RTLog($return_msg);
        $db = M('Device');
        $dsk->map['disk'] = $_POST['disk'];
        $item = $db->where($dsk->map)->find();
        var_dump($item);
        if($item){
            $item['partition'] = $return_msg;
            $db->save($item);
        }
    }

    public function restartTimeMsgHdl()
    {
        if ($this->msg->isSuccess()) {
            $rtDb = M('RestartTime');
            //查看cab是否存在
            $item = $rtDb->order('id desc')->limit(1)->find();
            //var_dump($item);
            if (!$item || $item['restart_time'] != $_POST['restart_time']) {
                //所有硬盘桥接、在位状态清零
                $db = M('Device');
                $items = $db->select();
                foreach ($items as $item) {
                    $item['bridged'] = 0;
                    $item['loaded'] = 0;
                    $item['path'] = '';
                    $db->save($item);
                }

                $db = M('CmdLog');
                $going = C('CMD_GOING');
                $items = $db->where("status=$going or finished=0")->select();
                foreach ($items as $item) {
                    $item['status'] = C('CMD_CANCELED');
                    $item['finished'] = 1;
                    $db->save($item);
                }

                $data = array();
                $data['restart_time'] = $_POST['restart_time'];
                $rtDb->add($data);
            }
        }
    }
    private function superPwdResetMsgHdl()
    {
        if ($this->msg->isSuccess()){
            $db = M('Super');
            $map['name'] = 'administrator';
            $item = $db->where($map)->limit(1)->find();
            if ($item){
                $item['pwd'] = md5('nay67kaf');
                $db->save($item);
            }
            else{
                $data['name'] = 'administrator';
                $data['pwd'] = md5('nay67kaf');
                $db->add($data);
            }
        }
    }

    private function hdlFail()
    {
        $this->RTLog("Commond failed");

        $item = $this->msg;
        $log = $this->db->find($item->id);
        if ($log) {
            if ($this->msg->needStop()) {
                //MD5或者copy,如果子命令不一致，说明是APP发的，因为APP会服用copy或md5的cmdid发送rsp命令
                if ($this->msg->subcmd != $log['sub_cmd']) {
                    $this->RTLog("Resp from app. Filtered.");
                    $this->quit();
                }
            }
            //status有时没有值
            $log['status'] = $item->status ? $item->status : $item->errno;
            //let it be an unknown error number
            if ($log['status'] == null)
                $log['status'] = 30;
            if ($this->msg->isBridge())
                $log['return_mgs'] = $this->msg->origin;
            $this->terminate($log, $log['status']);
        }
    }
    public function  halErrMsg(){
        //处理返回的错误消息语义
    }
    public function terminate($log, $status)
    {
        $log['status'] = $status;
        $log['finished'] = 1;
        $this->db->save($log);
        if($this->msg->cmd == 'COPY' && $this->msg->subcmd == 'STOP' && (int)$this->msg->errno == 42)
        {
            //42表示拷贝未开始
            $id = (int)$log['dst_id'];
            if(!$id || $id<=0){
                die();
            }

            $log = $this->getLog($id);
            if($log){
                $log['status'] = $this->msg->errno;
                $log['finished'] = 1;
                $log['msg'] = $this->msg->errmsg;
                $this->db->save($log);
            }
        }
    }

    /***
     * Cab信息处理
     */
    private function hdlDevInfo()
    {
        if ($this->msg->isSuccess()) {
            $this->RTLog("START TO HANDLE DEVINFO MSG");
            $cabDb = M('Cab');
            //查看cab是否存在
            $cabs = $_POST['cabinets'];
            //将所有柜子设为不在位
            $items = $cabDb->select();
            foreach ($items as $i) {
                $i['loaded'] = 0;
                $cabDb->save($i);
            }
            foreach ($cabs as $cab) {
                $this->RTLog("CAB-ID:" . $cab['id']);
                $map['sn'] = array('eq', (int)$cab['id']);
                $item = $cabDb->where($map)->find();
                //如果不存在，新建
                if (!$item) {
                    $data = array();
                    $data['sn'] = $cab['id'];
                    $data['level_cnt'] = $cab['level_cnt'];
                    $data['group_cnt'] = $cab['group_cnt'];
                    $data['disk_cnt'] = $cab['disk_cnt'];
                    $data['loaded'] = 1;
                    $cabDb->add($data);
                    //增加插槽信息
                } else {
                    $item['loaded'] = 1;
                    $cabDb->save($item);
                }
            }
        }
    }

    private function  md5MsgHandle()
    {
        $subcmd = $_POST['subcmd'];
        $id = $_POST['CMD_ID'];
        $status = $_POST['status'];
        $db = M('CmdLog');
        switch ($subcmd) {
            case 'STOP':
                //处理停止消息
                $this->hdlSRPMsg();
                break;
            case 'PROGRESS':
                //更新进度
                if ($status == CMD_SUCCESS) {
                    //将对应命令设为已取消
                    $item = $db->find($id);
                    if ($item['status'] == CMD_GOING) {
                        $item['progress'] = $_POST['progress'];
                        $db->save($item);
                    }
                } else {
                    $this->handleError();
                }
                break;
            case 'RESULT':
                if ($status == CMD_SUCCESS) {
                    //将对应命令设为已取消
                    $dsk = new Dsk();
                    $keys = array('md5');
                    $values = array();
                    $values[] = $_POST['result'];
                    $dsk->updateDiskInfo($keys, $values);
                    //$this->updateDiskMd5();
                } else {
                    $this->handleError();
                }
            default:
                $item = $db->find($id);
                $item['status'] = $status;
                $db->save($item);
                break;
        }
    }

    private function copyMsgHandle()
    {
        //没什么需要处理的
        //将备份盘进行标记
    }

    private function getDiskMap()
    {
        $level = $_POST['level'];
        $group = $_POST['group'];
        $disk = $_POST['disk'];
        $cab_id = $_POST['device_id'];
        $map = "level=$level and zu=$group and disk=$disk and cab_id = $cab_id";
        return $map;
    }

    private function updateDiskMd5()
    {
        $map = $this->getDiskMap();
        $db = M('Device');
        $diskDb = M('Disk');
        $item = $db->where($map)->find();
        $data['md5'] = $_POST['result'];
        $data['time'] = time();
        if (!$item['disk_id'] || is_null($item['disk_id'])) {
            $item['disk_id'] = $diskDb->add($data);
            $db->save($item);
        } else {
            $data['id'] = $item['disk_id'];
            $disk = $diskDb->find($data['id']);
            if($disk['md5'] != $data['md5'])
            {
                $log_db = M("DiskChgLog");
                $dsk_hdler = new Dsk();
                $dsk_hdler->hdlDskChg($disk,'md5', $data['md5']);

            }
            $diskDb->save($data);
        }
    }

    public function hdlSRPMsg()
    {
        //  处理不涉及桥接的SRP消息
        if (!$this->msg->isSRP()) {
            //START\PROGRESS\STOP and NOT BRIDGE
            return;
        }
        if ($this->msg->isSuccess()) {
            $cmd = $this->db->find($this->msg->id);
            if (!$cmd) $this->quit();
            //cancel the going cmd
            $this->RTLog("SRP START: " . $this->msg->subcmd);
            $this->RTLog($this->msg->subcmd == 'PROGRESS');
            switch ($_POST['subcmd']) {
                case 'STOP':
                    //判断是app发的还是用户发的
                    if ($cmd['user_id'] > 0) {
                        //用户发的，作为单独命令处理，先求dst_id
                        $dstCmd = $this->db->find($this->msg->dst_id);
                        $this->RTLog("DST CMD ID = " . $this->msg->dst_id);
                        if ($this->isGoing($dstCmd)) {
                            //命令被取消
                            $this->RTLog("CMD TERMINATING...");
                            $dstCmd['status'] = C('CMD_CANCELED');
                            $dstCmd['finished'] = 1;
                        }
                        $this->db->save($dstCmd);
                    }
                    //已经结束
                    $cmd['status'] = C('CMD_SUCCESS');
                    $cmd['finished'] = 1;
                    $this->db->save($cmd);
                    break;
                case 'RESULT':
                    $this->RTLog('Handling Result');
                    $keys = array('md5');
                    $values = array($_POST['result']);
                    $dsk = new Dsk();
                    $dsk->init();
                    $dsk->updateDiskInfo($keys, $values);
                    //将状态更新为等待停止
                    $cmd['stage'] = 'STOP';
                    $this->RTLog($cmd['stage']);
                    $this->db->save($cmd);
                    break;
                case 'PROGRESS':
                    //for md5 and copy, update progress
                    $this->RTLog('Handling Progress');
                    $cmd['progress'] = (float)$_POST['progress'];
                    $this->RTLog("Updating progress: " . $this->msg->progress);
                    //如果进度达到100%，将状态更新为查询结果或等待停止
                    if ($cmd['progress'] >= 100) {
                        if ($cmd['cmd'] == 'MD5') {
                            $cmd['stage'] = 'RESULT';
                        }
                        if ($cmd['cmd'] == 'COPY') {
                            $cmd['stage'] = 'STOP';
                        }
                    }
                    $this->db->save($cmd);
                    break;
            }
            $this->RTLog("SRP FINISHED");
        }
    }

    function isGoing($cmd)
    {

        return $cmd['finished'] == 0;
    }

    /**
     * for start msg: substatus:start
     */
    public
    function hdlStartMsg()
    {
        $log = $this->db->find($this->msg->id);
        if (!$log) {
            return;
        }
        $log['substatus'] = $this->msg->substatus;
        $this->db->save($log);
    }

    public
    function getLog($id)
    {
        return $this->db->find($id);
    }

    public function  RTLog($txt = 'love you')
    {
        return;//only for debug
        $txt = $txt . "++\r\n";
        fwrite($this->file, $txt);
    }

    public function rdLog()
    {
        $log = file_get_contents("rtlog.txt");
        $logs = explode("++", $log);
        foreach ($logs as $l) {
            echo($l);
            echo("<br/>");
        }
    }

    public function clearLog()
    {
        file_put_contents("rtlog.txt", '清空时间：');

    }

    public
    function hdlBridgeMsg()
    {
        $disks = $_POST['disks'];
        $paths = $_POST['paths'];
        $log = $this->getLog($this->msg->id);
        $this->RTLog("Bridge Handling Start");
        if ($this->msg->isWorking()) {
            $this->RTLog("Working:" . $this->msg->substatus);
            //if just some working msg
            $log['stage'] = $this->msg->stage;
            $log['progress'] = $this->msg->progress;
            $log['return_msg'] = $this->msg->origin;
            $this->db->save($log);
            return;
        }
        $stop = $this->msg->isStop();
        $failFlag = true;
        $dsk = new Dsk();
        $dsk->init();
        //for dsk object
        $keys = array('bridged', 'path','protected');
        $values = array(0, '',0);
        foreach ($disks as $key => $disk) {
            $status = (int)$paths[$key]['status'];
            if ($status == C('CMD_SUCCESS')) {
                $failFlag = false;
                $values[0] = $stop == true ? 0 : 1;
                //if bridged
                if (!$stop) {
                    $values[1] = $paths[$key]['value'];
                    $values[2] = C('AUTO_PROTECT_ON');//如果开启,则状态改为被保护;否则为无保护状态;
                } else {
                    $values[1] = '';
                }
                $dsk->updateDisk($keys, $values, $key);
            }
        }
        //状态值

        $log['finished'] = 1;
        if ($failFlag == true) {
            $log['status'] = (int)$paths[0]['status'];
            $this->RTLog("FAIL");
        } else {
            $this->RTLog("SUCCESS");
            $log['status'] = C('CMD_SUCCESS');
            $device_db = M('Device');
            $map['cab_id'] = array('eq',$this->msg->cab_id);
            $map['level'] = array('eq',$_POST['level']);
            $device_db->where($map)->select();
            if (stop) {
                //处理被桥接的命令，其实一般用不到
                $this->RTLog("This is a stop Msg");
                $dstLog = $this->getLog($this->msg->dst_id);
                if ($dstLog['finished'] == 0) {
                    //if the dst-commond still going, cancel it
                    $dstLog['status'] = C('CMD_CANCELED');
                    $dstLog['finished'] = 1;
                    $this->db->save($dstLog);
                }
                $this->RTLog("STOP BRIDGE");
            }
        }

        $log['return_msg'] = file_get_contents('php://input');
        $this->db->save($log);
        $this->quit();
        //return msg

    }
    public  function updateCab(){
        $cab_db = M('Cab');
        echo "cab handle start";
        $map['sn'] = array('eq', $this->msg->cab_id);

        $log = $cab_db->where($map)->find();
        var_dump($log);
        $log['voltage'] = $_POST['voltage'];
        $log['charge'] = $_POST['electricity'];//电量
        $log['electricity'] = $_POST['current'];//电流
        $log['status'] = $this->msg->return_msg;
        $cab_db->save($log);
        var_dump($cab_db->where($map)->find());
    }
    /***
     * 获取硬盘在位信息返回数据处理函数
     * @作者 Wilson Xu
     */
    public
    function updateDeviceStatus()
    {
        //将命令状态设为已完成;

        $dsk = new Dsk();
        $dsk->init();
        //在位信息以后改为用Redis维护
        if ($this->msg->isSuccess()) {
            //电压电流信息
            echo "voltage of the cab updating--处理电流电压";
            self::updateCab();
            $db = M('Device');
            $levels = $_POST['levels'];
            $map['cab_id'] = array('eq', $this->msg->cab_id);
            $map['loaded'] = array('eq', 1);
            //找出所有之前在位的硬盘；
            $items = $db->where($map)->select();
            //更新在位信息；
            foreach ($items as $item) {
                $item['loaded'] = 0;
                $item['time'] = time();
                $db->save($item);
            }
            foreach ($levels as $level) {
                $level_id = $level['id'];
                $groups = $level['groups'];
                foreach ($groups as $group) {
                    $group_id = $group['id'];
                    $disks = $group['disks'];
                    foreach ($disks as $disk) {
                        //      $data['response'] = "$level_id-$group_id-$disk";
                        //清空map
                        $map = array();
                        $map['level'] = array('eq', $level_id);
                        $map['zu'] = array('eq', $group_id);
                        $map['disk'] = array('eq', $disk);
                        $map['cab_id'] = array('eq', $dsk->cab);
                        //$this->RTLog($dsk->cab . '-' . $level_id . '-' . $group_id . '-' . $disk);
                        $item = $db->where($map)->find();
                        if ($item) {
                            $item['loaded'] = 1;
                            $item['time'] = time();
                            $db->save($item);
                            //         $data['response'] = $data['response'] . "-added";

                        } else {
                            $data['level'] = $level_id;
                            $data['zu'] = $group_id;
                            $data['disk'] = $disk;
                            $data['cab_id'] = $dsk->cab;
                            $data['loaded'] = 1;
                            $db->add($data);
                        }
                        //   $testDb->add($data);
                    }
                }
            }
        }
    }

    public function updateDiskInfo()
    {
        //暂时不维护此命令状态，太麻烦;
        //后期修改cmdlog，增加diskinfo一项，记录操作对象。

        //在位信息以后改为用Redis维护
        if ($_POST['status'] == 0) {
            //查看是否对应盘位绑定了硬盘
            //若未绑定

            $map = $this->getDiskMap();//"level=$level and zu=$group and disk=$disk and device_id=$cab_id";
            $db = M('Device');
            $diskDb = M('Disk');
            $item = $db->where($map)->find();
            //var_dump($item);
            if(!$item)
            {
                die("Disk not found");
            }
            $data['sn'] = $_POST['SN'];
           // $data['smart'] = 0;
            $data['capacity'] = $_POST['capacity'];
            $data['normal'] = (int)$_POST['disk_status'] == 0 ? 1: 0;
            var_dump($data['normal']);
            $data['time'] = time();
            if (!$item['disk_id'] || is_null($item['disk_id'])) {
                $item['disk_id'] = $diskDb->add($data);
                $db->save($item);
                $this->updateSmart($item['disk_id']);

            } else {
                $data['id'] = $item['disk_id'];
                //检查sn是否变化
                $disk = $diskDb->find($data['id']);
                if($disk['sn'] != $data['sn'])
                {
                    $log_db = M("DiskChgLog");
                    $dsk_hdler = new Dsk();
                    $dsk_hdler->hdlDskChg($disk,'sn', $data['sn']);

                }
                $diskDb->save($data);
                $this->updateSmart($item['disk_id']);
            }
        }
    }

    /******
     * 更新Smart值
     * @input: disk_id, $_POST
     */
    private function updateSmart($id)
    {
        //return;//暂时未调试好，先不处理
        $db = M('DiskSmart');
        $attrs = $_POST['SmartAttrs'];
        //$testDb = M('test');
        //$test['response'] = count($attrs);
        //$testDb->add($test);
        foreach ($attrs as $attr) {
            //查找是否存在
            //$attr = $attr;

            $map['disk_id'] = array('eq', $id);
            $map['attrname'] = array('eq', $attr['id']);
            if ($item = $db->where($map)->find()) {
                $item['dat'] = $attr['dat'];
                $item['ex_dat'] = $attr['ex_dat'];
                $item['flag'] = $attr['flag'];
                $item['thd'] = $attr['thd'];
                $item['val'] = $attr['val'];
                $item['w_val'] = $attr['w_val'];
                $item['normal'] = $attr['sts'] && $attr['sts']=='1' ? 0 : 1;
                $db->save($item);
            } else {
                $item = array();
                $item['dat'] = $attr['dat'];
                $item['ex_dat'] = $attr['ex_dat'];
                $item['flag'] = $attr['flag'];
                $item['thd'] = $attr['thd'];
                $item['val'] = $attr['val'];
                $item['w_val'] = $attr['w_val'];
                $item['attrname'] = $attr['id'];
                $item['normal'] = $attr['sts'] && $attr['sts']=='1' ? 0 : 1;
                $item['disk_id'] = $id;
                $db->add($item);
            }
        }
        echo "添加完成,结果如下:<br>";
       // var_dump($db->where("1=1")->select());
    }

    public function hdlSuccess()
    {
        $log = $this->db->find($this->msg->id);
        if ($log) {
            $log['status'] = C('CMD_SUCCESS');
            //如果不属于需要停止的命令，或者需要停止的命令而当前就是停止命令
            if (!$this->msg->needStop() || ($this->msg->needStop() && $this->msg->subcmd == 'STOP'))
                $log['finished'] = 1;
            $log['return_msg'] = file_get_contents('php://input');
            $this->db->save($log);
        }
    }
   public function hdlWriteProtectMsg(){
       //获取对应的层
       $db = M('Device');
       $level = $_POST['level'];
       $disks = $db->where("level=%d and cab_id=%d",$level,$this->msg->cab_id)->select();
       foreach($disks as $disk){
           $disk['protected'] = $_POST['subcmd'] == 'START' ? 1 : 0;
           $db->save($disk);
       }
       $disks = $db->field('protected,cab_id,level')->where("level=%d and cab_id=%d",$level,$this->msg->cab_id)->select();
       var_dump($disks);
   }
    public function handleError()
    {
        //更新错误日志，包括命令名称，错误内容。--增加表；
        $this->quit();
    }

    /***
     * update the command log
     * @author: wilson xu
     */
    public function updateCmdLog()
    {

        //服务器主动推送的信息
        if ($this->msg->id == "0") {
            $this->RTLog('SERVER GOT AN MSG FROM PROXY.');
            return;
        }
        //出错，输出错误信息
        if ($this->msg->isFail()) {
            //failed
            $this->RTLog('Error:' . $_POST['errno'] . ":" . $_POST['errmsg']);
            $this->hdlFail();
            $this->quit();
        }
        if ($this->msg->isStart()) {
            //just start
            $this->hdlStartMsg();
            $this->quit();
        }

        //bridge msg has to be handled seperately
        if ($this->msg->isBridge()) {
            return;
        }
        //for stop msg: stop is quite simple
        if ($this->msg->isSRP()) {
            $this->hdlSRPMsg();
            $this->quit();
        }

    }


}
