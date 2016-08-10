function CabCmdHelper(_scope) {
    this.scope = _scope;
}

CabCmdHelper.prototype = {
    // 上一次命令发送时间
    last_cmd_send_time: 0,   

    updateDeviceStatus: function () {
        global_http({
            url: '/index.php?m=admin&c=business&a=getDeviceInfo&cab=' + global_cabinet.id,
            method: 'GET'
        }).success(function (data) {
            // 用户切换了柜子
            if (data.length <= 0 || data[0].cab_id != global_cabinet.id) return;

            global_cabinet.i_load_disks_base_info(data);

            global_cabinet_helper.update_disk_cnt(data);

            //获取每个硬盘的信息
            for (var idx = 0; idx < data.length; idx++) {
                //已经取到过sn的就不需要再取了
                if(data[idx].sn)
                continue;
                //如果硬盘在位且有disk_id,获取详细信息；防止有的盘在位但是没有详细信息的
                if (data[idx].loaded == 1 && data[idx].disk_id && data[idx].disk_id > 0) {
                    global_cmd_helper.getdiskinfo(data[idx].level, data[idx].zu, data[idx].disk, data[idx].cab_id);
                }
            }
        }).error(function (data) {
            console.log("更新存储柜信息失败.");
			global_modal_helper.show_modal({
				type: 'error',
				title: 'Fatal Error',
				html: data
			});
        });
    },
    createCmd: function (log) {
        var newcmd = new CabCmd(log);
        newcmd.init();
        return newcmd;
    },
    getdiskinfo: function (level, group, disk, cab) {
        global_http({
            url: '/index.php?m=admin&c=business&a=getDiskInfo',
            data: {level: level, group: group, disk: disk, cab_id: cab},
            method: 'POST'
        }).success(function (data) {
            if (data['errmsg']) {//不存在
                disk.capacity = '未知';
                disk.sn = '未知';
                disk.bridged = 0;
                disk.loaded = 0;
                return;
            }
            if (data.length > 0) {
                global_cabinet.i_load_disk(data[0]);
            }
            else {
                console.log('Empty disk');
            }
        });
    },
    devicestatus: function () {
        var msg = {cmd: 'DEVICESTATUS'};
        return this.sendcmd(msg);
    },
    localTest: function (to_post) {
        global_scope.test.disable = true;
        global_scope.test.result = "";

        var obj_post = {};
        try {
            obj_post = JSON.parse(to_post);
            if ('[object Object]' !== Object.prototype.toString.call(obj_post)) {
                throw 'not json object';
            }
        }
        catch (e) {
            global_scope.test.result = e.toString();
            global_scope.test.disable = false;
            return;
        }

        var _cmds = global_scope.test.cmds;
        for (var i = 0; i < _cmds.length; ++i) {
            if (_cmds[i] == to_post) {
                _cmds.splice(i, 1);
                break;
            }
        }
        if ('[object Array]' === Object.prototype.toString.call(_cmds)) {
            _cmds.unshift(to_post);
        }
        else {
            global_scope.test.cmds = _cmds = [];
            global_scope.locals.setObject('test_cmds', _cmds);
            global_scope.test.result = 'test_cmds is not array';
            return;
        }

        global_scope.locals.setObject('test_cmds', _cmds);

        var msg = to_post;//this.scope.testMsg.i_getMsg(this.scope.testCmdId);
        var localUrl = '/index.php?m=admin&c=msg';
        global_http({
            url: localUrl,
            data: msg,
            method: 'POST'
        }).success(function (data) {
            global_scope.test.result = data;
            global_scope.test.disable = false;
        }).error(function (data) {
            global_scope.test.result = data;
            global_scope.test.disable = false;
        });
    },
    testPost: function () {

        var msg = this.scope.testMsg.i_getMsg(this.scope.testCmdId);
        console.log('Test starting');
        var realUrl = 'http://222.35.224.230/index.php?m=admin&c=msg';
        global_http({
            url: realUrl,
            data: msg.md5,
            method: 'POST'
        }).success(function (data) {
            alert(data);
        }).error(function (data) {
        });
    },
    writeprotect: function (level) {
        var msg = {cmd: "WRITEPROTECT", subcmd: 'START', level: level};
        this.sendcmd(msg);
    },
    md5: function (level, group, disk) {
        var msg = {cmd: 'MD5', subcmd: 'START', level: level, group: group, disk: disk};
        this.sendcmd(msg);
    },
    stop: function (id, subcmd) {
        //获取命令参数
        global_http({
            url: '/index.php?m=admin&c=business&a=getCmdResult&cmdid=' + id,
            method: 'GET'
        }).success(function (data) {
            if (data['errmsg']) {
                global_err_pool.add(data);
            }
            else {
                var msg = JSON.parse(data['msg']);
                msg.CMD_ID = id.toString();
                msg.subcmd = subcmd;
                global_http.post({data: msg, url: global_app}).error(function () {
                    console.log('向APP发送消息 失败');
                });
            }
        });
        //增加命令日志
        //发送命令
    },
    copy: function (srcLvl, srcGrp, srcDisk, dstLvl, dstGrp, dstDisk) {
        var msg = {
            cmd: 'COPY',
            subcmd: 'START',
            srcLevel: srcLvl,
            srcGroup: srcGrp,
            srcDisk: srcDisk,
            dstLevel: dstLvl,
            dstGroup: dstGrp,
            dstDisk: dstDisk
        };
        this.sendcmd(msg);
    },
    diskinfo: function (level, group, disk) {
        var msg = {cmd: 'DISKINFO', level: level.toString(), group: group.toString(), disk: disk.toString()};
        this.sendcmd(msg);

    },
    bridge: function (level, group, disk) {
        var msg = {
            cmd: 'BRIDGE', subcmd: 'START', level: disk.level.toString(), group: disk.group.toString(), disks: [
                {id: disk.disk.toString(), SN: disk.sn}
            ], filetree: 1
        };
        this.sendcmd(msg);
    },
    cabinfo: function () {
        var msg = {
            cmd: 'DEVICEINFO'
        };
        this.sendcmd(msg);
    },
    isDeviceNeeded: function (msg) {
        return msg.cmd != 'DEVICEINFO';
    },
    delete: function (id) {
        global_http({
            url: '/index.php?m=admin&c=business&a=deleteLog&id=' + id,
            method: 'GET'
        }).error(function () {
            console.log("命令删除失败.");
        });
    },
    objectClone: function (obj) {
        if ((typeof obj) == 'object') {
            var res = (!obj.sort) ? {} : [];
            for (var i in obj) {
                res[i] = obj[i];
            }
            return res;
        } else if ((typeof obj) == 'function') {
            return (new obj()).constructor;
        }
        return obj;
    },
    onWsMsg: function (cmd_log) {
       //长连接推送的命令同步消息
        //首先判断是否是本用户的消息
        if(cmd_log.user_id.toString() == global_user.id.toString())
        {
            console.log("是本用户自己创建的命令,忽略",cmd_log.user_id);
            return;
        }
        var new_task = this.createCmd(cmd_log);
        global_task_pool.add(new_task);
    },
    go_login_page: function () {
        alert("do nothing");
    }
    ,
    sendcmd: function (msg, on_done) {
        //先判断是否退出登录
        console.log("是否离线?",global_user.off_line);
        if(global_user.off_line){
            global_modal_helper.show_modal({type:'question',title:'发送命令',html:'您已退出,如需发送命令,请点击确定前往重新登录页面。',
            on_click_target:this,on_click_handle:'go_login_page',on_click_param:''});
            return 0;
        }

        var timestamp = (Date.parse(new Date())) / 1000;
        if (timestamp - this.last_cmd_send_time <= 3) {
            toastr.warning('您发送过于频繁，请稍后再试');
            return 0;
        }
        else {
            this.last_cmd_send_time = timestamp;
        }
				
        //先发送消息告知服务器即将发送指令；
        if (this.isDeviceNeeded(msg) && !msg.device_id) {
            msg.device_id = global_cabinet.id.toString();
        }
        var dstId = 0;
        if (msg.CMD_ID) {
            dstId = msg.CMD_ID;
            delete msg.CMD_ID;
        }
        var toSave = this.objectClone(msg);
        toSave.msg = JSON.stringify(msg);
        if (dstId > 0) {
            toSave.CMD_ID = dstId;
        }
        global_http.post(global_server, toSave).
        success(function (data) {
            if (data['errmsg']) {
                global_err_pool.add(data);
                toastr.warning(data['errmsg']);
                return 0;
            }
            //如果命令为停止，则cmd_id实际为目标ID，且不需要再次赋值
            msg.CMD_ID = data['id'].toString();
            //服务器收到通知后，联系APP，发送指令；
            global_http.post(global_app, msg).success(function () {
                //命令池更新
                //检查是否添加成功
                data.username = global_user.username;
                var newCmd = global_cmd_helper.createCmd(data);
                global_task_pool.add(newCmd);
                global_ws_watcher.sendcmd(msg);	
				if (on_done) {
					on_done();
				}
                return msg.CMD_ID;
            }).
            error(function () {
                global_err_pool.add();
                //delete from log;
                //弹出失败提示

                global_cmd_helper.delete(msg.CMD_ID);
				
				if (on_done) {
					on_done();
				}
                toastr.warning('命令发送失败,请稍后再试!');
            });
        }).
        error(function () {
            //弹出失败提示
            global_err_pool.add();
			
			if (on_done) {
				on_done();
			}
            toastr.warning('命令发送失败,请稍后再试!');
        });
    }
};
