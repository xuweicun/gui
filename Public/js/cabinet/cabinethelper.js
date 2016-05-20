//        $scope.cab = new Cabinet();
//CabView: 存储柜子的基本信息
function CabPicker(){
    this.lvl_cnt = 0;
    this.id = 0;
    this.grp_cnt = 0;
    this.dsk_cnt = 0;
    this.selected = false;
    this.deploying = false;
}
CabPicker.prototype = {
    i_on_init: function(c,l,g,d){
        this.lvl_cnt = l;
        this.id = c;
        this.grp_cnt = g;
        this.dsk_cnt = d;
    },
    on_select: function(){
        this.selected = true;
    },
    on_drop: function(){
        this.selected = false;
    }
}
function CabinetHelper(on_cabinet_select) {
    this.cabs = [];
    this.curr = null;
    this.cab = null;
    this.changed = false;
    this.on_cabinet_select = on_cabinet_select;
}

CabinetHelper.prototype = {
    //获取一块盘的指针
    i_get_disk: function (c, l, g, d) {
        //找到硬盘
        if(c != this.curr.id)
        {
            //柜子未选中
            return null;
        }
        return this.cab.i_get_disk(l - 1,g - 1,d - 1);
    },
    i_on_deploy: function(c,going){
     this.cabs.forEach(function(e){
         if(e.id.toString() == c){
             e.deploying = going;
         }
     });
    },
    //检查柜子是否发生变化,包括连接情况、数量
    checkChg: function (e) {
        var msg = JSON.parse(e['return_msg']);
        var cabinets = msg.cabinets;
        var that = this;
        var flag = false;
        //数量变化
        if(e.length != that.getLth()){
            that.changed = true;
            return;
        }
        //柜子标识符发生变化
        cabinets.forEach(function (e) {
            if(that.changed) {
                return;
            }
            flag = false;
            for(var idx = 0;idx < that.cabs.length;idx++){
                if(e.id == that.cabs[idx].id){
                    flag = true;
                    break;
                }
            }
            if(flag == false){
                that.changed = true;
            }
        });
    },
    on_select: function (idx) {
        if (this.curr === this.cabs[idx]) {
            return;
        }
        if(this.curr)
        {
           this.curr.on_drop();
        }
        this.curr = this.cabs[idx];
        this.curr.on_select();
        if(this.cab)
        {
            delete this.cab;
            this.cab = null;
        }
        this.cab = new Cabinet();

        this.cab.i_on_init(this.curr.id,this.curr.lvl_cnt,this.curr.grp_cnt,this.curr.dsk_cnt);
        global_cabinet = this.cab;
        global_cmd_helper.updateDeviceStatus();
        global_task_pool.cabChanged = true;
        this.on_cabinet_select(this.cab);
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
            if (data === null){
                global_task_pool.init();
                return;
            }
            if (!data['err_msg']) {
                data.forEach(function (e) {
                    var cab = new CabPicker();
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