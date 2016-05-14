function Deployer(_scope) {
    this.scope = _scope;
    this.cab_id = null;
    this.l = 0;//遍历指针
    this.g = 0;
    this.d = 0;
    //所有待执行的任务
    this.disks = [];

    //表示当前正在进行批量磁盘信息获取操作
    this.working = false;
    //finished=true表示上一次磁盘信息查询操作已经完成
    this.finished = true;
    this.ready = false;
    this.idx = 0;
}

Deployer.prototype = {
    available: function(){
      return !this.working;
    },
    getLength: function(){
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
                    var new_dsk = {c: that.cab_id, l: e.level.toString(), g: e.zu.toString(), d: e.disk.toString()};
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
    startDeploy: function () {
        if (this.working == true) {
            //防止重复启动
            console.log("部署中，请稍后");
            return;
        }
        console.log("开始部署");
        this.working = true;
        var that = this;

        global_cabinet_helper.i_on_deploy(this.cab_id,true);

        this.worker = global_interval(function () {
            if (!that.finished || !that.ready) {
                return;
            }

            //全部完成
            if (that.is_done()) {
                that.working = false;
                global_cabinet_helper.i_on_deploy(that.cab_id,false);
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
    },
    is_done: function () {
        if (this.idx >= this.disks.length) {
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
    success: function (cab, l, g, d) {
        if (cab == this.cab_id && l == this.l && g == this.g && d == this.d) {
            this.finished = true;
        }
    }
};