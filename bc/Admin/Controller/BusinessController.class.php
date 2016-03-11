<?php
namespace Admin\Controller;
use Think\Controller;
header('Access-Control-Allow-Origin:*'); 
class BusinessController extends Controller {
	/*********
	* @index
	* @todo: 查询柜子和磁盘的状态信息，生成主页
	* @author: wilson xu
	*/
	public function index(){   
		//check permission --to delay        
		
		//initiate database   --generate model
		
		
		//generate the page 
		$this->display("index");

	}

	

	public function temp()
	{

		   $this->display("index2");
		
	}
	public function search(){
		$this->display("search");
	
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
		while($item = $cmdDb->where($map)->find() && $exctTime < $maxTime)
		{
			sleep(1);
			$exctTime = $exctTime + 1;
		}
	}
	public function getDeviceInfo()
	{
		 //initiate database   --generate model
		$db = M('Device');
		$rooms = $db->select();
		$returnData = array();
		$type = I('get.type',0,'intval');
		if($type == 1)
		{
			//待改进：以后应将运行中的命令单独放一个表，成功或失败后放到log表中。
			$maxTime = 10;
			$cmd = "DEVICESTATUS";	
			$this->waitTilDone($cmd,$maxTime);		
		}
		foreach($rooms as $item)
		{
			//返回所有不在位的硬盘信息；
			if($item['loaded'] == 0)
			{
				//硬盘在位
				$returnData[] = $item;
			} 
			
		}
		$this->AjaxReturn($returnData);
		
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
	* to check if or not the same commond has been sent
	* @author: wilsonxu
	* @input:  cmd, subcmd
	*/
	public function checkCollision()
	{
		$db = M('CmdLog');
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
			$data['isLegal'] = 0;
			$this->AjaxReturn($data);
		}
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
		$data['cmd'] = $_POST['cmd'];
		$data['subcmd'] = $_POST['subcmd'];
		$data['status'] = -1;//-1 represents that the commond is not finished yet.
		$id = $db->add($data);
		if($id)
		{
			//insert related disk rooms
			
		}
		else
		{
			//throw an exception
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
	
	public function pick_disk(){   
		//check permission
		//query database
		//return 
	}
	public function login(){   
		//check permission
		//query database
		//return 
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
