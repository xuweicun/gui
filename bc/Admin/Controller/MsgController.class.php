<?php
namespace Admin\Controller;
use Think\Controller;
header('Access-Control-Allow-Origin:*'); 

header('Access-Control-Allow-Headers: X-Requested-With,content-type');

class MsgController extends Controller {
	public function index(){
	   //get the json data into the：： _post array
	   $content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
	   if ($content_type_args[0] == 'application/json')
	   {
		   $_POST = json_decode(file_get_contents('php://input'),true);     
	   }
	  
	   if($_POST['errmsg'])
	   {
		   //something wrong;
		   $this->handleError();
		   die();
	   }
	   
	   switch($_POST['cmd'])
	   {
		   case 'DEVICESTATUS':
		   $this->updateDeviceStatus();
		   break;
	   }  	   
	}
	/***
	* 获取硬盘在位信息返回数据处理函数
	* @作者 Wilson Xu
	*/
	public function updateDeviceStatus()
	{
	   //在位信息以后改为用Redis维护
	   if($_POST['status'] == 0)
	   {
		   $db = M('Device');
		   $levels = $_POST['levels'];
		   $map['loaded'] = array('eq',1);
		   //找出所有之前在位的硬盘；
		   $items = $db->where($map)->select();
		   //更新在位信息；
		   foreach($items as $item)
		   {
			   $item['loaded'] = 0;
			   $db->save($item);
		   }
		   foreach($levels as $level)
		   {
			   $level_id = $level['id'];
			   $groups = $level['groups'];
			   foreach($groups as $group)
			   {
				   $group_id = $group['id'];
				   $disks = $group['disks'];
				   foreach($disks as $disk)
				   {
					   $map['level'] = array('eq',$level_id);
					   $map['group'] = array('eq',$group_id);
					   $map['index'] = array('eq',$disk);
					   if($item = $db->where($map)->find())
					   {
						   $item['loaded'] = 1;
						   $db->save($item);
					   }
					   else
					   {
						   $item['loaded'] = 1;
						   $db->add($item);
					   }
					   
				   }
			   }
		   }
	   }
	   else
	   {
		   $this->handleError();//统一处理
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
		//find the commond record by cmd, subcmd, which has been inserteed
		//before the commond sent to the proxy;
		
		//update the finish-time, and the status
		//done
	}
	
	
	
}
