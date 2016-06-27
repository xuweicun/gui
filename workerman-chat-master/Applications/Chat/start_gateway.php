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

Class AutoChecker{
    //类型:md5 or sn
    public $type = 'md5';
    //当前状态
    public $status = 'waiting';
    //定时器间隔
    public $timerInterval = 300;
    public $plan_id = 0;

    /****
     * @param $_t type
     * @param $_i interval
     */
    public function init($_t,$_i){
        $this->timerInterval = $_i;
        $this->type = $_t;
    }

    /***
     * 定时器
     */
    public function start(){

    }

    /****
     * 自检函数
     */
    public function autoCheck(){
        //如果状态为未开始,获取计划
        if($this->status == 'waiting') {
            $db = Db::instance('db1');
            $db->select('*')->from('gui_check_plan')->where("status='waiting'")->query();
            //检查时间
            
        }
        //检查是否到达规定时间,如已达规定时间,检查是否完成
        //如果状态为完成,配置磁盘优先级,修改状态
        //重新生成计划
        //遍历检查是否有磁盘
        //查询存储柜信息
        $cabs = self::getCabQueue();

    }
}
// gateway 进程
$gateway = new Gateway("Websocket://0.0.0.0:8383");
// 设置名称，方便status时查看
$gateway->name = 'ChatGateway';
// 设置进程数，gateway进程数建议与cpu核数相同
$gateway->count = 4;
// 分布式部署时请设置成内网ip（非127.0.0.1）
$gateway->lanIp = '127.0.0.1';
// 内部通讯起始端口，假如$gateway->count=4，起始端口为4000
// 则一般会使用4000 4001 4002 4003 4个端口作为内部通讯端口 
$gateway->startPort = 2300;
// 心跳间隔
$gateway->pingInterval = 60;
// 心跳数据
$gateway->pingData = '{"type":"ping"}';
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
$gateway->onWorkerStart = function ($worker) {

    // 只在id编号为0的进程上设置定时器，其它1、2、3号进程不设置定时器
    $deviceStatusTimer = Timer::add(300, function () {
        //检查用户数量,如果无用户就不查询
        $cnt = ExtendGateWay::getAllClientCount();
        if ($cnt <= 0) {
            echo "No user";
            return;
        }
        $db = Db::instance('db1');
        //查询多进程
        $ret = $db->select('*')->from('gui_cab')->where('loaded=1')->query();
        //有连接的柜子存在
        if ($ret) {
            $num = count($ret);
            $attached = array('type' => 'status','num'=>$num);
            $ret = array_merge($ret, $attached);
            ExtendGateWay::sendToAll(json_encode($ret));
            //查询磁盘容量
            $ret = $db->select('partition')->from('gui_device')->where('loaded=1 and bridged=1')->query();

            if (!$ret) {
                return;
            }
            $num = count($ret);
            $attached = array('type' => 'partition','num'=>$num);
            $ret = array_merge($ret, $attached);
            ExtendGateWay::sendToAll(json_encode($ret));
        }
    });


};
// 如果不是在根目录启动，则运行runAll方法
if (!defined('GLOBAL_START')) {
    Worker::runAll();
}

