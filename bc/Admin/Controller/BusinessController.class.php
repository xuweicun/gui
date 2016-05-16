<?php
namespace Admin\Controller;

use Think\Controller;

header('Access-Control-Allow-Origin:*');
header('Access-Control-Allow-Headers: X-Requested-With,content-type');
$content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
if ($content_type_args[0] == 'application/json') {
    $_POST = json_decode(file_get_contents('php://input'), true);
}

class BusinessController extends Controller
{
    /*********
     * @index
     * @todo: 查询柜子和磁盘的状态信息，生成主页
     * @author: wilson xu
     */
    public function index()
    {
        //check permission --to delay

        //initiate database   --generate model
        if (!session('?user')) {
            U('login');
            $this->redirect('login');

        } else {
            $Username = session('user');
            $this->assign('username', $Username);
            $this->assign('userid', session('userid'));
            //generate the page
            //先检查有没有柜子
            $db = M('Cab');
            $items = $db->select();
            if (!$items) {
                $this->redirect('SystemInit');
            } else
                $this->display();
        }
    }

    public function systReset()
    {
        //所有硬盘桥接、在位状态清零
        $db = M('Device');
        $items = $db->select();
        foreach ($items as $item) {
            $item['bridged'] = 0;
            $item['loaded'] = 0;
            $item['path'] = '';
            $db->save($item);
        }
        //所有命令状态取消
        $this->cancelAllCmds();
    }

    private function cancelAllCmds()
    {
        $db = M('CmdLog');
        $going = C('CMD_GOING');
        $items = $db->where("status=$going")->select();
        foreach ($items as $item) {
            $item['status'] = C('CMD_CANCELED');
            $item['finished'] = 1;
            $db->save($item);
        }
    }

    public function deleteLog()
    {
        $db = M('CmdLog');
        $id = I('get.id', 0, 'intval');
        if ($db->find($id)) {
            $map['id'] = array('eq', $id);
            $db->where($map)->delete();
        } else {
            $this->notFoundError('Cmd not found');
        }
    }

    public function insertUser()
    {
        if (IS_POST) {
        } else {
            $user = I('get.user');
            $pwd = I('get.pwd');
            $db = M('Super');
            $data['name'] = $user;
            $data['pwd'] = md5($pwd);
            if ($db->where("name='$user'")->find()) {
                $this->error('用户名重复', U('login'));
                return;
            }
            if ($db->add($data)) {
                $this->success("增加成功", U('login'));
            } else {
                $this->error('插入失败', U('login'));
            }
        }
    }

    public function login()
    {
        if (session('?user')) {
            $this->redirect('index');
            die();
        }
        if (IS_POST) {
            $User = M('super');
            $uname = I('post.uname');
            $item = null;
            $cond['name'] = array('eq', $uname);
            $cond['pwd'] = array('eq', md5(I('post.pwd')));

            if (!$item = $User->where($cond)->find()) {
                $this->error('登录失败');;
            } else {
                session('user', $uname);
                session('userid', $item['id']);
                $this->success('成功登录', U('index'));
            }
        } else {
            $this->display();
        }
    }

    public function bridge()
    {
        $this->display('bridge');
    }

    public function temp()
    {


    }

    public function search()
    {
        $this->display("search");

    }

    /**
     * 获取正在进行的任务清单
     *
     */
    public function getGoingTasks()
    {
        $db = M('CmdLog');
        $items = $db->where("finished = 0")->select();
        foreach ($items as $index => $item) {
            $items[$index]['msg'] = stripslashes($item['msg']);
            $items[$index]['current_time'] = time();
        }
        $this->AjaxReturn($items);
    }

    public function getTestResults()
    {
        $db = M('Test');
        $items = $db->select();
        foreach ($items as $item) {
            var_dump($item);

            echo "<br/>";
        }
    }

    public function waitTilDone($cmd, $maxTime)
    {
        $exctTime = 0;
        $cmdDb = M('CmdLog');
        $status = -1;//未完成
        $map['cmd'] = array('eq', $cmd);
        $map['status'] = array('eq', $status);
        while ($exctTime < $maxTime) {
            sleep(1);
            $exctTime = $exctTime + 1;
        }
    }

    public function setTimeOut()
    {
        $db = M('CmdLog');
        $map['id'] = array('eq', I('get.id'));
        $item = $db->where($map)->find();
        $item['status'] = C('CMD_TIMEOUT');
        $db->save($item);
    }

    public function getBridgeStatus()
    {
        $cmd = 'BRIDGE';
        $subcmd = 'START';
        $db = M('CmdLog');
        $map['cmd'] = array('eq', $cmd);

        $item = $db->where($map)->find();
        if ($item) {
            if ($item['status'] == 0) {
                $db->where("id={$item['id']}")->delete();
            }
            $this->AjaxReturn($item);
        } else {
            $this->notFoundError('bridge not found in log');
        }
    }

