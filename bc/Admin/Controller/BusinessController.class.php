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
		$this->display();
	}
	
	public function getDiskInfo()
	{
		 //initiate database   --generate model
		$db = M('Device');
		$rooms = $db->select();
		$returnData = array();
		foreach($rooms as $item)
		{
			//add all the in-position disks into the return data array
			if($item['loaded'] == 1)
			{
				//硬盘在位
				$returnData[] = $item;
			} 
			
		}
		$this->AjaxReturn($returnData);
		
	}
	/***
	* to check if or not the same commond has been sent
	* @author: wilsonxu
	* @input:  cmd, subcmd
	*/
	public function checkCollison()
	{
		$db = M('CmdLog');
		$cmd = I('post.cmd');
		$subcmd = I('post.subcmd');
		$status = -1;//-1 represents that the commond is not finished yet.
		$map['cmd'] = array('like',$cmd);
		$map['subcmd'] = array('like',$subcmd);
		$map['status'] = array('equal',$status);
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
		$data['cmd'] = I('post.cmd');
		$data['subcmd'] = I('post.subcmd');
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