function CabCmdHelper(_server, _scope, _http) {
    this.scope = _scope;
    this.http = _http;
    this.server = _server;
}

CabCmdHelper.prototype = {
    createCmd : function (log) {
        var newcmd = new CabCmd(log, this.http);
        newcmd.init();
        return newcmd;
    },
    getdiskinfo : function (level, group, disk, cab) {
        this.http({
            url: '/index.php?m=admin&c=business&a=getDiskInfo',
            data: { level: level, group: group, disk: disk, cab_id: cab },
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
    devicestatus : function () {
        var msg = { cmd: 'DEVICESTATUS' };
        return this.sendcmd(msg);
    },
    localTest : function () {
        var msg = this.scope.testMsg.i_getMsg(this.scope.testCmdId);
        var localUrl = '/index.php?m=admin&c=msg';
        this.http({
            url: localUrl,
            data: msg.md5,
            method: 'POST'
        }).success(function (data) {
            alert("done");
        });
    },
    testPost : function () {
        var msg = this.scope.testMsg.i_getMsg(this.scope.testCmdId);
        console.log('Test starting');
        var realUrl = 'http://222.35.224.230/index.php?m=admin&c=msg';
        this.http({
            url: realUrl,
            data: msg.md5,
            method: 'POST'
        }).success(function (data) {
            alert("done");

        });
    },
    writeprotect : function (level) {
        var msg = { cmd: "WRITEPROTECT", subcmd: 'START', level: level };
        this.sendcmd(msg);
    },
    md5 : function (level, group, disk) {
        var msg = { cmd: 'MD5', subcmd: 'START', level: level, group: group, disk: disk };
        this.sendcmd(msg);
    },
    stop : function (id, subcmd) {
        //获取命令参数
        this.http({
            url: '/index.php?m=admin&c=business&a=getCmdResult&cmdid=' + id,
            method: 'GET'
        }).success(function (data) {
            if (data['errmsg']) {
                this.scope.svrErrPool.add(data);
            }
            else {
                var msg = JSON.parse(data['msg']);
                msg.CMD_ID = id.toString();
                msg.subcmd = subcmd;
                this.http.post({ data: msg, url: proxy }).error(function () {
                    console.log('向APP发送消息 失败');
                });
            }
        });
        //增加命令日志
        //发送命令
    },
    copy : function (srcLvl, srcGrp, srcDisk, dstLvl, dstGrp, dstDisk) {
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
    diskinfo : function (level, group, disk) {
        var msg = { cmd: 'DISKINFO', level: level.toString(), group: group.toString(), disk: disk.toString() };
        this.sendcmd(msg);

    },
    bridge : function (level, group, disk) {
        var msg = {
            cmd: 'BRIDGE', subcmd: 'START', level: disk.level.toString(), group: disk.group.toString(), disks: [
                { id: disk.disk.toString(), SN: disk.sn }
            ], filetree: 1
        };
        this.sendcmd(msg);
    },
    cabinfo : function () {
        var msg = {
            cmd: 'DEVICEINFO'
        };
        this.sendcmd(msg);
    },
    isDeviceNeeded : function (msg) {
        if (msg.cmd == 'DEVICEINFO') {
            return false;
        }
        return true;
    },
    delete : function (id) {
        this.http({
            url: '/index.php?m=admin&c=business&a=deleteLog&id=' + id,
            method: 'GET'
        }).error(function (data) {
            console.log("更新存储柜信息失败.");
        });
    },
    sendcmd: function (msg) {
        var that = this;
        //先发送消息告知服务器即将发送指令；
        if (this.isDeviceNeeded(msg)) {
            msg.device_id = this.scope.cab.id.toString();
        }
        this.http.post(this.server, msg).
        success(function (data) {
            if (data['errmsg']) {
                that.scope.svrErrPool.add(data);
            }
            //如果命令为停止，则cmd_id实际为目标ID，且不需要再次赋值

            if ((msg.subcmd == 'STOP') && msg.CMD_ID) {
                msg.CMD_ID = data['id'] + '_' + msg.CMD_ID;
            }
            else {
                msg.CMD_ID = data['id'].toString();
            }
            //else {
            //  if (msg.cmd != 'DEVICEINFO') {

            // }
            //}
            var msgStr = JSON.stringify(msg);
            //服务器收到通知后，联系APP，发送指令；
            // proxy = "/index.php";
            that.http.post(proxy, msg).success(function () {
                //命令池更新
                data['msg'] = msgStr;
                var newCmd = this.scope.cmd.createCmd(data);
                that.scope.taskPool.add(newCmd);
            }).
            error(function (data) {
                that.scope.svrErrPool.add();
                //delete from log;
                that.scope.cmd.delete(data['id']);
            });
            // data['msg'] = msgStr;
            //var newCmd = $scope.cmd.createCmd(data);
            //$scope.taskPool.add(newCmd);
            //更新日志内容，将命令所涉及的插槽信息发送给日志
            that.http.post(this.server, { msg: msgStr, id: data['id'] });
        }).
        error(function (data) {
            that.scope.svrErrPool.add();
        });
    }
};