//        $scope.cab = new Cabinet();
//CabView: 存储柜子的基本信息
function CabPicker() {
    this.id = 0;
    this.sn = '';
    this.lvl_cnt = 0;
    this.grp_cnt = 0;
    this.dsk_cnt = 0;
    this.selected = false;
    this.deploying = false;
    // 在位硬盘数
    this.loaded_disk_cnt = '-';
    // 已桥接硬盘数
    this.bridged_disk_cnt = '-';
    // 异常硬盘数
    this.bad_disk_cnt = 0;
    // 异常MD5硬盘数
    this.bad_md5_disk_cnt = 0;
    // 异常MD5硬盘详情
    this.bad_md5_disk_title = "";
    // 电压
    this.voltage = '-';
    // 电流
    this.current = '-';
    // 电量
    this.electricity = '-';
    // 各层的温湿度
    this.lvls_info = [];
	
	// proxy推送的warning值
	//bit0~bit1: 电量告警. 0:正常, 1:告警, 2:严重告警；bit2~bit3: 电流告警. 意义同电量告警；bit4~bit5: 电压告警. 意义同电量告警.

	//当电量/电流/电压有严重告警时, 也就是值为2时, 
	//1. 代理程序会自动关闭该设备所有的任务。
	//2. 此时应用需要在log中记录任务关闭的原因是电量/电流/电压严重告警，并显示所有的任务为已经关闭。
	
	//bit6 ~bit7 : 层 x(1~6) 柜子的 (1~6) 湿度告警. 0: 正常，1: 警告, 2: 严重告警
	//bit8 ~bit9 : 
	//bit10~bit11: 
	//bit12~bit13: 
	//bit14~bit15: 
	//bit16~bit17: 

	//bit18~bit19: 温度告警. 层x柜子的温度告警.  0: 正常，1: 警告, 2: 严重告警.
	//bit20~bit21: 
	//bit22~bit23: 
	//bit24~bit25: 
	//bit26~bit27: 
	//bit29~bit29: 		
	
	//当温度/湿度有严重告警时, 也就是值为2时, 
	//1. 代理程序会关闭严重告警的层的任务。
	//2. 此时应用需要在log中记录任务关闭的原因是因为温度/湿度太高，
	//并显示相应层的任务已经关闭. 

	//当温度/湿度有告警时, 也就是值为1时, 
	//1. 代理程序不作任何处理。
	//2. 应用程序需要弹出告警信息窗口即可。
	this.warning_value = null;
	
	// proxy推送的channel_error值
	//bit1~bit6: level 1 ~ level6 serial communication error.
	//指示层一到层六是否有串口通信错误. 0: 通信正常. 1:通信错误,
	//若有通信错误:
	//代  理: 如果可能，尽力关闭所有的业务
	//应用层: 若通信错误,标记该层不可用。在界面上打个叉,该层所用业务不可操作。如果有已经成功启动的业务，标记已经结束且结束原因为通信错误.
	this.channel_error = null;
}
CabPicker.prototype = {
    i_on_init: function (c, s, l, g, d) {
        this.id = c;
        this.sn = s;
        this.lvl_cnt = l;
        this.grp_cnt = g;
        this.dsk_cnt = d;

        for (var i = 0; i < l; ++i) {
            this.lvls_info.push({
                temperature: '-',
                humidity: '-',
				channel_error: false
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
    this.modal_index = -1;

    this.changed = false;
	
	// 告警信息
	this.warning = {
		msg: '',
		type: 0, // 0=无告警；1=一般告警；2=严重告警
		src:'' //告警源
	};

    this.on_cabinet_select = on_cabinet_select;
}

CabinetHelper.prototype = {
	// 设置告警值
	set_channel_error: function(cab_id, channel_error)
	{
		var _cab = null;
		for (var i=0; i<this.cabs.length; ++i) {
			if (cab_id == this.cabs[i].id) {
				_cab = this.cabs[i];
				break;
			}
		}
		if (_cab == null) return;
		
		var val_c = parseInt(channel_error);
				
		for (var i=0; i<_cab.lvls_info.length; i++) {
			var _err = ((val_c>>i) & 0x00000002) != 0;
			_cab.lvls_info[i].channel_error = _err;
			
			if (_cab === this.curr) this.cab.set_channel_status(i, _err);
		}		
	},	
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
    modal_pick: function (idx) {
      this.modal_index = idx;
    },
    show_select_modal: function(){
        this.modal_index = -1;
        global_modal_helper.show_modal_user('modalSelectCab');
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
        var status = JSON.parse(msg.status);

        var caution_update = false;
        for (var i = 0; i < this.cabs.length; ++i) {
            // 依次判断选择器是否为与所推送消息的ID相同
            var _cab = this.cabs[i];
            if (msg.sn != _cab.id.toString()) continue;
            // 更新电量、电流、电压
            _cab.electricity = msg.electricity;
            _cab.current = msg.charge;
            _cab.voltage = msg.voltage;
            					
            if (_cab.warning_value != status.warning) {
                caution_update = true;
                _cab.warning_value = status.warning
            }

            if (_cab.channel_error != status.channel_error) {
                this.set_channel_error(status.device_id, status.channel_error);
            }

            // 更新温湿度，临时存储
            for (var j = 0; j < _cab.lvls_info.length; ++j) {
                var _lvl_info = _cab.lvls_info[j];

                var th = this.read_temp_hum_info_by_resp(status, j + 1)
                if (th) {
                    _lvl_info.temperature = th.temperature;
                    _lvl_info.humidity = th.humidity;

                    // 若为当前柜子，将温湿度信息更新到cabinet中
                    if (_cab === this.curr) this.update_TempAndHum();
                }
            }
        }

        if (caution_update) {
            global_scope.caution_manage.getCautions();
        }
    },
    i_on_msg_push_partition: function (msg) {
        if (!msg) return;

        // 只有当前选中的硬盘才更新
        var resp = JSON.parse(msg.partition);
        if (!resp || !this.cab)
            return;

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
        $.magnificPopup.close();
        if (this.curr === this.cabs[idx] || idx < 0) {
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

        this.cab.i_on_init(this.curr.id,this.curr.sn, this.curr.lvl_cnt,this.curr.grp_cnt,this.curr.dsk_cnt);
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
    // 接口：用于桥接成功后调用
    i_on_bridge_success: function (cab_id) {
        this.get_disk_cnt(cab_id);
    },	
    // 接口：用于桥接成功后调用
    i_update_write_protect_on_bridge_success: function (cab_id, str_lvl) {
		// 若为当前柜子，重置写保护信息
		if (cab_id == this.cab.id) {
			var int_lvl = 0;
			try{			
				int_lvl = parseInt(str_lvl) - 1;	
				if (int_lvl < 0 || int_lvl > 5){
					throw -1;
				}
			}
			catch(e){
				console.log('invalid level: ' + str_lvl);
				return;
			}
			
			this.cab.levels[int_lvl].write_protect = true;
		}
    },
    // 接口：用于写保护成功后调用
    i_on_write_protect_success: function (ret_msg) {
        if (ret_msg.device_id != this.cab.id.toString()) return;

        if (ret_msg.cmd != 'WRITEPROTECT') {
            console.log('not write protect cmd.');
            return;
        }
        
        if (ret_msg.status == '0' && ret_msg.substatus == '0') {
            var int_lvl = -1;
            try {
                int_lvl = parseInt(ret_msg.level) - 1;

                if (int_lvl < 0 || int_lvl >= this.cab.levels.length) {
                    throw -1;
                }
            }
            catch (e) {
                console.log('error when read write protect level: ' + ret_msg.level);
                return;
            }

            if (ret_msg.subcmd == 'START' || ret_msg.subcmd == 'STOP') {
                this.cab.levels[int_lvl].write_protect = (ret_msg.subcmd == 'START');
            }
            else {
                console.log('unknown write protect subcmd: ' + ret_msg.subcmd);
            }
        }
    },
    get_all_disk_cnt: function () {
        for (var i = 0; i < this.cabs.length; ++i) {
            this.get_disk_cnt(this.cabs[i].id);
        }
    },
    update_disk_cnt: function (data) {
        if (!data || data.length <= 0) return;

        var cab_id = -1;
        try {
            cab_id = parseInt(data[0].cab_id);
        }
        catch (e) {
            console.log('invalid device info');
            return;
        }

        var cnt_l = 0;
        var cnt_b = 0;
        var cnt_x = 0;//有问题的硬盘数量
        var cnt_md5_changed = 0;//有问题的MD5硬盘数量
        for (var i = 0; i < data.length; ++i) {
            var _dsk = data[i];
            if (_dsk.cab_id != cab_id) continue;

            if (_dsk.loaded == '1') {
                cnt_l++;

                if (_dsk.bridged == '1') {
                    cnt_b++;
                }
                if (_dsk.normal == '0') {
                    cnt_x++;
                }				
                if (_dsk.md5_changed == '1') {
					if (this.bad_md5_disk_title != '') this.bad_md5_disk_title += ',';
					
					this.bad_md5_disk_title += (_dsk.level + 1) + '-' + (_dsk.group + 1) + '-' + (_dsk.disk + 1) + '#'
                    cnt_md5_changed++;
                }
            }
        }

        for (var i = 0; i < global_cabinet_helper.cabs.length; ++i) {
            var _cab_h = global_cabinet_helper.cabs[i];
            if (_cab_h.id == cab_id) {
                _cab_h.loaded_disk_cnt = cnt_l
                _cab_h.bridged_disk_cnt = cnt_b;
                _cab_h.bad_disk_cnt = cnt_x;
                _cab_h.bad_md5_disk_cnt = cnt_md5_changed;
                break;
            }
        }
    },
    // 更新在位硬盘数
    get_disk_cnt: function (cab_id) {
        global_http({
            url: '/index.php?m=admin&c=business&a=getDeviceInfo&cab=' + cab_id,
            method: 'GET'
        }).success(function (data, status, headers, config) {
            global_cabinet_helper.update_disk_cnt(data);
        }).error(function () {
            console.log("更新存储柜信息失败.");
        });
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
				global_scope.is_ok = true;
                global_task_pool.init();
                return;
            }
            if (!data['err_msg']) {
                data.forEach(function (e) {
                    var cab = new CabPicker();
                    cab.i_on_init(e.sn, e.name, e.level_cnt, e.group_cnt, e.disk_cnt);
                    global_cabinet_helper.i_on_add(cab);
                });
				
                if (global_cabinet_helper.cabs.length > 0) {
                    global_cabinet_helper.on_select(0);

                    global_cabinet_helper.get_all_disk_cnt();
                    console.log('ok');
					
					global_scope.caution_manage.getCautions();
                }
                else {
                    console.log('failure');
                    return;
                }
                //global_cmd_helper.updateDeviceStatus();
                global_task_pool.init();
            }
        });
    }
};