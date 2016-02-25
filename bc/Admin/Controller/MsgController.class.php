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
	   
	   $db = M('CmdLog');
	   if($item = $db->where()->find())
	   {
		   $data['status'] = I('post.status',0,'intval');
		   if($data['status'] > 0)
		   {
			   $data['errno'] = I('post.errno',0,'intval');
		   }
		   $data['progress'] = I('post.progress');
		   $data['id'] = $item['id'];
		   $db->save($data);//update value
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