    /**
     * show how many cabs here
     */
    public function getCabInfo()
    {
        $db = M('Cab');
        $items = $db->where('loaded=1')->select();
        $this->AjaxReturn($items);
    }

    public function getDeviceInfo()
    {
        //initiate database   --generate model
        $db = M('Device');
        $viewDb = D('DeviceView');
        $map['cab_id'] = array('eq', I('get.cab'));
        $rooms = $db->where($map)->select();
        $roomView = $viewDb->where($map)->select();
        $rooms = count($rooms) > count($roomView) ? $rooms : $roomView;
        $returnData = array();
        foreach ($rooms as $item) {
            $item['time'] = date("Y-m-d H:i:s", $item['time']);
            $returnData[] = $item;
        }
        $this->AjaxReturn($returnData);
        //var_dump($returnData);
    }

    /***
     * to return any operating command
     */
    public function clearAll()
    {
        $db = M('CmdLog');
        $items = $db->where('status=-1')->field('cmd')->select();
        $this->AjaxReturn($items);
    }

    /***
     * 检查是否有相同的命令正在执行；后期应该加上硬盘信息；
     * @author: wilsonxu
     * @input:  cmd, subcmd, level, group, disk;
     */
    public function checkCollision()
    {
        $db = M('CmdLog');
        $data['cmd'] = $_POST['cmd'];
        $data['subcmd'] = $_POST['subcmd'];
        //$cmd = I('post.cmd');
        //$subcmd = I('post.subcmd');
        $status = -1;//-1 represents that the commond is not finished yet.
        //$map['cmd'] = array('like',$cmd);
        //$map['subcmd'] = array('like',$subcmd);
        $map['status'] = array('eq', $status);
        $data['isLegal'] = 1;
        if (!$db->where($map)->find()) {
            $this->AjaxReturn($data);
        } else {

            $this->AjaxReturn($data);
        }
    }

    public function getCmdResult()
    {
        $db = M('CmdLog');
        if (IS_POST) {
            $tasks = $_POST['tasks'];
            $results = array();
            foreach ($tasks as $task) {
                $item = $db->find($task);
                if ($item) {
                    $results[] = $item;
                }
            }
            $this->AjaxReturn($results);
            return;
        }
        $id = I('get.cmdid');

        $item = $db->find($id);
        if ($item) {
            $this->AjaxReturn($item);
        } else {
            $this->notFoundError("not found this commond in the log");
        }
    }

    public function originSql()
    {
        $conn = mysqli_connect("localhost", "root", "moganfreeman", "gui");
        $sql1 = "alter table gui_device auto_increment=1";
        $sql2 = "alter table gui_disk auto_increment=1";
        $sql3 = "alter table gui_disk_smart auto_increment=1";
        $sql4 = "alter table gui_cmd_log auto_increment=1";
        $result = mysqli_query($conn, $sql1);
        $result = mysqli_query($conn, $sql2);
        $result = mysqli_query($conn, $sql3);
        $result = mysqli_query($conn, $sql4);
        mysqli_close($conn);
    }

    /****
     * 系统初始化函数
     */
    public function SystemInit()
    {
        $this->display('deploy');
        die();
        $level = $_POST['level'];
        if (!$level) {
            $errmsg = 'inadequate infomation';
            $this->AjaxReturn($errmsg);
            die();
        }
        $group = $_POST['group'];
        $disk = $_POST['disk'];
        $db = M('Device');
        $db->where('1')->delete();
        $newDb = M('Disk');
        $newDb->where('1')->delete();
        $newDb = M('DiskSmart');
        $newDb->where('1')->delete();
        $newDb = M('CmdLog');
        $newDb->where('1')->delete();
        $this->originSql();
        $gui_device = 'gui_device';
        //循环插入信息值Device表中，并初始化为已经在位，尚未桥接。
        for ($i = 1; ; $i++) {
            if ($i > $level)
                break;
            $data['level'] = $i;
            for ($j = 1; ; $j++) {
                if ($j > $group)
                    break;
                $data['zu'] = $j;
                for ($k = 1; $k <= $disk; $k++) {
                    if ($k > $disk)
                        break;
                    $data['disk'] = $k;
                    $data['loaded'] = 1;
                    $data['bridged'] = 0;

                    $db->add($data);
                }
            }
        }

    }

    public function filetree()
    {

        $disk = I("get.f");
        $this->assign("disk", $disk);
        $this->display();
    }

