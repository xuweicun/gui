﻿function TaskPool() {
    this.isWatching = false;
    //用于异步处理的锁标识，防止异步处理过程中池子发生变化
    this.locked = false;
    this.ready = false;
    //池子里有完成的命令
    this.dirty = false;
    //正在执行的任务
    this.going = [];
    //停止的任务
    this.done = [];
    //最小轮询时间单元
    this.unitTimer = 1000;
    //小号放大器
    this.smAmp = 5;
    //中号放大器
    this.mdAmp = 10;
    //大号放大器
    this.lgAmp = 20;
    //轮询次数计数器
    this.queryCnt = 0;
    this.stopFlag = false;
    this.maxPoolSize = 50;
    this.cabChanged = false;

    // 用户是否已经离开超过5分钟
    this.user_left = false;

    // 用户最后操作时间
    this.last_user_operate_time = Date.parse(new Date());
}

TaskPool.prototype = {
    reset_user_operate_time: function () {
        this.user_left = false;
        this.last_user_operate_time = Date.parse(new Date());
    },

    add: function (task) {
        this.going.forEach(function (e) {
            if (e.id == task.id) {
                //判断是否是新命令，如果不是新命令，不执行任何操作
                return;
            }
        });
        if (global_cabinet_helper.getLth() > 0) {
            global_cabinet.i_on_cmd_changed(task, true);
        }
        //$scope.testCmdId = task.id;
        this.going.push(task);
        if (!this.isWatching) {
            //this.startWatch();
        }
    },
    updateTask: function (data) {
        var pool = this;
        pool.locked = true;

        //找到命令
        if (!data) {
            console.log("无返回的命令结果");
            return;
        }
        data.forEach(function (e) {

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
                        else {
                            if (e['cmd'] == 'BRIDGE' && e['sub_cmd'] == 'STOP') {
                                var return_msg = JSON.parse(e['return_msg']);
                                var disks = return_msg.disks;
                                var task = u_task;
                                //遍历硬盘
                                for (var idx = 0; idx < disks.length; idx++) {
                                    var disk = global_cabinet_helper.i_get_disk(task.cab_id, task.level, task.group, disks[idx].id);
                                    if (disk) {
                                        disk.i_change_brdige_status(false, null);
                                    }
                                    if (e.status == '25') {
                                        //bridging
                                        //var busy_disks = return_msg['busy_disks'];
                                        global_cmd_helper.updateDeviceStatus();
                                    }
                                }

                                // 更新桥接数
                                global_cabinet_helper.i_on_bridge_success(task.cab_id);

                                // 更新写保护
                                global_cabinet_helper.i_update_write_protect_on_bridge_success(task.cab_id, return_msg.level);
                            }
                        }
                        //如果桥接出现异常,终止桥接状态

                    }
                    break;
                }
            }
        });
        pool.locked = false;

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
    forCab: function () {
        if (!this.cabChanged || global_cabinet_helper.getLth() == 0) {
            return;
        }
        var pool = global_task_pool;
        if (pool.going.length == 0) {
            return;
        }

        //更新时间
        for (var idx = 0; idx < pool.going.length; idx++) {
            var task = pool.going[idx];
            if (task.isDone() || task.device_id != global_cabinet_helper.curr.id) {
                //如果命令执行完毕
                continue;
            }
            //绑定命令
            global_cabinet.i_on_cmd_changed(task, true);
        }
        this.cabChanged = false;
    },
    user_force_leave: function () {
        this.user_left = true;
        this.last_user_operate_time = Date.parse(new Date()) - 300000 - 10000;
        global_scope.locals.set('user_left', 1);
    },
    startGlobalWatch: function () {
        if (this.isWatching) return;//避免重复启动，保持单例状态
        this.isWatching = true;
        global_interval(function () {
            // 检测用户空闲是否超过5分钟
            var has_left = ((Date.parse(new Date()) - global_task_pool.last_user_operate_time) / 1000) > 300;
            if (!global_task_pool.user_left && has_left) {
                global_scope.on_user_left();
                global_task_pool.user_left = has_left;
            }

            var pool = global_task_pool;
            if (pool.going.length == 0) {
                return;
            }
            //命令与柜子绑定
            pool.forCab();
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
                //检查当前柜子id是否有变化
                task.usedTime += 1;
                //console.log(task.usedTime);
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
                pool.cleanCmdPool();
            }
            if (timeFlag != true || pool.locked) {
                return;
            }
            //console.log('查询执行结果', task.id);

            var _tasks = [];
            for (var idx = 0; idx < pool.going.length; idx++) {
                _tasks.push(pool.going[idx].id);
            }
            global_http({
                url: '/index.php?m=admin&c=business&a=getCmdResult',
                method: 'POST',
                data: {tasks: _tasks}
            }).success(function (data) {
                if (data['errmsg']) {
                    global_err_pool.add(data);
                }
                else {
                    //console.log('结果查询完毕，开始对结果进行处理');
                    pool.updateTask(data);
                }

            }).error(function () {
                global_err_pool.add();
            });
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
        // global_cabinet.i_on_bridge_resp(msg);
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
        var int_status = parseInt(task.status);
        var str_text = '[' + global_lang.getLang(task.cmd) + ']命令';
        switch (int_status) {
            case task.timeout:
                type = 'error';
                icon = 'fa fa-clock-o';
                str_text += '执行超时';
                break;
            case task.canceled:
                type = 'info';
                icon = 'fa fa-alarm';
                str_text += '被取消';
                break;
            case task.success:
                type = 'success';
                icon = 'fa fa-check-o';
                str_text += '执行成功';
                break;
            default:
                //失败
                result = '失败';
                type = 'error';
                icon = 'fa fa-alarm';
                str_text += '执行失败：' + global_lang.getLang(int_status);
                break;
        }
        var local_text = task.status
        new PNotify({
            title: '命令执行结果',
            text: str_text,
            type: type,
            shadow: true,
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
        for (var i = 0; i < pool.length; i++) {
            if (pool[i].isDone()) {
                this.done.push(pool[i]);

                if (global_cabinet) global_cabinet.i_on_cmd_changed(pool[i], false);

                //如果正在进行部署，对部署器进行更新
                if (global_deployer.working) {
                    if (global_deployer.type == 'diskinfo')
                        global_deployer.success(pool[i].device_id.toString(), pool[i].level.toString(), pool[i].group.toString(), pool[i].disk.toString());
                    else {
                        if (pool[i]['id'] == global_deployer.cmd_id.toString()) {
                            if (global_deployer.type == 'filetree') {
                                var suc = pool[i]['status'] == 0;
                                var sn = '';
                                if (pool[i]['cmd'] == 'DISKINFO') {
                                    var r_msg = JSON.parse(pool[i]['return_msg']);
                                    if (r_msg != null)
                                        sn = r_msg['SN'];
                                }
                                global_deployer.update(pool[i]['id'], suc, sn);
                            }
                        }
                    }
                }


                var int_status = parseInt(pool[i].status);
                if (int_status == 25) {
                    global_cmd_helper.updateDeviceStatus();
                }
                else if (int_status == 28) {
                    global_modal_helper.show_modal({
                        type: 'question',
                        title: '硬盘命令 -- 构建索引',
                        html: '您确定提交硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i> aa</span>）的<span class="bk-fg-primary"> [构建索引] </span>操作？以支持硬盘的离线访问。',

                        on_click_handle: function (data) {
                            console.log(data);
                        },
                        on_click_param: pool[i]
                    });

                    global_task_pool.load_tasks();
                }
                else if (int_status == 26) {

                    global_task_pool.load_tasks();
                }
                this.notify(pool[i]);
                pool.splice(i, 1);
            }
        }
        this.dirty = false;
    },
    load_tasks: function () {
        global_http({
            url: '/index.php?m=admin&c=business&a=getGoingTasks',
            method: 'GET'
        }).success(function (data) {
            global_task_pool.ready = true;
            global_task_pool.going = [];

            if (data && data.length > 0) {
                for (var i = 0; i < data.length; ++i) {
                    var e = data[i];
                    //console.log(e);
                    if (e.msg == '') {
                        e.msg = e.return_msg;
                    }
                    if (e.msg != '') {
                        var task = global_cmd_helper.createCmd(e);
                        if (!task.isDone()) {
                            global_task_pool.add(task);
                        }
                        else {
                            console.log('timeout', e);
                            //将对应命令设为超时
                            global_http({
                                url: '/index.php?m=admin&c=business&a=setTimeOut&id=' + e.id,
                                method: 'GET'
                            }).error(function (data) {
                                global_err_pool.add(data);
                            });
                        }
                    }
                }
            }
            global_task_pool.ready = true;
        }).error(function () {
            global_err_pool.add();
            this.ready = true;
        });
    }
    ,
    init: function () {
        this.startGlobalWatch();
        this.load_tasks();
    }
    ,
    /*
     * success:成功处理
     * error:失败处理
     * */
    success: function (idx, msg) {
        var task = this.going[idx];
        //如果是START，按下面的方式处理
        switch (task.cmd) {
            case 'WRITEPROTECT':
                var ret = JSON.parse(msg['return_msg']);
                global_cabinet_helper.i_on_write_protect_success(ret);
                break;
            case 'DEVICEINFO':
                global_cabinet_helper.checkChg(msg);
                break;
            case 'MD5':
                if (task.subcmd == 'START') {
                    //更新硬盘MD5值
                    if (task.cab_id == global_cabinet.id)
                        global_cmd_helper.getdiskinfo(task.level, task.group, task.disk, task.cab_id);
                }
                break;
            case 'DEVICESTATUS':
                //如果命令对应是当前柜子
                if (task.device_id == global_cabinet.id) {
                    global_cmd_helper.updateDeviceStatus();
                }
                break;
            case 'DISKINFO':
                //如果命令对应是当前柜子
                if (task.cab_id == global_cabinet.id)
                    global_cmd_helper.getdiskinfo(task.level, task.group, task.disk, task.cab_id);
                break;
            case 'BRIDGE':
                //如果桥接
                var return_msg = JSON.parse(msg['return_msg']);
                var paths = return_msg.paths;
                var disks = return_msg.disks;
                //遍历硬盘
                for (var idx = 0; idx < disks.length; idx++) {
                    var disk = global_cabinet_helper.i_get_disk(task.cab_id, task.level, task.group, disks[idx].id);
                    if (disk) {
                        if (task.subcmd == 'START') {
                            disk.i_change_brdige_status(true, null);
                        }
                        else if (task.subcmd == 'STOP') {
                            disk.i_change_brdige_status(false, null);
                        }
                    }
                }

                // 更新桥接数
                global_cabinet_helper.i_on_bridge_success(task.cab_id);

                // 更新写保护
                global_cabinet_helper.i_update_write_protect_on_bridge_success(task.cab_id, return_msg.level);

            //如果断开
        }

    }
    ,
    error: function (idx) {

    }
}
;
