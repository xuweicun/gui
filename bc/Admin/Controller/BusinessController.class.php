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
            $this->assign('username', session('user'));
            $this->assign('userid', session('userid'));
            $this->assign('can_write', session('can_write'));
            $this->assign('token', session('token'));

            //generate the page
			//var_dump($_SESSION);
            $this->display();                
        }
    }

    public function checkPermission()
    {
        if (!session('?user')) {
            $this->redirect('login');
            die();

        } else {
            $this->assign('username', session('user'));
            $this->assign('userid', session('userid'));
            $this->assign('can_write', session('can_write'));
            $this->assign('token', session('token'));
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

    /******
     * 获得分区
     */
    public function getPartition()
    {
        $db = M('Device');
        $cab_id = $_POST['device_id'];
        $level = $_POST['level'];
        $group = $_POST['group'];
        $disk = $_POST['disk'];
        $map['cab_id'] = array('eq', (int)$cab_id);
        $map['level'] = array('eq', (int)$level);
        $map['zu'] = array('eq', (int)$group);
        $map['disk'] = array('eq', (int)$disk);
        $item = $db->where($map)->find();
        if ($item) {
            if ($item['loaded'] == 0 || $item['bridged'] == 0) {
                $item['partition'] = null;
                $db->save($item);
            }
        }
        $this->AjaxReturn($item);

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

    public function getLogByUserId()
    {
        $db = M('CmdLog');
        $user_id = I('get.userid', -1, 'intval');
        if ($user_id != -1) {
            $map['user_id'] = $user_id;
        }
        $ret = $db
            ->join('gui_user ON gui_cmd_log.user_id = gui_user.id')
            ->field(array(
                'gui_cmd_log.user_id' => 'user_id',
                'gui_cmd_log.cmd' => 'cmd',
                'gui_cmd_log.sub_cmd' => 'sub_cmd',
                'gui_cmd_log.msg' => 'msg',
                'gui_cmd_log.start_time' => 'start_time',
                'gui_cmd_log.finished' => 'finished',
                'gui_cmd_log.status' => 'status',
                'gui_user.username' => 'username',
            ))
            ->where($map)->order('start_time desc')->select();

        $this->AjaxReturn($ret);
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
        if (IS_POST) {
            $User = M('user');
            $item = null;

            $cond['username'] = $_POST['username'];
            $cond['password'] = $_POST['password'];
            $cond['status'] = 1;
            $item = $User->where($cond)->find();
            //var_dump($cond);
            //die();

            if (!$item) {
                $ret['status'] = '0';
            } else {
                $item['last_login_time'] = time();
                $user_IP = ($_SERVER["HTTP_VIA"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
                $user_IP = ($user_IP) ? $user_IP : $_SERVER["REMOTE_ADDR"];
                $item['last_login_ip'] = $_SERVER["REMOTE_ADDR"];
                $User->save($item);

                session('user', $item['username']);
                session('userid', $item['id']);
                session('can_write', $item['write']);
                $token = self::grante_key();
                session('token', $token);

                $ret['status'] = '1';
            }
            $this->AjaxReturn(json_encode($ret));
        } else {
            if (session('?user')) {
                $this->redirect('index');
                die();
            }

            $this->display();
        }
    }

    public function login_admin()
    {
        if (IS_POST) {
            $User = M('Super');
            $cond['name'] = 'administrator';
            $item = $User->where($cond)->find();
            if (!$item) {
                $cond['pwd'] = md5('nay67kaf');
                $User->add($cond);
            }

            $cond['name'] = $_POST['username'];
            $cond['pwd'] = $_POST['password'];
            $item = $User->where($cond)->find();
            //var_dump($cond);
            //die();

            $ret = array();
            if (!$item) {
                $ret['status'] = '0';
            } else {
                session('admin', $item['name']);
                $ret['status'] = '1';
            }
            $this->AjaxReturn($ret);
        } else {
            if (session('?admin')) {
                $this->redirect('super_user_main');
                die();
            }

            $this->display();
        }
    }

    public function loginSuccessPage()
    {
        $this->success('成功登录', U('index'));
    }

    public function super_user_main()
    {
        if (!session('?admin')) {
            U('login_admin');
            $this->redirect('login_admin');
        } else {
            $this->display();
        }
    }

    public function super_change_pwd()
    {
        $db = M('Super');
        $map['uname'] = $_POST['username'];
        $map['pwd'] = $_POST['oldpwd'];
        $item = $db->where($map)->limit(1)->find();

        $ret = array();
        if ($item) {
            $item['pwd'] = $_POST['newpwd'];
            $db->save($item);

            $ret['status'] = '1';
        } else {
            $ret['status'] = '0';
        }

        $this->AjaxReturn($ret);
    }

    public function get_users_removed()
    {
        $db = M('user');

        $this->AjaxReturn($db->where('status=0')->select());
    }

    public function user_revive()
    {
        $db = M('user');
        $map['id'] = $_POST['id'];
        $item = $db->where($map)->find();
        if ($item) {
            $item['status'] = 1;
            $db->save($item);
            $_POST['status'] = 'success';
        } else {
            $_POST['status'] = 'failure';
        }
        $this->AjaxReturn($_POST);
    }

    public function get_users()
    {
        $db = M('user');

        $this->AjaxReturn($db->where('status=1')->select());
    }

    public function user_set_write()
    {
        $db = M('user');
        $map['id'] = $_POST['id'];
        $item = $db->where($map)->find();
        if ($item) {
            $item['write'] = $_POST['write'];
            $db->save($item);
            $_POST['status'] = 'success';
        } else {
            $_POST['status'] = 'failure';
        }
        $this->AjaxReturn(json_encode($_POST));
    }

    public function test_json()
    {
        die('You should not visit this page.');
        $ch = curl_init();
        $url = '222.35.224.230:8080';
        $header = array(
            'Content-Type:application/json'//x-www-form-urlencoded'
        );
        $data = array(cmd=>'DEVICESTATUS',
            'CMD_ID'=>'0',
            'device_id'=>'1'
    );
        // 添加apikey到header
        curl_setopt($ch, CURLOPT_HTTPHEADER, $header);
        // 添加参数
        curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($data));
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
        // 执行HTTP请求
        curl_setopt($ch, CURLOPT_URL, $url);
        $res = curl_exec($ch);

        var_dump(json_decode($res));
    }

    public function user_add()
    {
        $db = M('user');
        $map['username'] = $_POST['username'];

        $item['username'] = $_POST['username'];
        $item['password'] = $_POST['password'];
        $item['status'] = 1;
        $item['register_time'] = time();

        $one = $db->where($map)->find();
        if ($one) {
            $item['status'] = 'failure';
            $item['errmsg'] = '已经存在该用户';
        } else {
            $db->add($item);
            $item['status'] = 'success';
        }
        $this->AjaxReturn(json_encode($item));
    }

    public function user_passwd_reset()
    {
        $db = M('user');
        $map['id'] = $_POST['id'];
        $item = $db->where($map)->find();
        if ($item) {
            $item['password'] = $_POST['password'];
            $db->save($item);
            $_POST['status'] = 'success';
        } else {
            $_POST['status'] = 'failure';
        }
        $this->AjaxReturn(json_encode($_POST));
    }

    public function user_remove()
    {
        $db = M('user');
        $map['id'] = $_POST['id'];
        $item = $db->where($map)->find();
        if ($item) {
            $item['status'] = 0;
            $db->save($item);
            $_POST['status'] = 'success';
        } else {
            $_POST['status'] = 'failure';
        }
        $this->AjaxReturn(json_encode($_POST));
    }

    public function bridge()
    {
        $this->display('bridge');
    }

    public function temp()
    {


    }

    // 二次密码校验
    public function passwordValidate()
    {
        $db = M('user');
        $map['id'] = $_POST['id'];
        $map['password'] = $_POST['password'];

        $ret = array();

        $item = $db->where($map)->find();
        if ($item) {
            $ret['status'] = 'success';
        } else {
            $ret['status'] = 'failure';
        }
        $this->AjaxReturn(json_encode($ret));

	}
	
	public function report()
	{
		$this->display();
	}
	
	/*
		构建报表所需要的全部数据
	*/
	public function generate_report_data()
	{
		// 1. 存储柜概述        
        $db_cabs = M('Cab');
        $fields = array(
            'sn' => 'cab_id', 
            'level_cnt', 
            'group_cnt', 
            'disk_cnt',
            'charge' => 'electricity',
            'voltage',
            'electricity' => 'current');
        $items_cabs = $db_cabs->field($fields)->select();

        $db_device = M('Device');
        $fields = array(
            "level",
            "zu"=>"group",
            "disk",
            "disk_id",
            "normal"
            );
        foreach ($items_cabs as $key => $value) {
            $items_cabs[$key]['disks'] = $db_device->field($fields)->where(array(
				'cab_id'=>$value['cab_id'],
				'loaded'=>'1'
				))->select();
        }

        $this->AjaxReturn($items_cabs);
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
        $item['finished'] = 1;
        $db->save($item);
    }

    public function userLog()
    {
        $id = I("get.userid");
        $db = M('User');
        $map['id'] = $id;
        $item = $db->where($map)->find();
        if (!$item) {
            echo 'invalid userid';
            die();
        }

        //var_dump($item); die();
        $this->assign('user_id', $id);
        $this->assign('user_name', $item['username']);

        //var_dump(I("get.userid")); die();
        $this->display('user-log');
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
        $device_db = M('Device');
        $items = $db->where('loaded=1')->select();
        foreach ($items as $idx => $item) {
            //检查异常磁盘的数量
            $prb_disks = $device_db->where('normal=0 and cab_id=%d', $item['id'])->select();
            $items[$idx]['bad_dsk_cnt'] = count($prb_disks);
        }
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
        $sql5 = "alter table gui_cab auto_increment=1";
        $sql6 = "alter table gui_chg_log auto_increment=1";
        $result = mysqli_query($conn, $sql1);
        $result = mysqli_query($conn, $sql2);
        $result = mysqli_query($conn, $sql3);
        mysqli_query($conn, $sql5);
        mysqli_query($conn, $sql4);
        mysqli_query($conn, $sql6);
        mysqli_close($conn);
    }

    public static function grante_key()
    {
        $encrypt_key = md5(((float)date("YmdHis") + rand(100, 999)) . rand(1000, 9999));
        return $encrypt_key;
    }

    /****
     * 系统初始化函数
     */
    public function SystemInit()
    {
        $this->checkPermission();
        //安装时所有信息重新初始化
        if (I('get.install', 0, 'intval') == 1) {
            $db = M('Device');
            $db->where('1')->delete();
            $newDb = M('Disk');
            $newDb->where('1')->delete();
            $newDb = M('DiskSmart');
            $newDb->where('1')->delete();
            $newDb = M('CmdLog');
            $newDb->where('1')->delete();
            $newDb = M('Cab');
            $newDb->where('1')->delete();
            $newDb = M('ChgLog');
            $newDb->where('1')->delete();
            $newDb = M('DiskChgLog');
            $newDb->where('1')->delete();
            $this->originSql();
        }
        $this->display('deploy');
        die();
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
        $data['sub_cmd'] || $data['sub_cmd'] = "START";
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

    /****
     * 自检参数配置
     */
    public function AutoCheckConf(){
        if(!IS_POST){
            $this->error('您无权访问本页面',U('Index'));
            die();
        }
        $db = M("Config");
        //将当前配置取消
        $map['type'] = array('eq',$_POST['type']);
        $map['is_current'] = array('eq',1);
        $current = $db->where($map)->find();
        if($current){
            $current['is_current'] = 0;
            $db->save($current);
        }
        $data = array(
            'type'=>$_POST['type'],
            'index'=>(int)$_POST['index'],
            'unit'=>(int)$_POST['unit'],
            'time'=>time(),
            'by'=>'user_id',
            'is_current'=>1
        );
        $db->startTrans();
        $rs1 = $db->add($data);
        $plan_db = M('AutoCheckPlan');
        $plan = array(
            'type'=>$data['type'],
            ///'time'=>,
        );
        $rs2 = $plan_db->add($plan);
        $ret['status'] = '1';
        if($rs1 && $rs2){
            $db->commit();
        }
        else{
            //回滚
            $db->rollback();
            $ret['status'] = '0';
        }
        $this->AjaxReturn(json_encode($ret));
    }
    public function getTime(){

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
        if (IS_POST) {
            $rst = array('success' => 1);
            $this->AjaxReturn($rst);
        } else
            $this->success('成功注销', U("login"));
    }

    public function logout_admin()
    {
        session_unset();
        session_destroy();
        if (IS_POST) {
            $rst = array('success' => 1);
            $this->AjaxReturn($rst);
        } else
            $this->success('成功注销', U("login_admin"));
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
