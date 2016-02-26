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
	public function getDeviceSize()
	{
		$size['level'] = 1;
		$this->AjaxReturn($size);
	} 
	public function get_disk_info()
	{
		 //initiate database   --generate model
		$db = M('Device');
		$rooms = $db->select();
		
		foreach($rooms as $item)
		{
			$data['id'] = $item['id'];
			$db->save($data);
		}
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
	public function updateCmdLog()
	{
		
	}
	public function pick_dist(){   
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