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
           case 'DISKINFO':
           $this->updateDiskInfo();
           break;
           case 'BRIDGE':
               $this->bridgeMsgHandle();
               break;
	   }  	   
	}
    public function bridgeMsgHandle()
    {


        $level = (int)$_POST['level'];
        $group = (int)$_POST['group'];
        $disks = $_POST['disks'];
        $path = $_POST['paths'];
        $filedir = "/home/share/mount/" . $path['value'];
        $deviceDb = M('Device');
        foreach($disks as $disk) {
            $item = $deviceDb->where("level = $level and zu = $group and disk={$disk['id']}")->select();
            $diskDb = M('Disk');
            $theDisk = $diskDb->find($item['disk_id']);
            $theDisk['file_list'] = $filedir;
            $diskDb->save($theDisk);
        }
        $this->updateCmdLog();


    }
	/***
	* 获取硬盘在位信息返回数据处理函数
	* @作者 Wilson Xu
	*/
	public function updateDeviceStatus()
	{
           //将命令状态设为已完成;


           
	   //在位信息以后改为用Redis维护
	   if($_POST['status'] == '0')
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
               $item['time']=time();
               $db->save($item);
		   }
                   $testDb = M('test');
                   
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
                       $data['response'] = "$level_id-$group_id-$disk";
					   $map['level'] = array('eq',$level_id);
					   $map['zu'] = array('eq',$group_id);
					   $map['disk'] = array('eq',$disk);
                       $item = $db->where("level=$level_id and zu=$group_id and disk=$disk")->find();
					   if($item)
					   {
						   $item['loaded'] = 1;
						   $item['time'] = time();
						   $db->save($item);
                           $data['response'] =$data['response']."-added";
                       }
                       else
                       {$data['response'] =$data['response']."-fail";}
                        $testDb->add($data);
				   }
			   }
		   }
	   }
       $this->updateCmdLog();
        if($_POST['status'] != '0')
	   {
		   $this->handleError();//统一处理
	   } 
	}

    public function updateDiskInfo()
    {
        //暂时不维护此命令状态，太麻烦;
        //后期修改cmdlog，增加diskinfo一项，记录操作对象。
        
       //在位信息以后改为用Redis维护
       if($_POST['status'] == 0)
       {  
           //查看是否对应盘位绑定了硬盘
           //若未绑定
           $level = $_POST['level'];
           $group = $_POST['group'];
           $disk  = $_POST['disk'];
           $map = "level=$level and zu=$group and disk=$disk";
           $db = M('Device');          
           $diskDb = M('Disk');
           $item = $db->where($map)->find();
           $data['sn'] = $_POST['SN'];
           $data['smart'] = 0;
           $data['capacity'] = $_POST['capacity']; 
           $data['time']  = time();
           if(!$item['disk_id']||is_null($item['disk_id']))
           {                
               $item['disk_id'] = $diskDb->add($data);
               $db->save($item);  
               $this->updateSmart($item['disk_id']);
               
           }
           else
           {
               $data['id'] = $item['disk_id'];
               
               $diskDb->save($data);
               $this->updateSmart($item['disk_id']);
           }
       }
    }
    /******
    * 更新Smart值
    * @input: disk_id, $_POST
    */
    private function updateSmart($id)
    {
        $db    = M('DiskSmart');
        $attrs = $_POST['SmartAttrs'];
        $testDb = M('test');
        $test['response'] = count($attrs);
        $testDb->add($test);
        foreach($attrs as $attr)
        {
            //查找是否存在
            $attr = $attr;

            $map = "disk_id=$id and attrname={$attr['Attribute_ID']}";
            if($item=$db->where($map)->find())
            {
                $item['value'] = $attr['Current_value'];
                $db->save($item);
            }
            else
            {
                $item['value'] = $attr['Current_value'];
                $item['attrname'] = $attr['Attribute_ID'];
                $item['disk_id'] = $id;
                $db->add($item);
            }
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
        $cmdDb = M('CmdLog');
        $cmdId = (int)$_POST['CMD_ID'];
        $cmd = $cmdDb->find($cmdId);
        $cmd['status'] = (int)$_POST['status'];
        $cmdDb->save($cmd);
	}
	
	
	
}
