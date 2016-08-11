<?php
/**
 * This file is part of workerman.
 *
 * Licensed under The MIT License
 * For full copyright and license information, please see the MIT-LICENSE.txt
 * Redistributions of files must retain the above copyright notice.
 *
 * @author walkor<walkor@workerman.net>
 * @copyright walkor<walkor@workerman.net>
 * @link http://www.workerman.net/
 * @license http://www.opensource.org/licenses/mit-license.php MIT License
 */

use \Workerman\Worker;
use \GatewayWorker\Gateway;
use \Workerman\Autoloader;

use \Workerman\Lib\Timer;

use \GatewayWorker\Lib\Db;
use \GatewayWorker\Lib\Gateway as ExtendGateWay;
// 自动加载类
require_once __DIR__ . '/../../Workerman/Autoloader.php';
Autoloader::setRootPath(__DIR__);

// gateway 进程
$md5_checker = new Worker();

// 设置名称，方便status时查看
$md5_checker->name = 'Sprayer';
// 设置进程数，gateway进程数建议与cpu核数相同
$md5_checker->count = 1;
// 分布式部署时请设置成内网ip（非127.0.0.1）
$md5_checker->lanIp = '127.0.0.1';
// 内部通讯起始端口，假如$gateway->count=4，起始端口为4000
// 则一般会使用4000 4001 4002 4003 4个端口作为内部通讯端口 
$md5_checker->startPort = 5050;
// 心跳间隔
// 服务注册地址
$gateway->registerAddress = '127.0.0.1:1236';


/*
// 当客户端连接上来时，设置连接的onWebSocketConnect，即在websocket握手时的回调
$gateway->onConnect = function($connection)
{
    $connection->onWebSocketConnect = function($connection , $http_header)
    {
        // 可以在这里判断连接来源是否合法，不合法就关掉连接
        // $_SERVER['HTTP_ORIGIN']标识来自哪个站点的页面发起的websocket链接
        if($_SERVER['HTTP_ORIGIN'] != 'http://chat.workerman.net')
        {
            $connection->close();
        }
        // onWebSocketConnect 里面$_GET $_SERVER是可用的
        // var_dump($_GET, $_SERVER);
    };
}; 
*/
$md5_checker->onWorkerStart = function () {



      //
    //    $msg = array('type' => 'workerman status', 'msg'=>"Starting checkers",'time'=>time());
        //$db->insert('gui_system_run_log')->cols($msg)->query();

        $checkTimer = Timer::add(10,function(){
            //检查命令状态
            $db = Db::instance('db1');
            $rows = $db->select("id,started,start_time,progress,cmd,sub_cmd")->from("gui_cmd_log")->where("finished=0")->query();
            foreach ($rows as $log){
                $current_time = time();
                $used_time = $current_time - (int)$log['start_time'];
                if($used_time > 120 && $log['started']==0){
                    //命令失败
                    $log['finished'] = 1;
                    $log['status'] = 2000;//启动失败
                    $cond = "id=:I";
                    $bind = array("I"=>$log['id']);
                    $db->update("gui_cmd_log")->cols($log)->where($cond)->bindValues($bind)->query();
                }
                else{
                    if($used_time > 3600 && ($log['cmd']=='MD5'||$log['cmd']=='COPY') && $log['sub_cmd'] == 'START'){
                        if((int)$log['progress'] <= 0){
                            $log['finished'] = 1;
                            $log['status'] = 2001;//命令未被正确执行
                            $cond = "id=:I";
                            $bind = array("I"=>$log['id']);
                            $db->update("gui_cmd_log")->cols($log)->where($cond)->bindValues($bind)->query();
                        }
                    }
                }
            }

            //推送消息
            //检查有无告警
            $rows = $db->select("*")->from("gui_run_time_err_log")->innerJoin('gui_cmd_log','gui_run_time_err_log.cmd_id = gui_cmd_log.id')->where("dismissed=0")->query();
            if($rows) {
                $num = count($rows);
                $attached = array('type' => 'cmd_caution', 'num' => $num);
                $ret = array_merge($rows, $attached);
                ExtendGateWay::sendToAll(json_encode($ret));
                //将dismiss设为1
                $_t = time();
                //foreach($rows as $log){
                $cols = array(
                    "dismissed" => 1,
                    'dismiss_time' => $_t
                );
                $cond = "dismissed=:I";
                $bindV = array("I" => 0);
                $db->update("gui_run_time_err_log")->where($cond)->bindValues($bindV)->cols($cols)->query();
            }
            $rows = $db->select("*")->from("gui_cmd_disk")->innerJoin('gui_cmd_log','gui_cmd_disk.cmd_id = gui_cmd_log.id')->where("1=1")->query();
            if($rows) {
                foreach ($rows as $item){
                    if($item['finished'] == 1){
                        $cmd_id = $item['cmd_id'];
                        $conn = "cmd_id=:C";
                        $bindV = array("C"=>$cmd_id);
                        $db->delete("gui_cmd_disk")->where($cond)->bindValues($bindV)->query();
                    }
                }
            }
            //
           // }
        });




};
// 如果不是在根目录启动，则运行runAll方法
if (!defined('GLOBAL_START')) {
    Worker::runAll();
}

