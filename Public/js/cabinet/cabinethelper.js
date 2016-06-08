//        $scope.cab = new Cabinet();
//CabView: 存储柜子的基本信息
function CabPicker() {
    this.id = 0;
    this.lvl_cnt = 0;
    this.grp_cnt = 0;
    this.dsk_cnt = 0;
    this.selected = false;
    this.deploying = false;
    // 电压
    this.voltage = '-';
    // 电流
    this.current = '-';
    // 电量
    this.electricity = '-';
    // 各层的温湿度
    this.lvls_info = [];
}
CabPicker.prototype = {
    i_on_init: function (c, l, g, d) {
        this.id = c;
        this.lvl_cnt = l;
        this.grp_cnt = g;
        this.dsk_cnt = d;

        for (var i = 0; i < l; ++i) {
            this.lvls_info.push({
                temperature: '-',
                humidity: '-'
            });
        }
    },
    on_select: function(){
        this.selected = true;
    },
    on_drop: function(){
        this.selected = false;
    }
}
function CabinetHelper(on_cabinet_select) {
    // 柜子选择器集合
    this.cabs = [];
    // 当前柜子选择器
    this.curr = null;
    // 当前柜子详细信息
    this.cab = null;

    this.changed = false;

    this.on_cabinet_select = on_cabinet_select;
}

CabinetHelper.prototype = {
    read_temp_hum_info_by_resp: function (status, lvl_id) {
        if (!status || !status.levels) return null;

        for (var i = 0; i < status.levels.length; ++i) {
            var _lvl = status.levels[i];
            if (_lvl.id == lvl_id) {
                return _lvl;
            }
        }

        return null;
    },
    // 更新当前柜子的温湿度信息
    update_TempAndHum: function () {
        var lvls = this.curr.lvls_info;
        var dst_lvls = this.cab.levels;

        for (var i = 0; i < lvls.length; ++i) {
            var th = lvls[i];
            var d_lvl = dst_lvls[i];

            d_lvl.temperature = th.temperature;
            d_lvl.humidity = th.humidity;
        }
    },
    // 当收到服务器推送消息时
    i_on_msg_push_status: function (msg) {
        if (!msg) return;

        for (var i = 0; i < this.cabs.length; ++i) {
            // 依次判断选择器是否为与所推送消息的ID相同
            var _cab = this.cabs[i];
            if (msg.sn != _cab.id) continue;

            // 更新电量、电流、电压
            _cab.electricity = msg.electricity;
            _cab.current = msg.charge;
            _cab.voltage = msg.voltage;

            // 更新温湿度，临时存储
            for (var j = 0; j < _cab.lvls_info.length; ++j) {
                var _lvl_info = _cab.lvls_info[j];

                var th = read_temp_hum_info_by_resp(msg.status, j + 1)
                if (th) {
                    _lvl_info.temperature = th.temperature;
                    _lvl_info.humidity = th.humidity;

                    // 若为当前柜子，将温湿度信息更新到cabinet中
                    if (_cab === this.curr) this.update_TempAndHum();
                }
            }
        }
    },
    i_on_msg_push_partition: function (msg) {
        if (!msg) return;

        // 只有当前选中的硬盘才更新
        var resp = msg.partition;
        if (!resp) return;

        var _dsk = this.cab.curr;
        if (_dsk.l == resp.level - 1 && _dsk.g == resp.group - 1 && _dsk.d == resp.disk - 1) {
            _dsk.partitions = resp.partitions;
        }
    },
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

        this.update_TempAndHum();
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