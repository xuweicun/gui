﻿function Deployer(_scope) {
    this.scope = _scope;
    this.lvl_cnt = 0;
    this.grp_cnt = 0;
    this.dsk_cnt = 0;
    this.cab_id = 0;
    this.lvl_idx = 0;//遍历指针
    this.grp_idx = 0;
    this.dsk_idx = -1;
    this.working = false;
    this.finished = true;
}

Deployer.prototype = {
    on_init: function (c, l, g, d) {
        this.cab_id = c;
        this.lvl_cnt = l;
        this.grp_cnt = g;
        this.dsk_cnt = d;
        this.time_unit = 5000;//五秒更新一次；
    },
    startGlobalDeploy: function () {
        if (this.working) {
            //防止重复启动
            return;
        }
        this.working = true;
        var that = this;
        global_interval(function () {
            if (!that.finished) {
                return;
            }
            //全部完成
            if (that.is_done()) {
                this.working = false;
                return;
            }


        }, this.time_unit);
    },
    is_done: function () {
        if (this.lvl_idx >= this.lvl_cnt && this.grp_idx >= this.grp_cnt && this.dsk_idx >= this.dsk_cnt) {
            return true;
        }
        return false;
    },
    updateIndex: function () {
        this.dsk_idx++;
        if(this.dsk_idx >= this.dsk_cnt)
        {
            this.dsk_idx = 0;
            this.grp_idx++;
            if(this.grp_idx >= this.grp_cnt){
                this.grp_idx = 0;
                this.lvl_idx++;
            }
        }
    },
    updateDeviceStatus: function () {
        global_http({
            url: '/index.php?m=admin&c=business&a=getDeviceInfo&cab=' + global_cabinet.id,
            method: 'GET'
        }).success(function (data) {
            // 用户切换了柜子
            if (data.length <= 0 || data[0].cab_id != global_cabinet.id) return;

            global_cabinet.i_load_disks_base_info(data);

            //获取每个硬盘的信息
            for (var idx = 0; idx < data.length; idx++) {
                //如果硬盘在位且有disk_id,获取详细信息；防止有的盘在位但是没有详细信息的
                if (data[idx].loaded == 1 && data[idx].disk_id && data[idx].disk_id > 0) {
                    global_cmd_helper.getdiskinfo(data[idx].level, data[idx].zu, data[idx].disk, data[idx].cab_id);
                }
            }
        }).error(function () {
            console.log("更新存储柜信息失败.");
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
            global_cabinet.i_load_disks_base_info(data);

        });
    },
    devicestatus: function () {
        var msg = {cmd: 'DEVICESTATUS'};
        return this.sendcmd(msg);
    },
    localTest: function () {
        var msg = this.scope.testMsg.i_getMsg(this.scope.testCmdId);
        var localUrl = '/index.php?m=admin&c=msg';
        global_http({
            url: localUrl,
            data: msg.md5,
            method: 'POST'
        }).success(function () {
            alert("done");
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
        }).success(function () {
            alert("done");

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
            console.log("更新存储柜信息失败.");
        });
    },
    sendcmd: function (msg) {
        //先发送消息告知服务器即将发送指令；
        if (this.isDeviceNeeded(msg)) {
            msg.device_id = global_cabinet.id.toString();
        }
        var dstId = 0;
        if (msg.CMD_ID) {
            dstId = msg.CMD_ID;
            delete msg.CMD_ID;
        }
        var toSave = msg;
        toSave.msg = JSON.stringify(msg);
        if (dstId > 0) {
            toSave.CMD_ID = dstId;
        }
        global_http.post(global_server, toSave).
        success(function (data) {
            if (data['errmsg']) {
                global_err_pool.add(data);
            }
            //如果命令为停止，则cmd_id实际为目标ID，且不需要再次赋值
            msg.CMD_ID = data['id'].toString();
            //服务器收到通知后，联系APP，发送指令；
            global_http.post(global_app, msg).success(function () {
                //命令池更新
                var newCmd = global_cmd_helper.createCmd(data);
                global_task_pool.add(newCmd);
            }).
            error(function (data) {
                global_err_pool.add();
                //delete from log;
                //弹出失败提示
                global_cmd_helper.delete(data['id']);
            });
        }).
        error(function () {
            //弹出失败提示
            global_err_pool.add();
        });
    }
};