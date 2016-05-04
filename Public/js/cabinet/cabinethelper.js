//        $scope.cab = new Cabinet();
function CabinetHelper(on_cabinet_select) {
    this.cabs = [];
    this.curr = null;
    this.on_cabinet_select = on_cabinet_select;
}

CabinetHelper.prototype = {
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
        if (this.curr === this.cabs[idx]) {
            return;
        }
        if (this.curr != null) {
            this.curr.selected = false;
        }

        this.curr = this.cabs[idx];
        this.curr.get_select();
        global_cabinet = this.curr;
        global_cmd_helper.updateDeviceStatus();

        this.on_cabinet_select(this.curr);
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
        global_http({
            url: '/index.php?m=admin&c=business&a=getCabInfo',
            method: 'GET'
        }).success(function (data) {
            if (data === null)
                return;
            if (!data['err_msg']) {
                data.forEach(function (e) {
                    var cab = new Cabinet();
                    cab.i_on_init(e.sn, e.level_cnt, e.group_cnt, e.disk_cnt);
                    global_cabinet_helper.i_on_add(cab);
                });
                if (global_cabinet_helper.cabs.length > 0) {
                    global_cabinet_helper.on_select(0);
                    console.log('ok');
                }
                else {
                    console.log('failure');
                    return;
                }
                global_cmd_helper.updateDeviceStatus();
                global_task_pool.init();
            }
        });
    }
};