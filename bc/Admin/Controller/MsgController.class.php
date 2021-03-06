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

    public function setStatus($sts)
    {
        $this->status = $sts;
        return $this->status;
    }

    public function getStatus()
    {
        $this->status = $_POST['status'];//Judge status first
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
        if ($this->isBridge() || $this->cmd == 'WRITEPROTECT')
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

    /****
     * @param $sn SN号
     * @return 硬盘的数据库ID
     */
    public function getDskBySN($sn)
    {
        $map['sn'] = array('eq', $sn);

        $db = M('Disk');
        if ($item = $db->where($map)->find()) {
            return $item['id'];
        } else {
            $data['sn'] = $sn;
            $data['sn_time'] = time();
            $id = $db->add($data);
            return $id;
        }
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
    public function updateDiskInfo($keys, $values)
    {
        $room = $this->db->where($this->map)->find();
        if ($room) {
            echo 'no room';
            return false;
        }
        $dskDb = M('Disk');
        if (!$room['disk_id'] || $room['disk_id'] <= 0) {
            echo 'new disk';
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
            echo 'no disk';
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
        if (($value != $dsk[$key])) {
            //更新更改记录
            echo $key . "发生变化<br>";
            $data['obj_id'] = $dsk['id'];
            $data['value'] = $value;
            $data['type'] = $key;
            $data['time'] = time();

            $data['is_new'] = 1;
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
    public $selfCheckArr = array('SN', 'MD5');
    public $cmdDiskTbl = "CmdDisk";

    public function index()
    {
        global $return_msg;
        $this->msg = new Msg();
        $this->msg->init();
        //CMD-ID 不允许为空		

        $this->syn_cmd_status();
        //$this->logs_for_report();

        $this->db = M("CmdLog");

        //update the log
        if ($this->msg->id != "0") {
            //更新自检计划
            if (in_array($this->msg->cmd, $this->selfCheckArr)) {
                //   $cmd = $this->db->find((int)$this->msg->id);
                //     $this->hdlSelfCheck($cmd);
                //   var_dump($cmd);
            }

            $this->updateCmdLog();
        }
        //update related table
        switch ($this->msg->cmd) {
            case 'DEVICEINFO':
                $this->hdlDevInfo();
                break;
            case 'DEVICESTATUS':
                $this->hdlDevStatus();
                break;
            case 'DISKINFO':
                $this->hdlDiskInfo();
                break;
            case 'BRIDGE':
                $this->hdlBridgeMsg();
                break;
            case 'MD5':
                $this->hdlMd5Msg();
                break;
            case 'COPY':
                $this->copyMsgHandle();
                break;
            case 'WRITEPROTECT':
                $this->hdlWriteProtectMsg();
                break;
            case 'FILETREE':
                $this->fileTreeMsgHandle();
                break;
            case 'RESTARTTIME':
                $this->restartTimeMsgHdl();
                break;
            case 'SUPERPWDRESET':
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

    private function syn_cmd_status()
    {
        $cmd = $_POST['cmd'];
        $subcmd = $_POST['subcmd'];
        $status = $_POST['status'];
        if ($status == '25') {
            $db = M('Device');
            foreach ($_POST['busy_disks'][0]['ds'] as $dsk) {
                $item = $db->where(array(
                    'cab_id' => $_POST['device_id'],
                    'level' => $_POST['busy_disks']['l'],
                    'zu' => $_POST['busy_disks']['g'],
                    'disk' => $dsk,
                    'loaded' => 1
                ))->find();

                if ($item && $item['bridged'] != 1) {
                    $item['bridged'] = 1;
                    $db->save($item);
                }
            }
            return;
        }

        if ($status == '1') {
            $db = M('Device');
            foreach ($_POST['disks'] as $dsk) {
                $item = $db->where(array(
                    'cab_id' => $_POST['device_id'],
                    'level' => $_POST['level'],
                    'zu' => $_POST['group'],
                    'disk' => $dsk['id'],
                    'loaded' => 1
                ))->find();
                if ($item && $item['bridged'] != 0) {
                    $item['bridged'] = 0;
                    $db->save($item);
                }
            }
            return;
        }
        // 代表正在进行MD5或COPY
        if ($cmd == 'MD5' || $cmd == 'COPY') {
            if ($subcmd == 'PROGRESS' && $status == '0') {
                $item = M('CmdLog')->where(array('id' => $_POST['CMD_ID']))->find();
                if ($item) {
                    if ($item['finished'] == 1) {
                        $item['finished'] = 0;
                    }

                    if ($item['progress'] != $_POST['progress']) {
                        $item['progress_time'] = time();
                    }

                    M('CmdLog')->save($item);
                }
            }

            $db = M('CmdLog');
            if (($cmd == 'MD5' && $subcmd == 'STOP' && $status == '23')
                || ($cmd == 'COPY' && $subcmd == 'STOP' && $status == '42')
            ) {
                $item = $db->where(array(
                    'id' => $_POST['CMD_ID']
                ))->find();

                if ($item) {
                    $item = $db->where(array(
                        'id' => $item['dst_id']
                    ))->find();

                    if ($item) {
                        $item['finished'] = 1;
                        $db->save($item);
                    }
                }
            }
        } // 代表桥接
        else if ($cmd == 'PARTSIZE') {
            if ($status == '0' && $_POST['substatus'] == '0') {
                $item = M('Device')->where(array(
                    'cab_id' => $_POST['device_id'],
                    'level' => $_POST['level'],
                    'zu' => $_POST['group'],
                    'disk' => $_POST['disk'],
                    'loaded' => 1
                ))->find();

                if ($item) {
                    if ($item['bridged'] != 1) {
                        $item['bridged'] = 1;
                        M('Device')->save($item);
                    }
                } else {

                }
            }
        }
    }

    private function write_fatal_msg($msg)
    {
        if (is_null($msg) || $msg == '') return;

        M('FatalMsg')->add(array('msg' => $msg));
    }

    private function write_smart_log()
    {
        if ($_POST['cmd'] != 'DISKINFO') return;

        // 只记录成功的
        if ($_POST['status'] != '0' || $_POST['substatus'] != '0') {
            return;
        }

        // 依据cmd_id判断是否已经存储过该md5值
        if ($_POST['CMD_ID'] == null) return;
        if (M('DiskSmartLog')->where(array('cmd_id' => $_POST['CMD_ID']))->find()) {
            echo '重复Smart值';// . json_encode($_POST);
            return;
        }

        $dev_id = $_POST['device_id'];
        $lvl_id = $_POST['level'];
        $grp_id = $_POST['group'];
        $dsk_id = $_POST['disk'];

        $slot = M('Device')->field(array('disk_id', 'cabinet_id'))
            ->where(array(
                'cab_id' => $dev_id,
                'level' => $lvl_id,
                'zu' => $grp_id,
                'disk' => $dsk_id,
                'loaded' => 1))
            ->find();
        if (!$slot) {
            $this->write_fatal_msg('can not find loaded disk, when post : '
                . json_encode($_POST));
            return;
        }

        if ($slot['disk_id'] == 0 || $slot['disk_id'] == null) {
            $this->write_fatal_msg('empty disk id, when post : '
                . json_encode($_POST));
            return;
        }

        $item['time'] = time();

        $item['device_id'] = $dev_id;
        $item['level'] = $lvl_id;
        $item['zu'] = $grp_id;
        $item['disk'] = $dsk_id;

        $item['health'] = $_POST['health'];
        $item['cmd_id'] = $_POST['CMD_ID'];

        $item['disk_id'] = $slot['disk_id'];
        $item['cabinet_id'] = $slot['cabinet_id'];

        $item['sn'] = $_POST['SN'];
        $item['capacity'] = $_POST['capacity'];
        $item['smart'] = json_encode($_POST['SmartAttrs']);
        $item['status'] = '1';
        $item['status_comment'] = '';

        M('DiskSmartLog')->add($item);

    }

    private function write_md5_log()
    {
        if ($_POST['cmd'] != 'MD5') return;

        if ($_POST['subcmd'] != 'RESULT') return;

        if ($_POST['status'] != '0' || $_POST['substatus'] != '0') {
            return;
        }

        // 依据cmd_id判断是否已经存储过该md5值
        if ($_POST['CMD_ID'] == null) return;
        if (M('DiskMd5Log')->where(array('cmd_id' => $_POST['CMD_ID']))->find()) {
            echo '重复MD5值' . json_encode($_POST);
            return;
        }


        $dev_id = $_POST['device_id'];
        $lvl_id = $_POST['level'];
        $grp_id = $_POST['group'];
        $dsk_id = $_POST['disk'];

        // 判断是否exist
        $my_slot = M('Device')->field(array('disk_id', 'cabinet_id'))
            ->where(array(
                'cab_id' => $dev_id,
                'level' => $lvl_id,
                'zu' => $grp_id,
                'disk' => $dsk_id,
                'loaded' => 1))
            ->find();

        if (!$my_slot) {
            $this->write_fatal_msg('can not find loaded disk, when post : '
                . json_encode($_POST));
            return;
        }

        $disk_db = M('Disk');
        $my_disk = $disk_db->where(array('id' => $my_slot['disk_id']))->find();
        if (!$my_disk) {
            $this->write_fatal_msg('can not find disk in gui_disk with id '
                . $my_slot['disk_id'] . ', when post : ' . json_encode($_POST));
            return;
        }

        // 若md5为空或相同
        if ($my_disk['md5'] == null || $my_disk['md5'] == $_POST['result']) {
            // 记录md5变化
            $my_disk['md5_changed'] = 0;
        } else {
            // 记录md5变化
            $my_disk['md5_changed'] = 1;
        }
        $disk_db->save($my_disk);

        $item['time'] = $item['md5_time'] = time();

        $item['device_id'] = $dev_id;
        $item['level'] = $lvl_id;
        $item['zu'] = $grp_id;
        $item['disk'] = $dsk_id;

        $item['md5_value'] = $_POST['result'];
        $item['cmd_id'] = $_POST['CMD_ID'];

        $item['disk_id'] = $my_slot['disk_id'];
        $item['sn'] = $my_disk['sn'];
        $item['cabinet_id'] = $my_slot['cabinet_id'];
        $item['status'] = '1';

        M('DiskMd5Log')->add($item);
    }

    private function logs_for_smart($_msg)
    {
        // 只记录成功的
        if ($_msg->status != '0' || $_msg->substatus != '0') {
            return;
        }

        $item['time'] = time();
        $item['device_id'] = $_POST['device_id'];
        $item['level'] = $_POST['level'];
        $item['zu'] = $_POST['group'];
        $item['disk'] = $_POST['disk'];
        $item['disk_status'] = $_POST['disk_status'];

        $dsk = M('Device')->field(array('disk_id' => 'id'))
            ->where(array(
                'cab_id' => $item['device_id'],
                'level' => $item['level'],
                'zu' => $item['zu'],
                'disk' => $item['disk'],
                'loaded' => 1
            ))->find();
        if (!$dsk) {
            $this->write_fatal_msg('can not find loaded disk, when post : ' . json_encode($_POST));
            return;
        }

        $item['disk_id'] = $dsk['id'];
        $item['sn'] = $_POST['SN'];
        $item['capacity'] = $_POST['capacity'];
        $item['smart'] = json_encode($_POST['SmartAttrs']);
        $item['status'] = '1';
        $item['status_comment'] = '';

        M('DiskSmartLog')->add($item);
    }

    private function logs_for_md5($_msg)
    {
        if ($_msg->status != '0' || $_msg->substatus != '0') {
            return;
        }

        // 只处理result命令
        if ($_POST['subcmd'] != 'RESULT') {
            return;
        }

        // 处理md5值变化
        do {
            // 判断MD5是否发生变化
            $my_slot = M('Device')->field(array('disk_id'))->where(array(
                'cab_id' => $_POST['device_id'],
                'level' => $_POST['level'],
                'zu' => $_POST['group'],
                'disk' => $_POST['disk'],
                'loaded' => 1
            ))->find();

            if (!$my_slot) break;

            $disk_db = M('Disk');
            $my_disk = $disk_db->where(array('id' => $my_slot['disk_id']))->find();
            if (!$my_disk) break;

            // 若md5为空或相同
            if ($my_disk['md5'] == null || $my_disk['md5'] == $_POST['result']) {
                // 记录md5变化
                $my_disk['md5_changed'] = 0;
            } else {
                // 记录md5变化
                $my_disk['md5_changed'] = 1;
            }

            $disk_db->save($my_disk);
        } while (false);

        $item['time'] = time();
        $item['device_id'] = $_POST['device_id'];
        $item['level'] = $_POST['level'];
        $item['zu'] = $_POST['group'];
        $item['disk'] = $_POST['disk'];
        $item['md5_value'] = $_POST['result'];
        $item['md5_time'] = $item['time'];

        // 获得硬盘ID
        $dsk = M('Device')->field(array('disk_id', 'cabinet_id'))
            ->where(array(
                'cab_id' => $item['device_id'],
                'level' => $item['level'],
                'zu' => $item['zu'],
                'disk' => $item['disk'],
                'loaded' => 1
            ))->find();
        if (!$dsk) {
            $this->write_fatal_msg('can not find loaded disk, when post : ' . json_encode($_POST));
            return;
        }

        // 获取SN
        $item['disk_id'] = $dsk['disk_id'];
        $item['cabinet_id'] = $dsk['cabinet_id'];

        $sn = M('DiskSmartLog')->field(array('sn'))
            ->where(array(
                'disk_id' => $item['disk_id'],
                'status' => 1))
            ->order('time desc')->find();
        if (!$sn) {
            $this->write_fatal_msg('can not find disk sn for disk ' . $dsk['disk_id'] . ': ' . json_encode($_POST));
            return;
        }

        $item['sn'] = $sn['sn'];
        $item['status'] = '1';

        M('DiskMd5Log')->add($item);
    }

    private function logs_for_report()
    {
        $_msg = $this->msg;

        if (!$_msg) {
            return;
        }

        if ($_msg->cmd == 'DISKINFO') {
            $this->logs_for_smart($_msg);
        } else if ($_msg->cmd == 'MD5') {
            $this->logs_for_md5($_msg);
        } else {

        }
    }

    private function quit()
    {
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
        //var_dump($item);
        if ($item) {
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
                M()->execute('update gui_device set bridged=0,loaded=0 where loaded=1');
                $db = M('Device');
                //$items = $db->select();
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
        if ($this->msg->isSuccess()) {
            if ($_POST['admin_type'] == '1') {
                $map['name'] = 'useradmin';
            } else if ($_POST['admin_type'] == '2') {
                $map['name'] = 'logadmin';
            } else {
                return;
            }
            $db = M('Super');
            $item = $db->where($map)->limit(1)->find();
            if ($item) {
                $item['pwd'] = md5('nay67kaf');
                $item['locked'] = 0;
                $db->save($item);
            } else {
                $data['name'] = $map['name'];
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
        //算是临时的补救措施,proxy有时候会把自己命令的状态返回给我
        if ($this->msg->cmd == 'BRIDGE') {
            if ($this->msg->subcmd != $log['sub_cmd']) {
                $this->quit();
            }
        }
        $remit = array('33');//33:Another stop task is going;
        if ($log) {
            // 硬盘忙，记录具体busy硬盘
            switch ($item->status) {
                case '1':
                    //bridge not started
                    $db = M('Device');
                    foreach ($_POST['disks'] as $dsk) {
                        $item = $db->where(array(
                            'cab_id' => $_POST['device_id'],
                            'level' => $_POST['level'],
                            'zu' => $_POST['group'],
                            'disk' => $dsk['id']
                        ))->find();
                        if ($item) {
                            $item['bridged'] = 0;
                            $db->save($item);
                        }
                    }
                    break;
                case '25':

                case '26':
                case '27':
                case '28':
                case '29':
                    $log['busy_disks'] = json_encode($_POST['busy_disks']);
                    $this->db->save($log);
                    break;
                default:
                    break;
            }

            if ($this->msg->subcmd == 'STOP' && $log['sub_cmd'] !== $this->msg->subcmd) {
                //APP发出的停止命令,MD5和COPY时存在此类现象
                if (in_array($this->msg->status, $remit)) {
                    //可以忽略的情况
                    $this->quit();
                }
            }
            $this->terminate($log, $this->msg->status);
            $id = (int)$log['dst_id'];
            if (!$id || $id <= 0) {
                die();
            }
            $log = $this->getLog($id);
            $this->terminate($log, $this->msg->status);
        }
    }

    public function halErrMsg()
    {
        //处理返回的错误消息语义
    }

    public function terminate($log, $status)
    {
        $log['status'] = $status;
        $log['finished'] = 1;
        $log['return_msg'] = $this->msg->return_msg;
        //$log['extra_info'] = $this->msg->errmsg;
        $this->db->save($log);
        $map['cmd_id'] = $log['id'];
        //当命令结束时,从磁盘表中删除之
        $db = M('CmdDisk');
        $db->where($map)->delete();
    }

    /*********
     * @param $cabs
     * @param $disks
     * @author Wilson
     * 用于将已经不存在与数据库的柜子的磁盘从磁盘表中删掉
     */
    private function cleanDisks($cabs,$disks)
    {
        $db = M('Device');
        $is_alive = false;
        foreach ($disks as $dsk){
            foreach($cabs as $item){
                if($item['id'] == $dsk['cabinet_id'])
                {
                    $is_alive = true;
                    break;
                }
            }
            if(!$is_alive){
                $db->delete($dsk['id']);
            }
            $is_alive = false;
        }
    }
    /***
     * Cab信息处理
     */
    private function hdlDevInfo()
    {
        $id_start_pt = 0;
        if ($this->msg->isSuccess()) {
            $this->RTLog("START TO HANDLE DEVINFO MSG");
            $cabDb = M('Cab');
            // 获得所有在位柜子
            foreach ($_POST['cabinets'] as $cab) {
                // 依据柜子序列号进行查找
                $map['name'] = array('eq', $cab['sn']);
                $items = $cabDb->where($map)->select();
                if($items){
                    if(count($items) > 1){
                        foreach ($items as $idx=>$item){
                            if($idx > 0){
                                $cabDb->where("id={$item['id']}")->delete();
                                $cabDb->table("gui_device")->where("cabinet_id={$item['id']}")->delete();
                            }

                        }
                    }
                    $item = $items[0];
                    $item['level_cnt'] = $cab['level_cnt'];
                    $item['group_cnt'] = $cab['group_cnt'];
                    $item['disk_cnt'] = $cab['disk_cnt'];
                    $item['loaded'] = 1;
                    //如果发生变化，则新增告警
                    $item['sn'] = $cab['id'];

                    $cabDb->save($item);
                }
                else {
                    $data['sn'] = $cab['id'];
                    $data['name'] = $cab['sn'];
                    $data['level_cnt'] = $cab['level_cnt'];
                    $data['group_cnt'] = $cab['group_cnt'];
                    $data['disk_cnt'] = $cab['disk_cnt'];
                    $data['loaded'] = 1;
                    $cabDb->add($data);
                }
                //更新cab id起点
                if((int)$cab['id'] > $id_start_pt){
                    $id_start_pt = (int)$cab['id'];
                }
            }
            //如果有不再在位的柜子，系统为其重新分配ID
            $all_cabs = $cabDb->select();
            $all_disks = $cabDb->table("gui_device")->field(array('id', 'cabinet_id','cab_id'))->select();
            $all_busy_disks = $cabDb->table("gui_cmd_disk")->select();
            foreach ($all_cabs as $l_cab) {
                if($l_cab['loaded'] == 1) {
                    $is_load = false;
                    foreach ($_POST['cabinets'] as $cab) {
                        if ($cab['sn'] == $l_cab['name']) {
                            $is_load = true;
                        }
                    }
                    if (!$is_load) {
                        $l_cab['loaded'] = 0;
                    }
                }
                //更新不在位磁盘柜的device id号码
                if($l_cab['loaded'] == 0) {
                    $id_start_pt = $id_start_pt + 1;
                    $l_cab['sn'] = $id_start_pt;
                    $cabDb->save($l_cab);
                }
                $this->updateDeviceId($all_disks,$all_busy_disks,$l_cab);
            }
            $this->cleanDisks($all_cabs, $all_disks);
        }
        //更新所有的sn号码

    }
    private function updateDeviceId($disks,$busy_disks,$l_cab){
        $db = M("Device");
        foreach($disks as $dsk){
            if($dsk['cabinet_id'] == $l_cab['id']){
                $dsk['cab_id'] = $l_cab['sn'];
                $db->save($dsk);
            }

        }
        $db = M("CmdDisk");
        foreach($busy_disks as $dsk){
            if($dsk['db_cab_id'] == $l_cab['id']){
                $dsk['cab'] = $l_cab['sn'];
                $db->save($dsk);
            }
        }
    }
    private function fileTreeMsgHandle()
    {
        $subcmd = $_POST['subcmd'];
        $id = $_POST['CMD_ID'];
        $status = $_POST['status'];
        $substatus = $_POST['substatus'];
        $db = M('CmdLog');
        if ($status == '0' && $substatus == '2') {
            $item = $db->find($id);
            if ($item) {
                $item['progress'] = $_POST['progress'];
                $db->save($item);
            }
        }
    }

    private function hdlMd5Msg()
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
                        $item['extra_info'] = $_POST['temperature'];
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
                break;
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
        $cab_db = M('Cab');
        $cab = $cab_db->where("sn=$cab_id")->find();
        $cab_id = $cab['id'];
        $map = "level=$level and zu=$group and disk=$disk and cabinet_id = $cab_id";
        return $map;
    }

    private function updateDiskMd5()
    {
        $map = $this->getDiskMap();
        $db = M('Device');
        $diskDb = M('Disk');
        $item = $db->where($map)->find();
        $data['md5'] = $_POST['result'];
        $data['md5_time'] = time();
        if (!$item['disk_id'] || is_null($item['disk_id'])) {
            $item['disk_id'] = $diskDb->add($data);
            $db->save($item);
        } else {
            $data['id'] = $item['disk_id'];
            $disk = $diskDb->find($data['id']);
            if ($disk['md5'] != $data['md5']) {
                $log_db = M("DiskChgLog");
                $dsk_hdler = new Dsk();
                $dsk_hdler->hdlDskChg($disk, 'md5', $data['md5']);

            }
            $diskDb->save($data);
        }
    }

    public function getCheckDsk($cmd)
    {
        //     $msg = json_decode($cmd['msg'],true);
        $dsk_db = M('device');
        /*    $map['cab_id'] = array('eq', $msg['device_id']);
            $map['level'] = array('eq', $msg['level']);
            $map['zu'] = array('eq', $msg['group']);
            $map['disk'] = array('eq', $msg['disk']);*/
        $check_type = "";
        switch ($cmd['cmd']) {
            case 'MD5':
                $check_type = 'md5';
                break;
            case 'DISKINFO':
                $check_type = 'sn';
                break;
        }
        $map = array($check_type . "_cmd_id" => (int)$cmd['id']);
        $dsk = $dsk_db->where($map)->find();
        return $dsk;
    }

    public function hdlSelfCheck($cmd)
    {
        $cmd['status'] = $_POST['status'];
        $dsk_db = M('Device');
        //用户发出停止命令
        if ($cmd['user_id'] != C('SYSTEM_USER_ID')) {
            //用户发起的命令
            $dst_cmd = $this->db->find($cmd['dst_id']);
            if (!$dst_cmd || $dst_cmd['user_id'] != C('SYSTEM_USER_ID')) {
                //不是自检消息
                return;
            }
            //用户发起的终止命令


            $dsk = $this->getCheckDsk($dst_cmd);
            if ($cmd['status'] == C('CMD_SUCCESS')) {
                $dsk[strtolower($cmd['cmd']) . "_status"] = C('PLAN_STATUS_WAITING');
                $dsk[strtolower($cmd['cmd']) . "_skipped"] = 1;
                $dsk_db->save($dsk);
            } else {
                //终止命令失败:如果返回值表示MD5未开始

            }
            return;
        }
        //MD5命令的如果返回成功信息,而子命令不是STOP,则证明命令未结束,返回
        if ($cmd['cmd'] == 'MD5' && $cmd['subcmd'] != 'STOP' && $_POST['status'] == C('CMD_SUCCESS')) {
            return;
        }
        //如果
        $dsk = $this->getCheckDsk($cmd);
        //自检类型
        $type = $cmd['cmd'] == 'MD5' ? 'md5' : 'sn';
        $status = $type . "_status";
        //检查当前是否有在执行的计划
        $plan_db = M('CheckPlan');
        $is_plan_alive = false;
        $map = array(
            'status' => array('eq', C('PLAN_STATUS_WORKING')),
            'type' => array('eq', $type)
        );
        if ($plan = $plan_db->where($map)->find()) {
            $is_plan_alive = true;
        }
        if ($dsk) {
            switch ($cmd['status']) {
                case C('CMD_SUCCESS'):
                    if ($is_plan_alive) {
                        $dsk[$status] = C('PLAN_STATUS_SUCCESS');
                    } else {
                        //说明计划被终止
                        $dsk[$status] = C('PLAN_STATUS_WAITING');
                    }
                    break;
                default:
                    //失败，稍后重试
                    $dsk[$status] = C('PLAN_STATUS_WAITING');
            }
            $dsk_db->save($dsk);
        }
        return;
        //修改计划日志
        $plan_log_db = M('DskCheckLog');
        $data['plan_id'] = $cmd['plan_id'];
        $data['dsk_id'] = $dsk['id'];
        $data['finish_time'] = time();
        $data['status'] = $cmd['status'];
        $plan_log_db->add($data);

    }

    /*********
     * 子命令为stop,progress或者result的消息单独处理
     */
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
                            $this->terminate($dstCmd, C('CMD_CANCELED'));
                        }
                        //$this->db->save($dstCmd);
                    }
                    //已经结束
                    $this->terminate($cmd, C('CMD_SUCCESS'));
                    break;
                case 'RESULT':
                    echo 'Handling Result';
                    $keys = array('md5');
                    $values = array($_POST['result']);
                    $dsk = new Dsk();
                    $dsk->init();
                    //$dsk->updateDiskInfo($keys, $values);
                    if ($this->msg->cmd == 'MD5') {
                        echo 'MD5 RESULT';
                        $this->updateDiskMd5();
                    }
                    //将状态更新为等待停止
                    $cmd['stage'] = 'STOP';
                    $this->RTLog($cmd['stage']);
                    $this->db->save($cmd);
                    break;
                case 'PROGRESS':
                    //for md5 and copy, update progress
                    $this->RTLog('Handling Progress');
                    $cmd['progress'] = (float)$_POST['progress'];
                    if ($cmd['cmd'] == 'MD5') {
                        $cmd['extra_info'] = json_encode(array('temp' => $_POST['temperature']));
                    } else if ($cmd['cmd'] == 'COPY') {
                        $cmd['extra_info'] = json_encode(array('src_temp' => $_POST['src_temp'], 'dst_temp' => $_POST['dst_temp']));
                    }
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
        $log['started'] = 1;
        $log['substatus'] = $this->msg->substatus;
        $this->db->save($log);
    }

    public
    function getLog($id)
    {
        return $this->db->find($id);
    }

    public function RTLog($txt = 'love you')
    {
        return;//only for debug
        // $txt = $txt . "++\r\n";
        // fwrite($this->file, $txt);
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
        $keys = array('bridged', 'path', 'protected');
        $values = array(0, '', 0);
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
            //命令成功
            $log['status'] = C('CMD_SUCCESS');
            $device_db = M('Device');
            $map['cab_id'] = array('eq', $this->msg->cab_id);
            $map['level'] = array('eq', $_POST['level']);
            $device_db->where($map)->select();
            if ($stop) {
                //处理被桥接的命令，其实一般用不到

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

        $this->terminate($log, $log['status']);
        $this->quit();
        //return msg

    }

    public function updateCab()
    {
        $cab_db = M('Cab');
        //echo "cab handle start";
        $map['sn'] = array('eq', $this->msg->cab_id);

        $log = $cab_db->where($map)->find();
        //var_dump($log);
        $log['voltage'] = $_POST['voltage'];
        $log['charge'] = $_POST['current'];//电量
        $log['electricity'] = $_POST['electricity'];//电流
        //电流、电压、电量告警信息
        if ($_POST['push'] === '1') {
            //处理各层温度湿度和串口通信信息
            $this->hdlCabCaution();
        }
        $log['status'] = $this->msg->return_msg;
        $cab_db->save($log);
        //var_dump($cab_db->where($map)->find());
    }

    /***
     * 获取硬盘在位信息返回数据处理函数
     * @作者 Wilson Xu
     */
    public
    function hdlDevStatus()
    {
        //将命令状态设为已完成;

        $dsk = new Dsk();
        $dsk->init();
        //在位信息以后改为用Redis维护
        if ($this->msg->isSuccess()) {
            //电压电流信息
            //echo "voltage of the cab updating--处理电流电压";
            self::updateCab();
            if ($_POST['CMD_ID'] == '0') return;
            $db = M('Device');
            $cabinet = M('Cab')->where(array('sn' => $this->msg->cab_id, 'loaded' => 1))->find();
            if (!$cabinet) {
                return;
            }

            $cabinet_id = $cabinet['id'];
            // 找出所有在位的硬盘，去除非在位硬盘
            $load_disks = $db->where(array('loaded' => 1, 'cabinet_id' => $cabinet_id))->select();
            foreach ($load_disks as $l_disk) {
                $is_load = false;
                foreach ($_POST['levels'] as $level) {
                    if ($level['id'] != $l_disk['level']) continue;

                    foreach ($level['groups'] as $group) {
                        if ($group['id'] != $l_disk['zu']) continue;
                        foreach ($group['disks'] as $disk) {
                            if ($disk == $l_disk['disk']) {
                                $is_load = true;
                            }
                        }
                    }
                }

                if (!$is_load) {
                    $l_disk['loaded'] = 0;
                    $db->save($l_disk);
                }
            }

            $levels = $_POST['levels'];
            foreach ($levels as $level) {
                $level_id = $level['id'];
                $groups = $level['groups'];
                foreach ($groups as $group) {
                    $group_id = $group['id'];
                    $disks = $group['disks'];
                    foreach ($disks as $disk) {
                        $map['level'] = array('eq', $level_id);
                        $map['zu'] = array('eq', $group_id);
                        $map['disk'] = array('eq', $disk);
                        $map['cab_id'] = array('eq', $dsk->cab);
                        $map['cabinet_id'] = array('eq', $cabinet_id); // id相同
                        $item = $db->where($map)->find();
                        if ($item) {
                            $item['loaded'] = 1;
                            $item['time'] = time();
                            $db->save($item);
                        } else {
                            $item['loaded'] = 1;
                            $item['level'] = $level_id;
                            $item['zu'] = $group_id;
                            $item['disk'] = $disk;
                            $item['cab_id'] = $dsk->cab;
                            $item['cabinet_id'] = $cabinet_id;
                            $db->add($item);
                        }
                    }
                }
            }
        }
    }

    private function getLogByMsg()
    {
        $msg = $this->msg;
        $map['cmd'] = array('eq', $msg->cmd);
        $map['finished'] = array('eq', 0);
    }

    /***************
     * 处理proxy推送回来的消息
     */
    private function hdlPushMsg()
    {

    }

    public function hdlDiskInfo()
    {
        //暂时不维护此命令状态，太麻烦;
        //后期修改cmdlog，增加diskinfo一项，记录操作对象。

        //在位信息以后改为用Redis维护
        if ($_POST['status'] == 0) {
            //查看是否对应盘位绑定了硬盘
            //若未绑定
            $dsk_hdler = new Dsk();
            $map = $this->getDiskMap();//"level=$level and zu=$group and disk=$disk and device_id=$cab_id";
            $db = M('Device');
            $diskDb = M('Disk');
            $item = $db->where($map)->find();
            //var_dump($item);
            if (!$item) {
                die("Disk not found");
            }
            $data = array(
                'sn'=>$_POST['SN'],
                'capacity'=>$_POST['capacity'],
                'power_on_count'=>$_POST['PowerOnCount'],
                'power_on_value'=>$_POST['PowerOnRawValue'],
                'firmware'=>$_POST['firmware'],
                'health'=>$_POST['health'],
                'rotation'=>$_POST['rotation'],
                'title'=>$_POST['title'],
                'temperature'=>$_POST['temperature'],
            );
            $data['sn'] = $_POST['SN'];
            $data['capacity'] = $_POST['capacity'];
            $data['normal'] = (int)$_POST['disk_status'] == 0 ? 1 : 0;
            //检查该sn号的硬盘是否已存在,如果不存在,新建条目

            $disk_id = $data['id'] = $dsk_hdler->getDskBySN($data['sn']);
            $data['sn_time'] = time();
            $diskDb->save($data);
            //var_dump($item);
            //初次获取信息或者sn号发生变化
            if ($item['disk_id'] !== $disk_id) {

                //更新盘位对应的磁盘id
                $item['disk_id'] = $disk_id;
                $db->save($item);
            }

            // for report
            $this->write_smart_log();

            //更新修改时间

            $this->updateSmart($disk_id);
        }
    }

    /******
     * 更新Smart值
     * @input: disk_id, $_POST
     */
    private function updateSmart($id)
    {
        $db = M('DiskSmart');
        $db->where("disk_id = $id")->delete();

        $attrs = $_POST['SmartAttrs'];
        foreach ($attrs as $attr) {
            //查找是否存在
            //$attr = $attr;
            $map['disk_id'] = array('eq', $id);
            $map['attr_id'] = array('eq', $attr['id']);
            $data = array(
                "c_val" => $attr["c_val"],
                "raw_val" => $attr["raw_val"],
                "sts" => $attr['sts'],
                "thd" => $attr['thd'],
                "w_val" => $attr['w_val'],
                'attr_id'=>$attr['id']
            );
            if ($item = $db->where($map)->find()) {
                /*  $item['dat'] = $attr['dat'];
                  $item['ex_dat'] = $attr['ex_dat'];
                  $item['flag'] = $attr['flag'];
                  $item['thd'] = $attr['thd'];
                  $item['val'] = $attr['val'];
                  $item['w_val'] = $attr['w_val'];
                  $item['normal'] = $attr['sts'] && $attr['sts'] == '1' ? 0 : 1;*/
                $data['id'] = $item['id'];
                $db->save($data);
            } else {
                $data['disk_id'] = $id;
                $db->add($data);
            }
        }
    }

    public function hdlSuccess()
    {
        $log = $this->db->find($this->msg->id);
        if ($log) {
            $log['status'] = C('CMD_SUCCESS');
            //如果不属于需要停止的命令，或者需要停止的命令而当前就是停止命令
            if (!$this->msg->needStop() || ($this->msg->needStop() && $this->msg->subcmd == 'STOP')) {
                $this->terminate($log, C('CMD_SUCCESS'));
            } else {
                $log['return_msg'] = file_get_contents('php://input');
                $this->db->save($log);
            }
        }
    }

    public function hdlWriteProtectMsg()
    {
        //获取对应的层
        $db = M('Device');
        $level = $_POST['level'];
        $disks = $db->where("level=%d and cab_id=%d", $level, $this->msg->cab_id)->select();
        foreach ($disks as $disk) {
            $disk['protected'] = $_POST['subcmd'] == 'START' ? 1 : 0;
            $db->save($disk);
        }
        $disks = $db->field('protected,cab_id,level')->where("level=%d and cab_id=%d", $level, $this->msg->cab_id)->select();
        //var_dump($disks);
    }

    /***********
     * @param $new_sts 推送的状态
     */
    private function updateCautionLog()
    {
        echo "<h3>Updating log</h3>";
        $new_sts = $_POST;
        //检查当前柜子的状态
        $cab_id = $this->msg->cab_id;
        $db = M("Cab");
        $cab = $db->where("sn=$cab_id")->find();
        if (!$cab) {
            echo "No cab found.<br/>";
            return;
        }
        $cab_status = json_decode($cab['status'], true);
        //var_dump($cab_status);
        //var_dump($new_sts);
        if ($this->isWorse($cab_status, $new_sts)) {
            echo "yes, is worse";
            //新增日志
            $data = array(
                'cab_id' => $cab_id,
                'cabinet_id'=>$cab['id'],
                'status' => $this->msg->return_msg,
                'pushed' => 0,
                'time' => time()
            );
            $log_db = M('CabCautionLog');
            $log_db->add($data);

        }
        else{
            echo "Nothing special.";
        }
    }

    /*************
     * @author Wilson Xu
     * @function 处理推送回来的告警信息
     */
    public function hdlCabCaution()
    {

        //更新错误日志，包括命令名称，错误内容。--增加表；
        if (!$_POST['push'] || $_POST['push'] === '0') {
            return;
        }
        $this->updateCautionLog();
        $db = M($this->cmdDiskTbl);
        if ($this->msg->cmd === 'DEVICESTATUS') {
            $cab_id = (int)$_POST['device_id'];
            //磁盘级别告警
            $map['cab'] = array('eq', $cab_id);
            if ($_POST['elec_sts'] === '2' || $_POST['volt_sts'] === '2' || $_POST['curr_sts'] === '2') {
                //严重告警,停止所有磁盘命令

                $logs = $db->where($map)->field('cmd_id')->group('cmd_id')->select();
                foreach ($logs as $item) {
                    $id = $item['cmd_id'];
                    $cmd_log = $this->db->find($id);
                    if ($cmd_log && $cmd_log['finished'] === 0) {
                        $this->terminate($cmd_log, C('CMD_CANCELED'));
                    }
                }
                return;
            }
            $levels = $_POST['levels'];
            foreach ($levels as $item) {
                //检查该层有没有问题
                if ($item['temp_sts'] == '2' || $item['hum_sts'] == '2' || $item['chan_sts'] == '1') {
                    //该层有问题
                    $map['level'] = $item['id'];
                    $logs = $db->where($map)->field('cmd_id')->group('cmd_id')->select();
                    foreach ($logs as $log_item) {
                        $id = $log_item['cmd_id'];
                        $cmd_log = $this->db->find($id);
                        if ($cmd_log && $cmd_log['finished'] === 0) {
                            $this->terminate($cmd_log, C('CMD_CANCELED'));
                        }
                    }
                }
            }
        }

    }

    /************
     * @param $cab_sts 记录的柜子状态
     * @param $new_sts 新推送的柜子状态
     * @return bool true: 柜子健康状态变差,需要告警; false: 不存在
     */
    private function isWorse($cab_sts, $new_sts)
    {
        // var_dump($cab_sts);
        if ($new_sts['curr_sts'] && (int)$new_sts['curr_sts'] > 0) {
            if (!$cab_sts || !$cab_sts['curr_sts'] || (int)$cab_sts['curr_sts'] < (int)$new_sts['curr_sts']) {
                echo "Curr:" . $cab_sts['curr_sts'] . "/" . $new_sts['curr_sts'] . "<br>";
                return true;
            }
        }
        if ($new_sts['volt_sts'] && (int)$new_sts['volt_sts'] > 0) {
            if (!$cab_sts || !$cab_sts['volt_sts'] || (int)$cab_sts['volt_sts'] < (int)$new_sts['volt_sts']) {
                echo "Volt:" . $cab_sts['volt_sts'] . "/" . $new_sts['volt_sts'] . "<br/>";
                return true;
            }
        }
        if ($new_sts['elec_sts'] && (int)$new_sts['elec_sts'] > 0) {
            if (!$cab_sts || !$cab_sts['elec_sts'] || (int)$cab_sts['elec_sts'] < (int)$new_sts['elec_sts']) {
                echo "elec" . $cab_sts['elec_sts'] . "/" . $new_sts['elec_sts'] . "<br/>";
                return true;
            }
        }
        //检查每一层
        $levels = $new_sts['levels'];
        $old_levels = $cab_sts['levels'];
        foreach ($levels as $idx => $lvl) {
            $old_lvl = $old_levels[$idx];
            if ($lvl['hum_sts'] && (int)$lvl['hum_sts'] > 0) {
                if (!$old_lvl['hum_sts'] || (int)$old_lvl['hum_sts'] < (int)$lvl['hum_sts']) {
                    return true;
                }
            }
            if ($lvl['temp_sts'] && (int)$lvl['temp_sts'] > 0) {
                if (!$old_lvl['temp_sts'] || (int)$old_lvl['temp_sts'] < (int)$lvl['temp_sts']) {
                    return true;
                }
            }
            if ($lvl['chan_sts'] && (int)$lvl['chan_sts'] > 0) {
                if (!$old_lvl['chan_sts'] || (int)$old_lvl['chan_sts'] < (int)$lvl['chan_sts']) {
                    return true;
                }
            }

        }
        return false;
    }

    public function addRtErrLog()
    {
        echo "add llog";
        $rt_err_db = M('RunTimeErrLog');
        $data = array(
            'time' => time(),
            'cmd_id' => $this->msg->id,
            'err_code' => $_POST['err_code'],
            'err_msg' => $_POST['err_str']
        );
        $rt_err_db->add($data);
    }

    /***
     * update the command log
     * @author: wilson xu
     */
    public function updateCmdLog()
    {
        $runtime_error = array('63', '64', '65');
        if (in_array($_POST['status'], $runtime_error)) {
            //err_code
            if ($_POST['err_code']) {
                if ($_POST['err_code'] == C('ERR_CODE_OK'))
                    $_POST['status'] = $this->msg->setStatus(C('CMD_GOING'));
                else {
                    if ($this->msg->cmd == 'BRIDGE') {
                        //解除桥接状态
                        $map = array(
                            'cab_id' => array('eq', $_POST['device_id']),
                            'level' => array('eq', $_POST['level']),
                            'zu' => array('eq', $_POST['group']),
                            'bridged' => 1
                        );
                        $db = M("Device");
                        $disks = $db->where($map)->select();
                        //var_dump($disks);
                        foreach ($disks as $item) {
                            $item['bridged'] = 0;
                            $db->save($item);
                        }
                    }
                }
            }

            $this->addRtErrLog();

        }
        //服务器主动推送的信息
        if ($this->msg->id == "0") {
            $this->RTLog('SERVER GOT AN MSG FROM PROXY.');
            return;
        }
        //出错，输出错误信息
        if ($this->msg->isFail()) {
            echo "failed";
            //failed
            $this->hdlFail();
            $this->quit();
        }

        $this->write_md5_log();

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
