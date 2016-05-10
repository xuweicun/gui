function Deployer(_scope) {
    this.scope = _scope;
    this.lvl_cnt = 0;
    this.grp_cnt = 0;
    this.dsk_cnt = 0;
    this.cab_id = 0;
    this.lvl_idx = 1;//遍历指针
    this.grp_idx = 1;
    this.dsk_idx = 0;
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
        that.updateIndex();
            var msg = { cmd: 'DISKINFO', device_id: that.cab_id.toString(),level: that.lvl_idx.toString(), group: that.grp_idx.toString(), disk: that.dsk_idx.toString() };
        global_cmd_helper.sendcmd(msg);
            that.finished = false;
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
        if(this.dsk_idx > this.dsk_cnt)
        {
            this.dsk_idx = 1;
            this.grp_idx++;
            if(this.grp_idx > this.grp_cnt){
                this.grp_idx = 1;
                this.lvl_idx++;
            }
        }
    },
    success: function(cab,l,g,d)
    {

        if(cab == this.cab_id && l == this.lvl_idx+1 && g==this.grp_idx+1 && d==this.dsk_idx+1)
        {
            this.finished = true;
        }
    }
};