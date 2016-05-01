app_device.controller('statusMonitor', function ($scope, $http, $interval, Lang, TestMsg, DTOptionsBuilder, DTDefaultOptions) {

    var businessRoot = '/index.php?m=admin&c=business';
    $scope.bridgeUrl = '/Public/js/bridge.html';
    $scope.goingTaskUrl = '/bc/Admin/View/Business/goingTask.html';
    $scope.doneTaskUrl = '/bc/Admin/View/Business/doneTask.html';
    $scope.siderBarUrl = '/bc/Admin/View/Business/siderBar.html';
    $scope.cabUrl = '/bc/Admin/View/Business/cabs.html';
    var server = businessRoot + '&a=addcmdlog&userid=' + $scope.user;
    var proxy = "http://222.35.224.230:8080";

    //服务器错误信息池，格式[{errMsg:'err'},{errMsg:'err'}]
    $scope.user = $("#userid").val();
    $scope.testMsg = TestMsg;
    $scope.testCmdId = 0;
    $scope.systReset = function () {
        $http({method: 'GET', url: '/index.php?m=admin&c=business&a=systReset'}).success(function (data) {
            alert('系统重置成功！');
        });
    }
    global_cmd_helper = new CabCmdHelper(server, $scope, $http);
    $scope.cmd = global_cmd_helper;
    $scope.lang = Lang;
    $scope.svrErrPool = {
        pool: [],
        svrDown: false,
        maxPoolSize: 10,
        add: function (data) {
            if (data == undefined) {
                data = {errMsg: '与服务器通信失败。'};
            }
            this.pool.push(data);
            if (this.pool.length > this.maxPoolSize) {
                $scope.taskPool.stopWatch();
                this.svrDown = true;
            }
        }
    };
    $scope.updateDeviceStatus = function () {
        var curr = $scope.cabs.curr;
        var cab_id = curr.id;
        $http({
            url: '/index.php?m=admin&c=business&a=getDeviceInfo&cab=' + cab_id,
            method: 'GET'
        }).success(function (data) {
            curr.i_load_disks_base_info(data);
            //获取每个硬盘的信息
            for (var idx = 0; idx < data.length; idx++) {
                //如果硬盘在位且有disk_id,获取详细信息；防止有的盘在位但是没有详细信息的
                if (data[idx].loaded == 1 && data[idx].disk_id && data[idx].disk_id > 0) {
                    $scope.cmd.getdiskinfo(data[idx].level, data[idx].zu, data[idx].disk, data[idx].cab_id);
                }
            }
        }).error(function (data) {
            console.log("更新存储柜信息失败.");
        });
    }
    //！！服务器出错标志，慎重使用！！
    $scope.taskPool = {
        isWatching: false,
        //用于异步处理的锁标识，防止异步处理过程中池子发生变化
        locked: false,
        ready: false,
        //池子里有完成的命令
        dirty: false,
        //正在执行的任务
        going: [],
        //停止的任务
        done: [],
        //最小轮询时间单元
        unitTimer: 1000,
        //小号放大器
        smAmp: 5,
        //中号放大器
        mdAmp: 10,
        //大号放大器
        lgAmp: 20,
        //轮询次数计数器
        queryCnt: 0,
        stopFlag: false,
        maxPoolSize: 50,
        add: function (task) {
            this.going.forEach(function (e) {
                if (e.id == task.id) {
                    //判断是否是新命令，如果不是新命令，不执行任何操作
                    return;
                }
            });
            if ($scope.cabs.getLth() > 0) {
                $scope.cab.i_on_cmd_changed(task, true);
            }
            $scope.testCmdId = task.id;
            this.going.push(task);
            if (!this.isWatching) {
                this.startWatch();

            }
        },
        updateTask: function (data) {
            var pool = this;
            //找到命令
            if(!data){
                console.log("无返回的命令结果");
                return;
            }
            data.forEach(function(e){
                for (var idx = 0; idx < pool.going.length; idx++) {
                    var u_task = pool.going[idx];
                    if (u_task.id == e['id']) {
                        u_task.updateStatus(e);
                        if (u_task.isDone()) {
                            //需要清理命令池
                            pool.dirty = true;
                            console.log('当前命令:' + u_task.id + '-' + u_task.cmd + '-状态-' + u_task.status);
                            //根据命令修改信息
                            //桥接成功或失败
                            if (u_task.isSuccess()) {
                                pool.success(idx, e);
                            }
                        }
                        break;
                    }
                }
            });

        },
        updateQueryCnt: function () {
            this.queryCnt++;
            if (this.queryCnt > 10000) {
                this.queryCnt = 0;
            }
        },
        deactivate: function (task) {
            var idx = this.going.indexOf(task);
            if (idx == -1) {
                idx = 0;
                for (idx; idx < this.going.length; idx++) {
                    if (this.going[idx].id == task.id) {
                        this.going.splice(idx, 1);
                        break;
                    }
                    idx++;
                }
            }
            else {
                this.going.splice(idx, 1);
            }
            if (task.subcmd == "START" || task.subcmd == "STOP") {
                this.done.push(task);
            }
        },

        startWatch: function () {
            var pool = this;
            this.isWatching = true;
            var taskWatcher = $interval(function () {
                if (this.stopFlag == true || pool.going.length == 0) {
                    this.isWatching = false;
                    $interval.cancel(taskWatcher);
                }
                //更新时间
                for (var idx = 0; idx < pool.going.length; idx++) {
                    var task = pool.going[idx];
                    var timeFlag = false;
                    //更新时间
                    //检查是否超时
                    if (task.isDone()) {
                        //如果命令执行完毕
                        continue;
                    }
                    task.usedTime = task.usedTime + 1;
                    console.log(task.usedTime);
                    if (task.usedTime >= task.timeLimit) {
                        console.log("超时：" + task.cmd + '-' + task.usedTime + '-' + task.timeLimit);
                        task.killTask(task.timeout);
                        pool.dirty = true;
                        continue;
                    }
                }

                //5秒取一次结果
                if (0 == pool.queryCnt % 5) {
                    timeFlag = true;
                }
                pool.updateQueryCnt();
                //检查命令池大小
                if (pool.dirty === true) {
                    //更新命令池
                    $interval.cancel(taskWatcher);
                    pool.cleanCmdPool();
                }
                if (timeFlag != true || pool.locked) {
                    return;
                }
                console.log('查询执行结果', task.id);
                pool.locked = true;
                var _tasks = [];
                for (var idx = 0; idx < pool.going.length; idx++) {
                    _tasks.push(pool.going[idx].id);
                }
                $http({
                    url: '/index.php?m=admin&c=business&a=getCmdResult',
                    method: 'POST',
                    data: {tasks:_tasks}
                }).success(function (data) {
                    if (data['errmsg']) {
                        $scope.svrErrPool.add(data);
                    }
                    else {
                        console.log('结果查询完毕，开始对结果进行处理');
                        pool.updateTask(data);
                    }
                    pool.locked = false;
                }).error(function () {
                    $scope.svrErrPool.add();
                    pool.locked = false;
                });
                // pool.checkProgress(idx);



            }, this.unitTimer);
        },
        //更新桥接状态
        hdlBridgeMsg: function (msg) {
            /* msg.paths = [];
                for (var i in msg.disks) {
                var _dsk = msg.disks[i];
                msg.paths.push({
                "status": "0",
                // 硬盘号，类型int，取值：1-4
                "id": _dsk.id.toString(),
                //路径，类型字符串，长度16字节
                "value": "sdb" + _dsk.id
                });
                }*/
            // if(msg)
            // $scope.cab.i_on_bridge_resp(msg);
        },
        stopWatch: function () {
            this.stopFlag = true;
        },
        showGoing: function () {
            return this.going.length > 0;
        },
        showDone: function () {
            return this.done.length > 0;
        },
        //通知
        notify: function (task) {
            var result = '成功';
            var type = 'success';
            var icon = 'fa fa-check';
            console.log("状态值:" + task.status);
            switch (task.status) {
                case task.timeout:
                    type = 'error';
                    icon = 'fa fa-clock-o';
                    break;
                case task.canceled:
                    type = 'info';
                    icon = 'fa fa-alarm';
                    break;
                case task.success:
                    type = 'success';
                    icon = 'fa fa-check-o';
                    break;
                default :
                    //失败
                    result = '失败';
                    type = 'error';
                    icon = 'fa fa-alarm';
                    break;
            }
            new PNotify({
                title: '命令执行结果',
                text: $scope.lang.getLang(task.cmd) + '命令执行完毕，执行结果：' + $scope.lang.getLang(task.status),
                type: type,
                addclass: 'notification-primary',
                icon: icon
            });
        },
        //更新命令池
        cleanCmdPool: function () {
            if (this.dirty === false) {
                console.log("Don't need to clean.");
                return;
            }
            if (this.locked) {
                console.log("命令池锁启动中，稍后处理");
                return;
            }
            var pool = this.going;
            var newPool = [];
            for (var i = 0; i < pool.length; i++) {
                if (pool[i].isDone()) {
                    this.done.push(pool[i]);
                    $scope.cab.i_on_cmd_changed(pool[i], false);
                    this.notify(pool[i]);
                }
                else
                    newPool.push(pool[i]);
            }
            this.going = [];
            this.going = newPool;
            this.dirty = false;
            this.startWatch();
        },
        init: function () {
            var pool = this;
            $http({
                url: '/index.php?m=admin&c=business&a=getGoingTasks',
                method: 'GET'
            }).success(function (data) {
                var time = new Date();
                pool.ready = true;
                if (data && data.length > 0) {
                    for (var i = 0; i < data.length; ++i) {
                        var e = data[i];
                        console.log(e);
                        if (e.msg != '') {
                            var task = $scope.cmd.createCmd(e);
                            if (!task.isDone()) {
                                pool.add(task);
                            }
                            else {
                                //将对应命令设为超时
                                $http({
                                    url: '/index.php?m=admin&c=business&a=setTimeOut&id=' + e.id,
                                    method: 'GET'
                                }).error(function (data) {
                                    $scope.svrErrPool.add(data);
                                });
                            }
                        }
                    }
                }
                pool.ready = true;
                if (pool.going.length > 0)
                    pool.startWatch();
            }).error(function () {
                $scope.svrErrPool.add();
                this.ready = true;
            });
        },
        /*
            * success:成功处理
            * error:失败处理
            * */
        success: function (idx, msg) {
            var task = this.going[idx];
            //如果是START，按下面的方式处理
            switch (task.cmd) {
                case 'MD5':
                    if (task.subcmd == 'START') {
                        //更新硬盘MD5值
                        if (task.cab_id == $scope.cab.id)
                            $scope.cmd.getdiskinfo(task.level, task.group, task.disk, task.cab_id);
                    }
                    break;
                case 'DEVICESTATUS':
                    //如果命令对应是当前柜子
                    if (task.device_id == $scope.cab.id)
                        $scope.updateDeviceStatus();
                    break;
                case 'DISKINFO':
                    //如果命令对应是当前柜子
                    if (task.cab_id == $scope.cab.id)
                        $scope.cmd.getdiskinfo(task.level, task.group, task.disk, task.cab_id);
                    break;
                case 'BRIDGE':
                    //如果桥接
                    var return_msg = JSON.parse(msg['return_msg']);
                    var paths = return_msg.paths;
                    var disks = return_msg.disks;
                    //遍历硬盘
                    for (var idx = 0; idx < disks.length; idx++) {
                        var disk = $scope.cabs.i_get_disk(task.cab_id, task.level, task.group, disks[idx].id);
                        if (disk) {
                            if (task.subcmd == 'START') {
                                disk.base_info.bridged = true;
                                disk.base_info.bridge_path = paths[idx].value;
                            }
                            if (task.subcmd == 'STOP') {
                                disk.base_info.bridged = false;
                                disk.base_info.bridge_path = null;
                            }
                        }
                    }


                //如果断开
            }

        },
        error: function (idx) {

        }

    };
    $scope.errCodes = {
        ready: false,
        init: function () {
            var that = this;
            $http({
                url: '/Public/js/errcode.json',
                method: 'GET'
            }).success(function (data) {
                that.codes = data;
                that.ready = true;
            }).error(function () {
                $scope.svrErrPool.add();
            });
        }
    };

    $scope.initCab = function () {
        $scope.cmd.cabinfo();
    }

    //        $scope.cab = new Cabinet();
    function Cabs() {
        this.cabs = [];
        this.curr = null;
    }

    Cabs.prototype = {
        //获取一块盘的指针
        i_get_disk: function (c, l, g, d) {
            //找到硬盘
            for (var idx = 0; idx < this.cabs.length; idx++) {
                //找到柜子
                if (this.cabs[idx].id == c) {
                    var thisCab = this.cabs[idx];
                    var disk = thisCab.i_get_disk(l - 1, g - 1, d - 1);
                    return disk;

                }
            }
            return null;
        },
        on_select: function (idx) {
            if (this.curr === this.cabs[idx]) return;

            this.curr.selected = false;
            this.cabs[idx].get_select();
            this.curr = this.cabs[idx];
            $scope.updateDeviceStatus();
            $scope.cab = this.curr;
            global_cabinet = this.curr;
        },
        getLth: function () {
            return this.cabs.length;
        },
        i_on_add: function (new_cab) {
            this.cabs.push(new_cab);
        },
        on_init: function () {
            //clear
            this.cabs = [];
            this.curr = null;
            var that = this;
            $http({
                url: '/index.php?m=admin&c=business&a=getCabInfo',
                method: 'GET'
            }).success(function (data) {
                if (data === null)
                    return;
                if (!data['err_msg']) {
                    data.forEach(function (e) {
                        var cab = new Cabinet();
                        cab.i_on_init(e.sn, e.level_cnt, e.group_cnt, e.disk_cnt);
                        that.i_on_add(cab);
                    });
                    if (that.cabs.length > 0) {
                        console.log('ok');
                        that.curr = that.cabs[0];
                        that.curr.get_select();
                        $scope.cab = that.curr;
                        global_cabinet = $scope.cab;
                    }
                    $scope.updateDeviceStatus();

                    $scope.taskPool.init();
                }
            });
        }
    };

    $scope.cabs = new Cabs();
    $scope.cab = $scope.cabs.curr;
    $scope.start = function () {
        //  $scope.updatetime = myDate.getTime();
        $scope.errCodes.init();
        //read cab information
        $scope.cabs.on_init();
        //$scope.cmd.devicestatus();
    }
    $scope.start();
    $scope.getCabInfo = function () {
        //read cab info from database
        $http({
            url: '/index.php?m=admin&c=business&a=getCabInfo',
            method: 'GET'
        }).success(function (data) {
            if (!data['err_msg']) {
                $scope.cabs.i_on_init(data);
            }
        });
    }
    $scope.getDiskInfo = function (cab, lvl, grp, dsk) {
        //read cab info from database
        $http({
            url: '/index.php?m=admin&c=business&a=getDiskInfo',
            data: {cab: cab, level: lvl, group: grp, disk: dsk},
            method: 'POST'
        }).success(function (data) {
            if (!data['err_msg']) {
                $scope.cab.i_load_disks_base_info(data);
            }
            else {
                console.log(data['err_msg']);
            }
        });
    }

    $scope.$on("msg_send_cmd", function (event, cmd) {
        console.log("parent", msg);
        $scope.cmd.sendcmd(cmd);
    });

}).controller('testCtrl', function ($scope, TestMsg) {
var Test = function () {
    this.server = '/index.php?m=admin&c=msg';
}

});
