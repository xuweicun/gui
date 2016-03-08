<?php
namespace Admin2\Controller;
use Think\Controller;
class MsgController extends Controller {
	public function index(){
	   //get the json data into the _post array
	   $content_type_args = explode(';', $_SERVER['CONTENT_TYPE']);
	   if ($content_type_args[0] == 'application/json')
	   {
		   $_POST = json_decode(file_get_contents('php://input'),true);     
	   }
	   //lets see what is it?
	   $status = I('post.status');
	   if(!$data['cmd']= I('post.cmd'))
	   {
		   //something wrong;
		   die();
	   }
	   $data['subcmd'] = I('psot.subcmd');
       switch($data['cmd'])
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
       if(I('post.status') == 0 || I('get.test_id') == 1)
       {
           $db = M('Device');
           $levels = I('post.levels');
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
                       
                   }
               }
           }
       }
       else
       {
           $this->handleError("DEVICESTATUS");//统一处理
       } 
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