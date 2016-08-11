﻿function Deployer(_scope) {
    this.scope = _scope;
    this.cab_id = null;
    this.l = 0;//遍历指针
    this.g = 0;
    this.d = 0;
    this.sn = '';
    //所有待执行的任务
    this.disks = [];

    //表示当前正在进行批量磁盘信息获取操作
    this.working = false;
    //finished=true表示上一次磁盘信息查询操作已经完成
    this.finished = true;
    this.ready = false;
    this.idx = 0;
    this.cmd_id = 0;
    this.stage = 0;
    this.type = "diskinfo";
    this.cmdQueue = ['DISKINFO', 'BRIDGE', 'FILETREE', 'BRIDGE_STOP'];
}

Deployer.prototype = {
    available: function () {
        return !this.working;
    },
    getLength: function () {
        return this.disks.length;
    },
    on_init: function (c) {
        this.cab_id = c.toString();

        this.time_unit = 5000;//五秒更新一次；
        this.worker = null;
        var that = this;
        this.disks = [];
        //从数据库中读取在位且未桥接的磁盘
        global_http({
            url: global_root + "&a=getdeviceinfo&cab=" + c,
            method: 'GET'
        }).success(function (data) {
            data.forEach(function (e) {
                if (e.bridged == 0 && e.loaded == 1) {
                    var new_dsk = {
                        c: that.cab_id,
                        l: e.level.toString(),
                        g: e.zu.toString(),
                        d: e.disk.toString(),
                        sn: e.sn
                    };
                    that.disks.push(new_dsk);
                }
            });
            that.ready = true;
        }).error(function () {
            new PNotify({
                title: '批量硬盘信息获取',
                text: '和服务器连接失败，请重试',
                type: 'error',
                shadow: true,
                icon: 'fa fa-alert'
            });
        });
    },
    deployDiskInfo: function () {
        var that = this;
        this.worker = global_interval(function () {
            if (!that.finished || !that.ready) {
                return;
            }

            //全部完成
            if (that.is_done()) {
                that.working = false;
                global_cabinet_helper.i_on_deploy(that.cab_id, false);
                global_interval.cancel(that.worker);
                return;
            }
            var disks = that.disks;
            var idx = that.idx;
            var msg = {
                cmd: 'DISKINFO',
                device_id: disks[idx].c,
                level: disks[idx].l,
                group: disks[idx].g,
                disk: disks[idx].d
            };
            that.updateIndex();
            global_cmd_helper.sendcmd(msg);
            that.finished = false;
        }, that.time_unit);
    }
    ,
    startDeploy: function (type) {
        if (this.working == true) {
            //防止重复启动
            return;
        }
        this.working = true;
        this.type = type;
        this.idx = 0;
        global_cabinet_helper.i_on_deploy(this.cab_id, true);
        switch (type) {
            case 'diskinfo':
                //目前diskinfo和filetree实现方式不一致,待日后一致化
                this.deployDiskInfo();
                break;
            case 'filetree':
                this.filetree();
                break;
        }

    },
    resetDeployer: function () {
        this.stage = 0;
        this.idx = 0;
        this.cmd_id = 0;
        this.working = false;
    }
    ,
    updateDeployer: function (suc,sn) {
        if (suc) {//命令成功,转入下一步
            if (this.type == 'filetree' && this.stage == 0) {
                //更新sn
               if(sn)this.sn = sn;
            }
            this.stage = this.stage + 1;
            if (this.stage > this.cmdQueue.length) {
                this.stage = 0;
            }
        }
        else {
            //命令失败,开始下一个
            this.stage = 0;
        }
        this.updateIndex();

    },
    stopDeploy: function () {
        this.idx = this.disks.length + 1;
        if(this.type == 'filetree')
        this.resetDeployer();

    },
    filetree: function (suc) {
        var cmd = this.cmdQueue[this.stage];
        var sub_cmd = 'START';
        if (cmd == 'BRIDGE_STOP') {
            cmd = 'BRIDGE';
            sub_cmd = 'STOP';
        }
        var msg;
        if (cmd == 'DISKINFO')
            msg = {
                cmd: cmd,
                sub_cmd: sub_cmd,
                device_id: this.cab_id.toString(),
                level: this.l.toString(),
                group: this.g.toString(),
                disk: this.d.toString()
            };
        if (cmd == 'BRIDGE' || cmd == 'FILETREE') {
            msg = {
                cmd: cmd,
                sub_cmd: sub_cmd,
                device_id: this.cab_id.toString(),
                level: this.l.toString(),
                group: this.g.toString(),
                disks: [{sn: this.sn, id: this.d.toString()}]
            };
        }
     //   this.cmd_id = global_cmd_helper.sendcmd(msg);

        msg.msg = JSON.stringify(msg);
        var d_this = this;
        global_http.post(global_server, msg).
        success(function (data) {
            if (data['errmsg']) {
                global_err_pool.add(data);
                toastr.warning("目录获取错误:"+data['errmsg']);
                d_this.hdlFail();
                return;
            }
            msg.CMD_ID = data['id'].toString();
            global_http.post(global_app, msg).success(function () {
                data.username = global_user.username;
                var newCmd = global_cmd_helper.createCmd(data);
                global_task_pool.add(newCmd);
                global_ws_watcher.sendcmd(msg);
                d_this.cmd_id = parseInt(msg.CMD_ID);
            }).
            error(function () {
                global_cmd_helper.delete(msg.CMD_ID);
                toastr.warning('命令发送失败,跳过当前磁盘!');
                d_this.hdlFail();
            });
        }).
        error(function () {
            toastr.warning('命令发送失败,跳过当前磁盘!');
            d_this.hdlFail();
        });

    },
    hdlFail: function () {
        this.cmd_id = 0;
        this.update(this.cmd_id, false);
    },
    is_done: function () {
        if (this.idx >= this.disks.length && this.finished) {
            return true;
        }
        return false;
    },
    updateIndex: function () {
        this.l = this.disks[this.idx].l;
        this.g = this.disks[this.idx].g;
        this.d = this.disks[this.idx].d;
        this.idx++;
    },
    update: function (cmd_id, suc,sn) {
        if(this.working == false){
            return;
        }
        if (parseInt(cmd_id) != parseInt(this.cmd_id)) {
            return;
        }
        console.log(cmd_id);
        if (this.type == 'diskinfo') {
            this.finished = true;
        }
        if (this.type == 'filetree') {
            this.updateDeployer(suc,sn);
            if (!this.is_done())
                this.filetree();
            else {//归零
                this.resetDeployer();
            }
        }
    },
    success: function (cab, l, g, d, suc) {
        if (cab == this.cab_id && l == this.l && g == this.g && d == this.d) {
            this.finished = true;
        }
        if (this.type == 'filetree') {
            this.updateDeployer(suc);
            if (!this.is_done())
                this.filetree();
            else {
                this.resetDeployer();
            }
        }
    }
};