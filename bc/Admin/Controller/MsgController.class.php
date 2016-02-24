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
	   $cmd = I('post.CMD');
	   
	}
	public function devicestatus()
	{
		
	}
}