    /**
     * To update the log, by adding msg, changing subcmd and so on
     */
    public function updateCmdLog()
    {

        if ($_POST['id']) {
            $db = M('CmdLog');
            //日志更新
            $log = $db->find($_POST['id']);
            if ($_POST['subcmd']) {
                //更新子命令
                $log['subcmd'] = $_POST['subcmd'];
            }
            $log['msg'] = $_POST['msg'];
            $db->save($log);
            $this->AjaxReturn($log);
        }
    }

    /***
     * to insert a new commond-request log, driven by javascript
     * @input: cmd, subcmd,
     */
    public function AddCmdLog()
    {
        $content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
        if ($content_type_args[0] == 'application/json') {
            $_POST = json_decode(file_get_contents('php://input'), true);
        }
        $this->updateCmdLog();
        $db = M('CmdLog');

        $data['user_id'] = I('get.userid', 0, 'intval');
        $data['cmd'] = $_POST['cmd'];
        $data['sub_cmd'] = $_POST['subcmd'];
        $data['status'] = C('CMD_GOING');//-1 represents that the commond is not finished yet.
        $data['start_time'] = time();
        $data['finished'] = 0;
        //如果是停止令，需要注明dst_id;
        if ($_POST['CMD_ID'] && $_POST['subcmd'] == 'STOP') {
            $data['dst_id'] = $_POST['CMD_ID'];
        }
        $id = $db->add($data);
        if ($id) {
            $data = $db->find($id);
            $msg = $_POST['msg'];
            //修改msg
            $data['msg'] = $this->addMsgId($msg, $id);
            $db->save($data);
            $this->AjaxReturn($data);
        } else {
            //throw an exception
            $this->notFoundError("fail to insert the cmd log");
        }

    }

    /*********
     * @param $msg 原始JSON字符串
     * @param $id  命令ID
     */
    private function addMsgId($msg, $id)
    {
        $idStr = "\"CMD_ID\":\"" . $id . "\",\"cmd\"";
        $rst = str_replace("\"cmd\"", $idStr, $msg);
        return $rst;
    }

    /***
     * add the disks refered in an commond excutation
     * @author: wilson xu
     * @input: posted levels or level group disk or level group disks
     * @input: sent commond id
     */
    public function cmdReferedDisks($id)
    {
        $levels = I('post.levels');
        $db = M('CmdDisks');
        $data['id'] = $id;
        if ($levels) {
            foreach ($levels as $item) {
                $data['level'] = $item;
                $this->handleGroup($data, $db);
            }
        } else {
            $level = I('post.level');
            if ($level) {
                $data['level'] = $level;
                $this->handleGroup($data, $db);
            } else {
                //something wrong
                $data['error'] = "No disk assigned to the commond. Recheck the code.";
                $this->AjaxReturn($data);

            }
        }

    }

    private function handleGroup($data, $db)
    {
        $groups = I('post.groups');
        if ($groups) {
            foreach ($groups as $group) {
                $data['group'] = $group;
                $this->handleDisk($data, $db);

            }


        } else {

            $group = I('post.group');
            if ($group) {
                $data['group'] = $group;
                $this->handleDisk($data, $db);
            } else {
                $db->add($data);
            }

        }

    }

    private function handleDisk($data, $db)
    {
        $disks = I('post.disks');
        if ($disks) {
            foreach ($disks as $disk) {
                $data['disk'] = $disk;
                $db->add($data);
            }
        } else {
            $disk = I('post.disk');
            if ($disk) {
                $data['disk'] = $disk;
            }
            $db->add($data);
        }
    }

    public function getDiskInfo()
    {
        //check permission


        $level = $_POST['level'];
        $group = $_POST['group'];
        $disk = $_POST['disk'];
        $cab = $_POST['cab_id'];
        $db = D('DeviceView');
        $map = "level=$level and zu=$group and disk=$disk and cab_id=$cab";
        $item = $db->where($map)->select();
        if ($item) {
            $this->AjaxReturn($item);
            die();
        } else {
            $this->notFoundError('incorrect disk position or disk not loaded');
        }

        //query database
        //return
    }

    public function init()
    {
        $this->display("systeminit");
    }

    private function notFoundError($appended = '')
    {
        $data['errmsg'] = 'item does not exists--' . $appended;
        $this->AjaxReturn($data);
    }

    public function logout()
    {
        session_unset();
        session_destroy();
        $this->display("logout");
    }

    public function chg_pwd()
    {
        //check permission
        //query database
        //return
    }

    public function cmd_exe()
    {
        //check permission
        //query database
        //return
    }

    public function disk_info()
    {
        //check permission
        //query database
        //return
    }

    public function cmd_log()
    {
        //check permission
        //query database
        //return
    }
}
