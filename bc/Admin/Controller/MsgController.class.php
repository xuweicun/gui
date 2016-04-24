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
        $this->getRealId();
        $this->getResult();
        $this->db = M("CmdLog");
    }
    public function isStop()
    {
        return $this->subcmd == 'STOP';
    }
    public function isBridge()
    {
        return $this->cmd == 'BRIDGE';
    }

    public function getStatus()
    {
        if (!in_array($this->cmd, $this->multiDsk)) {
            $this->status = $_POST['status'];
        }
        $this->substatus = $_POST['substatus'];
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

    public function isSRP()
    {

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
    public function getRealId()
    {
        if (strpos("_", $this->id) > 0) {
            $idInfo = explode("_", $this->id);
            $this->id = (int)$idInfo[0];
            if (count($idInfo) > 1) {
                $this->dst_id = (int)$idInfo[1];
            }
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
        $dskDb = M('Disk');
        $dsk = $dskDb->find($room['disk_id']);
        if ($dsk) {
            foreach ($keys as $idx => $key) {
                $dsk[$key] = $values[$idx];
            }
            $dskDb->save($dsk);
        }
    }
}

class MsgController extends Controller
{
    public $msg = null;
    public $db = null;

    public function index()
    {
        $this->msg = new Msg();
        $this->msg->init();
        $this->db = M("CmdLog");
        $this->RTLog($this->msg->cmd);
        if ($_POST['errmsg']) {
            //something wrong;
            //   $this->handleError();
            //   die();
            $this->RTLog($_POST['errmsg']);
        }
        //update the log
        $this->updateCmdLog();
        //update related table
        switch ($this->msg->cmd) {
            case 'DIVICEINFO':
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
                $this->protectMsgHdl();
                break;
            case 'DEVICEINFO':
                $this->hdlDevInfo();
                break;

        }
       // $this->hdlSuccess();
    }

    private function hdlFail()
    {
        $this->RTLog("fail func called");
        $item = $this->msg;
        $log = $this->db->find($item->id);
        if ($log) {
            $log['status'] = $item->status;
            if ($this->msg->isBridge())
                $log['return_mgs'] = $this->msg->origin;
            $this->db->save($log);
        }
    }

    /***
     * Cab信息处理
     */
    private function hdlDevInfo()
    {
        if ($this->msg->isSuccess()) {
            $cabDb = M('Cab');
            //查看cab是否存在
            $cabs = $_POST['cabinets'];
            foreach ($cabs as $cab) {
                $map['sn'] = array('eq', (int)$cab);
                $item = $cabDb->where($map)->find();
                if (!$item) {
                    $data = array();
                    $data['id'] = $cab;
                    $data['sn'] = $cab;
                    $cabDb->add($data);
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
                    $this->updateDiskMd5();
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
        $subcmd = $_POST['subcmd'];
        $id = $_POST['CMD_ID'];
        $status = $_POST['status'];
        $db = M('CmdLog');
        switch ($subcmd) {
            case 'STOP':
                //处理停止消息
                if ($status == CMD_SUCCESS) {
                    //将对应命令设为已取消
                    $item = $db->find($id);
                    if ($item['status'] == CMD_GOING) {
                        $item['status'] = CMD_CANCELED;
                        $db->save($item);
                    }

                }

                $item = $db->where('target_id=%d', $id)->find();
                $item['status'] = $status;
                $db->save($item);
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
            default:
                $item = $db->find($id);
                $item['status'] = $status;
                $db->save($item);
        }
    }

    private function updateDiskMd5()
    {
        $level = $_POST['level'];
        $group = $_POST['group'];
        $disk = $_POST['disk'];
        $map = "level=$level and zu=$group and disk=$disk";
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
            $diskDb->save($data);
        }
    }

    public function hdlSRPMsg()
    {
        if (!$this->msg->isSRP()) {
            return;
        }
        if ($this->msg->isSuccess()) {
            $cmd = $this->db->find($this->msg->dst_id);
            //cancel the going cmd
            switch ($this->msg->sucmd) {
                case 'STOP':
                    if ($cmd && $this->isGoing($cmd)) {
                        $cmd['status'] = C('CMD_CANCELED');
                        $this->db->save($cmd);
                    }
                    $cmd = $this->db->find($this->msg->id);
                    if ($cmd) {
                        $cmd['status'] = C('CMD_SUCCESS');
                        $this->db->save($cmd);
                    }
                    break;
                case 'RESULT':
                    $keys = array('md5');
                    $values = array($_POST['result']);
                    $dsk = new Dsk();
                    $dsk->init();
                    $dsk->updateDiskInfo($keys, $values);
                    break;
                case 'PROGRESS':
                    //for md5 and copy, update progress
                    $log = $this->getLog($this->msg->dst_id);
                    $log['progress'] = (float)$_POST['progress'];
                    $this->db->save($log);
                    break;
            }
        }
    }

    function isGoing($cmd)
    {
        return $cmd['status'] == C('CMD_GOING');
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

    public function  RTLog($txt='love you')
    {
        $myfile = fopen("rtlog.txt", "a") or die("Unable to open file!");
        $txt = $txt."++\r\n";
        fwrite($myfile, $txt);
        fclose($myfile);
    }
    public function rdLog()
    {
        $log = file_get_contents("rtlog.txt");
        $logs = explode("++",$log);
        foreach($logs as $l)
        {
            echo($l);
            echo("<br/>");
        }
    }

    public
    function hdlBridgeMsg()
    {
        $disks = $_POST['disks'];
        $paths = $_POST['paths'];
        $log = $this->getLog($this->msg->id);
        $this->RTLog("{$this->msg->id}:bridge msg handling");
        if ($this->msg->isWorking()) {
            $this->RTLog("working:".$this->msg->substatus);
            //if just some working msg
            $log['stage'] = $this->msg->stage;
            $log['progress'] = $this->msg->progress;
            $log['return_msg'] = $this->msg->origin;
            $this->db->save($log);
            return;
        }
        $this->RTLog("here handling;");
        $stop = $this->msg->isStop();
        $failFlag = true;
        $dsk = new Dsk();
        $dsk->init();
        $this->RTLog("dsk inited");
        //for dsk object
        $keys = array('bridged', 'path');
        $values = array(0, '');
        $this->RTLog("<Disk number:".count($disks).">");
        foreach ($disks as $key => $disk) {
            $status = (int)$paths[$key]['status'];
            $this->RTLog("handling:".$status);
            if ($status == C('CMD_SUCCESS')) {
                $failFlag = false;
                $values[0] = $stop == true ? 0 : 1;
                //if bridged
                if (!$stop) {
                    $values[1] = $paths[$key]['value'];
                } else {
                    $values[1] = '';
                }
                $dsk->updateDisk($keys, $values, $key);
            }
        }
        //状态值
        if ($failFlag == true) {
            $log['status'] = (int)$paths[0]['status'];
            $this->RTLog("FAIL:".$log['status']);
        } else {
            $this->RTLog("success");
            $log['status'] = C('CMD_SUCCESS');
            if(stop) {
                $dstLog = $this->getLog($this->msg->dst_id);
                if ($dstLog['status'] == C('CMD_GOING')) {
                    //if the dst-commond still going, cancel it
                    $dstLog['status'] = C('CMD_CANCELED');
                    $this->db->save($dstLog);
                }
            }
        }

        $log['return_msg'] = file_get_contents('php://input');
        $this->RTLog("status:".$log['status']);
        $this->RTLog("log:".$log['id']);
        $this->db->save($log);
        die();
        //return msg

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
            $db = M('Device');
            $levels = $_POST['levels'];
            $map['loaded'] = array('eq', 1);
            //找出所有之前在位的硬盘；
            $items = $db->where($map)->select();
            //更新在位信息；
            foreach ($items as $item) {
                $item['loaded'] = 0;
                $item['time'] = time();
                $db->save($item);
            }
            $testDb = M('test');

            foreach ($levels as $level) {

                $level_id = $level['id'];
                $groups = $level['groups'];
                foreach ($groups as $group) {
                    $group_id = $group['id'];
                    $disks = $group['disks'];
                    foreach ($disks as $disk) {
                        $data['response'] = "$level_id-$group_id-$disk";
                        //清空map
                        $map = array();
                        $map['level'] = array('eq', $level_id);
                        $map['zu'] = array('eq', $group_id);
                        $map['disk'] = array('eq', $disk);
                        $map['cab_id'] = array('eq', $dsk->cab);
                        $this->RTLog($dsk->cab.'-'.$level_id.'-'.$group_id.'-'.$disk);
                        $item = $db->where($map)->find();
                        if ($item) {
                            $item['loaded'] = 1;
                            $item['time'] = time();
                            $db->save($item);
                            $data['response'] = $data['response'] . "-added";
                            $this->RTLog('<change info>');
                        } else {
                            $data['response'] = $data['response'] . "-fail";
                        }
                        $testDb->add($data);
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
            $level = $_POST['level'];
            $group = $_POST['group'];
            $disk = $_POST['disk'];
            $map = "level=$level and zu=$group and disk=$disk";
            $db = M('Device');
            $diskDb = M('Disk');
            $item = $db->where($map)->find();
            $data['sn'] = $_POST['SN'];
            $data['smart'] = 0;
            $data['capacity'] = $_POST['capacity'];
            $data['time'] = time();
            if (!$item['disk_id'] || is_null($item['disk_id'])) {
                $item['disk_id'] = $diskDb->add($data);
                $db->save($item);
                $this->updateSmart($item['disk_id']);

            } else {
                $data['id'] = $item['disk_id'];

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
        $db = M('DiskSmart');
        $attrs = $_POST['SmartAttrs'];
        $testDb = M('test');
        $test['response'] = count($attrs);
        $testDb->add($test);
        foreach ($attrs as $attr) {
            //查找是否存在
            $attr = $attr;

            $map['disk_id'] = array('eq',$id);
            $map['attrname'] = array('eq',$attr['Attribute_ID']);
            if ($item = $db->where($map)->find()) {
                $item['value'] = $attr['Current_value'];
                $db->save($item);
            } else {
                $item['value'] = $attr['Current_value'];
                $item['attrname'] = $attr['Attribute_ID'];
                $item['disk_id'] = $id;
                $db->add($item);
            }
        }
    }

    public function hdlSuccess()
    {
        $log = $this->db->find($this->msg->id);
        if ($log) {
            $log['status'] = C('CMD_SUCCESS');
            $this->db->save($log);
        }
    }

    public function handleError()
    {
        //更新错误日志，包括命令名称，错误内容。--增加表；
        die();
    }

    /***
     * update the command log
     * @author: wilson xu
     */
    public function updateCmdLog()
    {
        if ($this->msg->isStart()) {
            //just start
            $this->hdlStartMsg();
            die();
        }
        if ($this->msg->isFail()) {
            //failed
            $this->hdlFail();
            die();
        }
        //bridge msg has to be handled seperately
        if ($this->msg->isBridge()) {
            return;
        }
        //for stop msg: stop is quite simple
        if ($this->msg->isSRP()) {
            $this->hdlSRPMsg();
            die();
        }
        //for success msg
        if ($this->msg->isSuccess()) {
            $this->hdlSuccess();
        }
    }


}
