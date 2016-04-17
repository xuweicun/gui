<?php
namespace Admin\Controller;
use Think\Controller;
header('Access-Control-Allow-Origin:*'); 
header('Access-Control-Allow-Headers: X-Requested-With,content-type');
$content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
if ($content_type_args[0] == 'application/json') {
	$_POST = json_decode(file_get_contents('php://input'),true);     
}

class BusinessController extends Controller {
	/*********
	* @index
	* @todo: 查询柜子和磁盘的状态信息，生成主页
	* @author: wilson xu
	*/
	public function index(){   
		//check permission --to delay        
		
		//initiate database   --generate model
		if(!session('?user'))  {
			U('login');
			$this->redirect('login');

		}
		else{
			$Username = session('user');
			$this->assign('username',$Username);
			//generate the page
			$this->display();
		}
	}
	public function deleteCmd(){
		$db = M('CmdLog');
		$id = I('get.id',0,'intval');
		if($db->find($id))
		{
			$map['id'] = array('eq',$id);
			$db->where($map)->delete();
		}
		else{
			$this->notFoundError('Cmd not found');
		}
	}
	public function insertUser(){
		if(IS_POST){
		}
		else{
			$user = I('get.user');
			$pwd = I('get.pwd');
			$db = M('Super');
			$data['name'] = $user;
			$data['pwd'] = md5($pwd);
			if($db->where("name='$user'")->find())
			{
				$this->error('用户名重复',U('login'));
				return;
			}
			if($db->add($data))
			{
				$this->success("增加成功",U('login'));
			}
			else{
				$this->error('插入失败',U('login'));
			}
		}
	}
	public function login(){
		if(session('?user')){
			$this->redirect('index');
			die();
		}
		if(IS_POST)
		{
			$User = M('super');
			$uname = I('post.uname');
			$cond['name'] = array('eq',$uname);
			$cond['pwd'] = array('eq',md5(I('post.pwd')));

			if(is_null($User->where($cond)->select())){
				$this->error('登录失败');                     ;
			}
			else{
				session('user', $uname);
				$this->success('成功登录', U('index'));
			}
		}
		else{
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
	public function search(){
		$this->display("search");
	
	}

	/**
	 * 获取正在进行的任务清单
	 *
	 */
	public function getGoingTasks(){
		$db = M('CmdLog');
		$items = $db->where("status = -1")->select();
		foreach($items as $index=>$item)
		{
			$items[$index]['msg'] = stripslashes($item['msg']);
		}
		$this->AjaxReturn($items);
	}
	public function getTestResults()
	{
		$db = M('Test');
		$items = $db->select();
		foreach($items as $item)
		{
			var_dump($item);

			echo "<br/>";
		}
	}

	public function waitTilDone($cmd,$maxTime)
	{            
		$exctTime = 0;        
		$cmdDb = M('CmdLog');
		$status = -1;//未完成
		$map['cmd'] = array('eq',$cmd);
		$map['status'] = array('eq',$status);
		while($exctTime < $maxTime)
		{
			sleep(1);
			$exctTime = $exctTime + 1;
		}
	}
	public function setTimeOut()
	{
		$db = M('CmdLog');
		$map['id'] = array('eq',I('get.id'));
		$item = $db->where($map)->find();
		$item['status'] = C('CMD_TIMEOUT');
		$db->save($item);
	}
    public function getBridgeStatus()
	{
		$cmd = 'BRIDGE';
		$subcmd = 'START';
		$db = M('CmdLog');
        $map['cmd'] = array('eq',$cmd);

		$item = $db->where($map)->find();
        if($item)
        {
            if($item['status'] == 0)
            {
                $db->where("id={$item['id']}")->delete();
            }
            $this->AjaxReturn($item);
        }
        else
        {
            $this->notFoundError('bridge not found in log');
        }
	}
	public function getDeviceInfo()
	{
		 //initiate database   --generate model
		$db = M('Device');
		$rooms = $db->select();
		$returnData = array();
		foreach($rooms as $item)
		{
			//返回所有不在位的硬盘信息；
			if($item['loaded'] == 1)
			{
				//硬盘在位
				$item['time'] = date("Y-m-d H:i:s",$item['time']);
				$returnData[] = $item;
				
			} 
			
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
		$map['status'] = array('eq',$status);
		$data['isLegal'] = 1;
		if(!$db->where($map)->find())
		{
			$this->AjaxReturn($data);
		}
		else
		{

			$this->AjaxReturn($data);
		}
	}
    public  function  getCmdResult()
    {
        $id = I('get.cmdid');
        $db = M('CmdLog');
        $map['cmd'] = array('eq',$cmd);
        $item = $db->find($id);
        if($item)
        {
            $this->AjaxReturn($item);
        }
        else
        {
            $this->notFoundError("not found this commond in the log");
        }
    }
    public function originSql()
	{
		$conn=mysqli_connect("localhost", "root", "moganfreeman","gui");
		$sql1 = "alter table gui_device auto_increment=1";
		$sql2 = "alter table gui_disk auto_increment=1";
		$sql3 = "alter table gui_disk_smart auto_increment=1";
		$sql4 = "alter table gui_cmd_log auto_increment=1";
		$result=mysqli_query($conn,$sql1);
		$result=mysqli_query($conn,$sql2);
		$result=mysqli_query($conn,$sql3);
		$result=mysqli_query($conn,$sql4);
                mysqli_close($conn);
	}
	/****
	* 系统初始化函数
	*/
	public function SystemInit()
	{
		$level = $_POST['level'];
		if(!$level)
		{
			$errmsg = 'inadequate infomation';
			$this->AjaxReturn($errmsg);
			die();
		}
		$group = $_POST['group'];
		$disk  = $_POST['disk'];
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
		for($i = 1; ; $i++)
		{
			if($i > $level)
			break;
			$data['level'] = $i;
			for($j = 1; ; $j++)
			{
				if($j > $group)
				break;
				$data['zu'] = $j;
				for($k = 1; $k <= $disk; $k++)
				{
					if($k > $disk)
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
        $this->assign("disk",$disk);
        $this->display();
    }
	/***
	* to insert a new commond-request log, driven by javascript
	* @input: cmd, subcmd, 
	*/
	public function AddCmdLog()
	{
		$content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
	   if ($content_type_args[0] == 'application/json')
	   {
		   $_POST = json_decode(file_get_contents('php://input'),true);     
	   }
		$db = M('CmdLog');
		if($_POST['id'])
		{
			//日志更新
			$log = $db->find($_POST['id']);
			$log['msg'] = $_POST['msg'];
			$db->save($log);
			return;
		}
		$data['cmd'] = $_POST['cmd'];
		$data['sub_cmd'] = $_POST['subcmd'];
		$data['status'] = C('CMD_GOING');//-1 represents that the commond is not finished yet.
		$data['start_time'] =  time();
		$id = $db->add($data);

		if($id)
		{
            $data['id'] = $id;
			if($data['cmd'] == 'BRIDGE' && $data['subcmd'] == 'STOP')
		    {
				$level = $_POST['level'];
				$group = $_POST['group'];
				$disks  = $_POST['disks'];
				$map['level'] = array('eq',$level);
				$map['zu'] = array('eq',$group);


				$dDb = M('Device');
				foreach($disks as $disk)
				{
					$map['disk'] = array('eq',$disk['id']);
					$item = $dDb->where($map)->find();
					if($item)
					{
						$item['bridged'] = 0;
						$dDb->save($item);
					}
				}

			}
			$this->AjaxReturn($data);
		}
		else
		{
			//throw an exception
            $this->notFoundError("fail to insert the cmd log");
		}
		
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
		if($levels)
		{			
			foreach($levels as $item)
			{
				$data['level'] = $item;
				$this->handleGroup($data,$db);
			}
		}
		else
		{
			$level = I('post.level');
			if($level)
			{
				$data['level'] = $level;
				$this->handleGroup($data,$db);
			}
			else
			{
				//something wrong
				$data['error'] = "No disk assigned to the commond. Recheck the code.";
				$this->AjaxReturn($data);
				
			}
		}
		
	}
	private function handleGroup($data,$db)
	{
		$groups = I('post.groups');
		if($groups)
		{
			foreach($groups as $group)
			{
				$data['group'] = $group;
				$this->handleDisk($data,$db);

			}


		}
		else
		{

			$group = I('post.group');
			if($group)
			{
				$data['group'] = $group;
				$this->handleDisk($data,$db);
			}
			else
			{
				$db->add($data);
			}

		}
				
	}
	private function handleDisk($data,$db)
	{
		$disks = I('post.disks');
		if($disks)
		{
			foreach($disks as $disk)
			{
				$data['disk'] = $disk; 
				$db->add($data);
			}
		}
		else
		{
			$disk = I('post.disk');
			if($disk)
			{
				$data['disk'] = $disk;
			}
			$db->add($data);
		}
	}
	
	public function getDiskInfo(){   
		//check permission
        $maxTime = $_POST['maxtime'];
        $type = $_POST['type'];
       
        $level = $_POST['level'];
        $group = $_POST['group'];
        $disk  = $_POST['disk'];
        $db = M('Device');
        $map = "level=$level and zu=$group and disk=$disk";
        $item = $db->where($map)->find();
        if($item && $item['loaded'] == 1)
        {
             $id = $item['disk_id'];
             if(!$id)
             {
                 $this->notFoundError('disk info query not finished yet or failed');
             }
             else
             {
                 $diskDb = M('Disk');
                 $diskinfo = $diskDb->find($id);

                 if($diskinfo)
                 {
					 $diskinfo = array_merge($diskinfo,$item);
                     $this->AjaxReturn($diskinfo);
                 }
                 else
                 {
                     $this->notFoundError('invalid disk_id');
                 }
             }
        }
        else
        {
            $this->notFoundError('incorrect disk position or disk not loaded');
        }
        
		//query database
		//return 
	}
    public function init()
    {
        $this->display("systeminit");
    }
    private function notFoundError($appended='')
    {
        $data['errmsg'] = 'item does not exists--'.$appended;
        $this->AjaxReturn($data);
    }

	public function logout(){   
		//check permission
		//query database
		//return 
	}
	public function chg_pwd(){   
		//check permission
		//query database
		//return 
	}
	public function cmd_exe(){   
		//check permission
		//query database
		//return 
	}
	public function disk_info(){   
		//check permission
		//query database
		//return 
	}
	public function cmd_log(){   
		//check permission
		//query database
		//return 
	}
}
