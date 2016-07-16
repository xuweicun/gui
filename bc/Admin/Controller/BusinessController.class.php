<?php
namespace Admin\Controller;
require_once 'PHPWord-master/src/PhpWord/Autoloader.php';
require_once 'workerman-chat-master/GatewayWorker/Lib/Db.php';
//require_once '\PHPWord-master\src\PhpWord\Autoloader.php';
\PhpOffice\PhpWord\Autoloader::register();

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
    public function stopCheck(){
        if(IS_POST){
            $id = (int)$_POST['id'];
            $data = array(
                'id'=>$id,
                'status'=>C('PLAN_STATUS_CANCELED')
                );
            $db = M('CheckPlan');
            $ret = $db->save($data);
            $rst = array('status'=>'0');
            if(!$ret){
                $rst['status'] = '1';
            }
            $this->AjaxReturn($rst);
        }
    }
    public function checkDb(){
        $db =  Db::instance('db1');
        if($db){
            echo "1";
        }
        else echo "0";
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
	public function getCheckStatus(){
        $db = M('CheckPlan');
        $plans = $db->where("status < 2")->select();

        $this->AjaxReturn($plans);
    }
	public function invalid_browser()
	{
		$this->display();
	}

    public function systReset()
    {
		// 回到初始状态
		$db = M();
		$tables = $db->query($sql = 'show tables');				
		foreach($tables as $table_array) {
			foreach ($table_array as $table_item){			
				if ($table_item == 'gui_super' || $table_item == 'gui_user') break;	
				
				$ret = $db->execute($sql = 'TRUNCATE `gui`.`' . $table_item . '`');
				if (!ret) {
					echo $db->getDbError();
				}
			}
		}
		/*
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
		*/
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
			$item = $User->where($cond)->find();
			
			// 用户名不存在
			if (!$item) {				
				$ret['status'] = '-1';
				$this->AjaxReturn($ret);
				return;
			}
			
			// 密码错误超过5次
			if ($item['locked'] >= 5) {			
				$ret['status'] = '-2';
				$this->AjaxReturn($ret);
				return;				
			}

			// 密码错误
            if ($item['password'] != $_POST['password']) {	
				// 错误计数+1
                $item['locked'] = $item['locked'] + 1;
                $User->save($item);
				
                $ret['status'] = '-3';
                $ret['locked'] = $item['locked'];
            } else {
                $item['last_login_time'] = time();
                $user_IP = ($_SERVER["HTTP_VIA"]) ? $_SERVER["HTTP_X_FORWARDED_FOR"] : $_SERVER["REMOTE_ADDR"];
                $user_IP = ($user_IP) ? $user_IP : $_SERVER["REMOTE_ADDR"];
                $item['last_login_ip'] = $_SERVER["REMOTE_ADDR"];
                $item['locked'] = 0;
                $User->save($item);

                session('user', $item['username']);
                session('userid', $item['id']);
                session('can_write', $item['write']);
                $token = self::grante_key();
                session('token', $token);

                $ret['status'] = '1';
            }
            $this->AjaxReturn($ret);
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
            $cond['name'] = $_POST['username'];
			if ($cond['name'] != 'useradmin' && $cond['name'] != 'logadmin') {
				return;
			}
			
            $item = $User->where($cond)->find();
            if (!$item) {
                $cond['pwd'] = md5('nay67kaf');
                $User->add($cond);
            }
			
            $item = $User->where($cond)->find();
			if (!$item) {
				$ret['status'] = -100;
				$this->AjaxReturn($ret);
				return;				
			}
			
			// 密码错误超过5次
			if ($item['locked'] >= 5) {		
                $ret['status'] = '-3';
				$this->AjaxReturn($ret);
				return;				
			}

			// 密码错误
            if ($item['pwd'] != $_POST['password']) {	
				// 错误计数+1
                $item['locked'] = $item['locked'] + 1;
                $User->save($item);
				
                $ret['status'] = '-3';
                $ret['locked'] = $item['locked'];
			}
			else{
				$item['locked'] = 0;
                $User->save($item);
				
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
	public function user_unlock()
	{
		$db = M('User');
		
		$item = $db->find($_POST['id']);
		if (!item) {
			$this->AjaxReturn(array('status'=>'failure'));
			die();
		}
		
		$item['locked'] = 0;
		$db->save($item);
		
		$this->AjaxReturn(array('status'=>'success'));
	}

    public function loginSuccessPage()
    {
        $this->success('成功登录', U('index'));
    }

    public function super_user_main()
    {
        if (!session('?admin')) {
            U('login');
            $this->redirect('login');
        } else {
			$this->assign('username', session('admin'));
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
        $data = array(cmd => 'DEVICESTATUS',
            'CMD_ID' => '0',
            'device_id' => '1'
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

    /*
        构建报表所需要的全部数据
    */
    public function generate_report_data()
    {
		if (session('admin') != 'logadmin') {
			die();
		}
		
        // 1. 存储柜概述
        $db_cabs = M('Cab');
        $fields = array(
			'id',
            'sn' => 'cab_id',
			'name' => 'cab_name',
            'level_cnt',
            'group_cnt',
            'disk_cnt',
            'charge' => 'electricity',
            'voltage',
            'electricity' => 'current');
        $items_cabs = $db_cabs->field($fields)->where(array('loaded'=>1))->order('sn asc')->select();

		// 2. 各在位硬盘
        $db_device = M('Device');
        $fields = array(
            'level',
            'zu' => 'group',
            'disk',
            'gui_device.disk_id' => 'disk_id',
            'gui_device.normal' => 'normal',
            'sn',
            'sn_time',
            'capacity',
            'gui_disk.md5' => 'md5_curr',
            'gui_disk.md5_time' => 'md5_curr_time'
        );

		$db_disk_md5_log = M('DiskMd5Log');
		$db_disk_smart_log = M('DiskSmartLog');
        foreach ($items_cabs as $key => $value) {
			// 找出所有的硬盘
            $items_cabs[$key]['disks'] = $db_device->field($fields)
                ->join('left join gui_disk on gui_device.disk_id = gui_disk.id')
                ->where(array(
					'cabinet_id'=>$value['id'],
                    'loaded' => '1'
                ))->order('level, zu, disk asc')->select();

            $ab_cnt = 0;
            foreach ($items_cabs[$key]['disks'] as $key_1 => $value) {
				// 首次md5
				$item_md5_first = $db_disk_md5_log->field(array('md5_value', 'md5_time'))
				->where(array('disk_id'=>$value['disk_id'], 'status'=>1))
				->order('time asc')->find();
				if (!$item_md5_first) continue;
				
				$items_cabs[$key]['disks'][$key_1]['md5_first'] = $item_md5_first['md5_value'];
				$items_cabs[$key]['disks'][$key_1]['md5_first_time'] = $item_md5_first['md5_time'];
				
				// 上次md5
				$items_md5_last = $db_disk_md5_log->field(array('md5_value', 'md5_time'))
				->where(array('disk_id'=>$value['disk_id'], 'status'=>1))
				->order('time desc')->limit(2)->select();				
								
				$index = count($items_md5_last) == 2?1:0;				
				$items_cabs[$key]['disks'][$key_1]['md5_last'] = $items_md5_last[$index]['md5_value'];
				$items_cabs[$key]['disks'][$key_1]['md5_last_time'] = $items_md5_last[$index]['md5_time'];		
				
                if ($value['normal'] != '1') {
                    $ab_cnt++;
                }
            }

            $items_cabs[$key]['abnormal_cnt'] = "$ab_cnt";
        }
		
		// 3. 各盘位
		foreach ($items_cabs as $key => $value) {
			$slots = array();
			
			// 历史md5
			$items = $db_disk_md5_log->where(array('cabinet_id'=>$value['id'], 'status'=>1))->select();
			foreach ($items as $item_value) {
				$slot_name = $item_value['level'] . '-' . $item_value['zu'] . '-' . $item_value['disk'];
				
				if (!$slots[$slot_name]){
					$slots[$slot_name]['name'] = $slot_name;
					$slots[$slot_name]['md5'] = array();
					$slots[$slot_name]['smart'] = array();		
				}
				
				array_push($slots[$slot_name]['md5'], $item_value);
			}
			
			// 历史Smart
			$items = $db_disk_smart_log->where(array('cabinet_id'=>$value['id'], 'status'=>1))->select();
			//var_dump($items); die();
			foreach ($items as $item_value) {
				$slot_name = $item_value['level'] . '-' . $item_value['zu'] . '-' . $item_value['disk'];
				
				if (!$slots[$slot_name]){
					$slots[$slot_name]['name'] = $slot_name;
					$slots[$slot_name]['md5'] = array();
					$slots[$slot_name]['smart'] = array();	
				}
				
				array_push($slots[$slot_name]['smart'], $item_value);
			}
			
			asort($slots);
			
			$items_cabs[$key]['slots'] = array();
			foreach ($slots as $slot) {
				array_push($items_cabs[$key]['slots'], $slot);
				//var_dump($items_cabs[$key]['slots']); die();
			}
		}
		
		$this->makeWordReport($items_cabs);

        $this->AjaxReturn($items_cabs);
    }
	
	private function makeWordReport($cabinets)
	{
		$styleTable = array('borderSize' => 6, 'borderColor' => '006699', 'cellMargin' => 80);
		$styleFirstRow = array();// array('borderBottomSize' => 18, 'borderBottomColor' => '0000FF', 'bgColor' => '66BBFF');
		$fontStyle = array('bold' => true, 'align' => 'center');
		$paraStyle = array('indention'=>'1', 'lineHeight'=>1.5);
		
		// Creating the new document...
		$phpWord = new \PhpOffice\PhpWord\PhpWord();
		$phpWord->addTableStyle('Fancy Table', $styleTable, $styleFirstRow);
		
		$section = $phpWord->addSection(array('orientation'=>'landscape'));
		$phpWord->setDefaultFontName('Times New Roman');
		$phpWord->setDefaultFontSize(12);
		
		// 柜子数
		$cab_cnt = count($cabinets);
		
		// 日期
		$today = date('Y年m月d日');
		
		$phpWord->addTitleStyle(1, array('bold' => true, 'size' => 16), array('spaceAfter' => 240, 'spaceBefore'=>400));
		$phpWord->addTitleStyle(2, array('bold' => true, 'size' => 14), array('spaceAfter' => 240, 'spaceBefore'=>400));
		$phpWord->addTitleStyle(3, array('bold' => true, 'size' => 12), array('spaceAfter' => 240, 'spaceBefore'=>400));
		$section->addTitle('1. 概述', 1);
		
		$text_head = "服务器曾经连接过 $cab_cnt 台存储柜。";			
		$section->addText($text_head, array(), $paraStyle);
		
		if (count($cabinets) > 0) {
			$section->addTitle('2. 数据存储柜基本信息', 1);
		}
		
		foreach ($cabinets as $idx=>$cab) {
			$section->addTitle('2.' . ($idx+1) . '. 数据存储柜 ' . $cab['cab_id']. '#', 2);
			
			$table_cab = $section->addTable('Fancy Table', null, array('align' => 'center', 'spaceAfter' => 100));
			$table_cab->addRow();
			$table_cab->addCell(2000)->addText('数据存储柜ID', $fontStyle);
			$table_cab->addCell(3000)->addText($cab['cab_id'], $fontStyle);
			$table_cab->addRow();
			$table_cab->addCell(2000)->addText('编号', $fontStyle);
			$table_cab->addCell(3000)->addText($cab['cab_name'], $fontStyle);
			$table_cab->addRow();
			$table_cab->addCell(2000)->addText('硬盘插槽', $fontStyle);
			$table_cab->addCell(4000)->addText($cab['level_cnt'] . '层×'. $cab['group_cnt'] .'组×'. $cab['disk_cnt'] .'位', $fontStyle);
			$table_cab->addRow();
			$table_cab->addCell(2000)->addText('当前硬盘', $fontStyle);
			$disk_cnt = count($cab['disks']);
			$disk_ab_cnt = $cab['abnormal_cnt'];
			$table_cab->addCell(4000)->addText("共 $disk_cnt 块，其中异常 $disk_ab_cnt 块", $fontStyle);
			
			$section->addText('数据存储柜 '.$cab['cab_id'].'# 在位硬盘健康状况报表 - '.$today, array('bold'=>true), array('align' => 'center', 'spaceAfter' => 100, 'spaceBefore'=>400));
			$table_cab_diks = $section->addTable('Fancy Table');
			{
				//序号 	物理位置 	SN号 	容量 	健康状态 	健康状态检测时间 	首次MD5时间 	首次MD5值 	上次MD5时间 	上次MD5值 	最近MD5时间 	最近MD5值 	备注
				$table_cab_diks->addRow();
				$table_cab_diks->addCell(1000)->addText('序号', array('size'=>9));	
				$table_cab_diks->addCell(1000)->addText('物理位置', array('size'=>9));
				$table_cab_diks->addCell(1000)->addText('SN号', array('size'=>9));	
				$table_cab_diks->addCell(1000)->addText('容量', array('size'=>9));		
				$table_cab_diks->addCell(2000)->addText('健康状态', array('size'=>9));		
				$table_cab_diks->addCell(1000)->addText('健康状态检测时间', array('size'=>9));		
				$table_cab_diks->addCell(1000)->addText('首次MD5值', array('size'=>9));		
				$table_cab_diks->addCell(1000)->addText('首次MD5时间', array('size'=>9));		
				$table_cab_diks->addCell(1000)->addText('上次MD5值', array('size'=>9));		
				$table_cab_diks->addCell(1000)->addText('上次MD5时间', array('size'=>9));		
				$table_cab_diks->addCell(1000)->addText('最近MD5值', array('size'=>9));		
				$table_cab_diks->addCell(1000)->addText('最近MD5时间', array('size'=>9));		
				$table_cab_diks->addCell()->addText('备注', array('size'=>9));					
			}
			foreach ($cab['disks'] as $dsk_idx=>$dsk) {
				$table_cab_diks->addRow();
				$table_cab_diks->addCell()->addText($dsk_idx + 1, array('size'=>9));	
				$table_cab_diks->addCell()->addText($dsk['level'].'-'.$dsk['group'].'-'.$dsk['disk'], array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['sn'], array('size'=>9));
				$table_cab_diks->addCell()->addText($dsk['capacity']?$dsk['capacity'] . 'GB':'', array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['sn']?($dsk['normal']==1?'健康':'异常'):'', array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['sn_time']?date("Y-m-d H:i:s", $dsk['sn_time']):'-', array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['md5_first'], array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['md5_first_time']?date("Y-m-d H:i:s", $dsk['md5_first_time']):'-', array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['md5_last'], array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['md5_last_time']?date("Y-m-d H:i:s", $dsk['md5_last_time']):'-', array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['md5_curr'], array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['md5_curr_time']?date("Y-m-d H:i:s", $dsk['md5_curr_time']):'-', array('size'=>9));		
				$table_cab_diks->addCell()->addText($dsk['md5_last']!=$dsk['md5_curr']?'异常：MD5变化':'', array('size'=>9));
			}
			
			foreach ($cab['slots'] as $idx_slt=>$slt) {
				$section->addTitle('2.' . ($idx+1) . '.' . ($idx_slt+1) .'. 盘位' . $cab['cab_id'] .'-'.$slt['name'], 3);
				$slt_title = '盘位'.$cab['cab_id'].'-'.$slt['name'].'健康状况报表';				
				$section->addText($slt_title.'（MD5） — '.$today, array('bold'=>true), array('align' => 'center', 'spaceAfter' => 100, 'spaceBefore'=>400));
				{
					$table_cab_slt_md5 = $section->addTable('Fancy Table');
					// 序号 	sn 	MD5检测时间 	MD5检测值 	备注
					$table_cab_slt_md5->addRow();
					$table_cab_slt_md5->addCell(1000)->addText('序号');
					$table_cab_slt_md5->addCell(3000)->addText('SN号');
					$table_cab_slt_md5->addCell(3000)->addText('MD5时间');
					$table_cab_slt_md5->addCell(4000)->addText('MD5检测值');
					$table_cab_slt_md5->addCell(3000)->addText('备注');
					
					foreach ($slt['md5'] as $md5_idx=>$md5) {
						$table_cab_slt_md5->addRow();
						$table_cab_slt_md5->addCell()->addText($md5_idx + 1);
						$table_cab_slt_md5->addCell()->addText($md5['sn']);
						$table_cab_slt_md5->addCell()->addText(date('Y-m-d H:i:s', $md5['md5_time']));
						$table_cab_slt_md5->addCell()->addText($md5['md5_value']);
						$table_cab_slt_md5->addCell()->addText();							
					}
				}
				
				$section->addText($slt_title.'（Smart） — '.$today, array('bold'=>true), array('align' => 'center', 'spaceAfter' => 100, 'spaceBefore'=>400));
				{
					$table_cab_slt_smart = $section->addTable('Fancy Table');
					// 序号 	SN号 	SN号检测时间 	备注
					$table_cab_slt_smart->addRow();
					$table_cab_slt_smart->addCell(1000)->addText('序号');
					$table_cab_slt_smart->addCell(3000)->addText('SN号');
					$table_cab_slt_smart->addCell(3000)->addText('SN号检测时间');
					$table_cab_slt_smart->addCell(3000)->addText('容量');
					$table_cab_slt_smart->addCell(2000)->addText('健康状态');
					$table_cab_slt_smart->addCell(5000)->addText('备注');
					
					foreach ($slt['smart'] as $smart_idx=>$smart) {
						$table_cab_slt_smart->addRow();
						$table_cab_slt_smart->addCell()->addText($smart_idx + 1);
						$table_cab_slt_smart->addCell()->addText($smart['sn']);
						$table_cab_slt_smart->addCell()->addText(date('Y-m-d H:i:s', $smart['time']));
						$table_cab_slt_smart->addCell()->addText($smart['capacity']);
						$table_cab_slt_smart->addCell()->addText($smart['disk_status']==0?'健康':'异常');
						$table_cab_slt_smart->addCell()->addText();							
					}
				}
			}
		}			
		
		$objWriter = \PhpOffice\PhpWord\IOFactory::createWriter($phpWord, 'Word2007');
		if (!is_dir('reports')){
			mkdir('reports');
		}
		$objWriter->save('reports/report.docx');
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
        $items = $db->where('loaded=1')->order('sn asc')->select();
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
		$cabinet = M('Cab')->where(array('sn'=>I('get.cab')))->find();
		if (!$cabinet) return;
		
        $db = M('Device');
        $viewDb = D('DeviceView');
        $map['cabinet_id'] = array('eq', $cabinet['id']);
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
        die();
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
    public function clearSystRunLog(){
        $db = M('SystemRunLog');
        $db->where("1")->delete();
    }
    public function showSystRunLog(){
           echo "当前时间:".date("Y-m-d H:m:s",time())."<br/>";
           echo "正在获取日志..<br/>";
           $db = M('SystemRunLog');
            $logs = $db->select();
            foreach ($logs as $log){
                echo $log['type']."-".$log['msg']."-".date("Y-m-d H:i:s A",(int)$log['time']);
                echo "<br/>";
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
    public function AutoCheckConf()
    {
        if (!IS_POST) {
            $this->error('您无权访问本页面', U('Index'));
            die();
        }
        $db = M("CheckConf");
        //将当前配置取消
        $map['type'] = array('eq', $_POST['type']);
        $map['is_current'] = array('eq', 1);
        $current = $db->where($map)->find();
        if ($current) {
            $current['is_current'] = 0;
            $db->save($current);
        }
        $data = array(
            'type' => $_POST['type'],
            'cnt' => (int)$_POST['cnt'],
            'unit' => $_POST['unit'],
            'start_date' => strtotime($_POST['start_date']),
            'hour'=>$_POST['start_time'],
            'time' => time(),
            'user_id' => $_POST['user_id'],
            'is_current' => 1

        );
        $db->startTrans();
        $rs1 = $db->add($data);
        $plan_db = M('CheckPlan');
        $plan_db->startTrans();
        //取消还未开始的计划,改为当前计划
        $plan = array(
            'start_time'=> strtotime($_POST['start_date']) + (int)$_POST['start_time']*3600,
            'type'=>$data['type'],
            'status'=>C('PLAN_STATUS_WAITING'),
            'modify_time'=>time()//新增时间
        );//$this->getPlan($data, $_POST['start_date']);
        $map = array();
        $map['type'] = array('eq', $_POST['type']);
        $map['status'] = array('eq', C('PLAN_STATUS_WAITING'));
        //应该只有一个计划未开始,否则是bug
        $old_plans = $plan_db->where($map)->select();

        $rs2 = $plan_db->add($plan);
        $rs3 = true;
        if($old_plans){
            foreach ($old_plans as $old_plan) {
                $old_plan['status'] = C('PLAN_STATUS_CANCELED');
                $old_plan['modify_time'] = time();
                $rs = $plan_db->save($old_plan);
                if(!$rs)
                {
                    $rs3 = false;
                }
            }
        }
        $ret['status'] = '0';
        if ($rs1 && $rs2 && $rs3) {
            $db->commit();
           // $plan_db->commit();
        } else {
            //回滚
            $db->rollback();
            $plan_db->rollback();
            $ret['status'] = '1';

        }
        $this->AjaxReturn(json_encode($ret));
    }

    public function getPlan($config, $start_date)
    {
        //根据配置信息获取时间
        //Unit是天时
        $plan_t = null;

        switch($config['unit']){
            case 'day':
                $start_t = strtotime($start_date);
                $plan_t = $start_t + $config['cnt']*24*3600 + $config['start_time']*3600;//开始日期加天数加起始时间
                break;
            case 'week':
                $start_t = strtotime($start_date);
                $plan_t = $start_t + $config['cnt']*24*3600 + $config['start_time']*3600;//开始日期加天数加起始时间
            break;
            case 'month':
                //获取月份
                $date_param = explode('-',$start_date);
                $yr  = (int)$date_param[0] + floor(((int)$date_param[1]+$config['cnt'])/12);
                $mth = ((int)$date_param[1] + $config['cnt'])%12;
                if($mth == 0){
                    $mth = 12;
                }
                $day_cnt = self::getDaysPerMonth($yr,$mth);
                $day = (int)$date_param[2] <=  $day_cnt? (int)$date_param[2] : $day_cnt;
                $plan_t = strtotime($yr."-".$mth."-".$day);
                break;
            case 'season':
                $date_param = explode('-',$start_date);
                $yr  = (int)$date_param[0] + floor(((int)$date_param[1]+$config['cnt'] * 3)/12);
                $mth = ((int)$date_param[1] + $config['cnt']*3)%12;
                if($mth == 0){
                    $mth = 12;
                }
                $day_cnt = self::getDaysPerMonth($yr,$mth);
                $day = (int)$date_param[2] <=  $day_cnt? (int)$date_param[2] : $day_cnt;
                $plan_t = strtotime($yr."-".$mth."-".$day);

        }
        //生成计划
        $plan = array(
            'modify_time'=>time(),
            'start_time'=>$plan_t,
            'status'=>-1
        );
        return $plan;
    }
    public function test()
    {
        echo 13%12;
    }
    public function getDaysPerMonth($y,$m)
    {
        if($m >= 12){
            return 30;
        }
        $next_mth = $m+1;
        $t = (strtotime("1-".$next_mth."-".$y) - strtotime("1-".$m."-".$y));
        $days = $t / (60 * 60 * 24);
        echo $days;
        return $days;
    }

    public function getCheckConfig()
    {
        $db = M('CheckConf');
        $conf = $db->where('is_current=1')->select();
        $this->AjaxReturn($conf);
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
	
	public function logout_immediate()
	{
		session('user', null);
		
		$this->redirect('login');
	}

    public function logout()
    {
		session('user', null);
		
        if (IS_POST) {
            $rst = array('success' => 1);
            $this->AjaxReturn($rst);
        } else
            $this->success('成功注销', U("login"));
    }

    public function logout_admin()
    {
		session('admin', null);
		
        if (IS_POST) {
            $rst = array('success' => 1);
            $this->AjaxReturn($rst);
        } else
            $this->success('成功注销', U("login"));
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
