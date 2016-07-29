// 柜子Cabinet类的构造函数
function Cabinet() {
    // 柜子ID，用于支持多个柜子
    this.id = -1;
    this.sn = '';
    this.lvl_cnt = 0;
    this.grp_cnt = 0;
    this.dsk_cnt = 0;
    // 当前选中的硬盘对象
    this.curr = null;
    // 存储柜所有层集合，用于存放存储所有相关数据
    this.levels = [];
    //初始化完成后，会变为true；
    this.ready = false;
    // 是否已选中
    this.selected = false;
    // 在位查询命令
    this.cmd_device_status = null;
}

// 柜子Cabinet类的原型
Cabinet.prototype = {
	// 设置链路错误
	set_channel_status: function(lvl, error) 
	{
		if (lvl >= this.levels.length) return;
		
		this.levels[lvl].channel_error = error;
	},
    // 是否正在在位查询
    is_device_status_cmd_going:function(){
        return this.cmd_device_status != null;
    },
    // 在位查询按钮文本
    get_device_status_btn_text:function(){
        return '在位查询' + (this.cmd_device_status != null?'中('+ this.cmd_device_status.usedTime +'s)':'');
    },
    // 初始化存储柜的插槽信息
    i_on_init: function (id, s, level_cnt, group_cnt, disk_cnt) {
        this.id = id;
        this.sn = s;
        this.lvl_cnt = level_cnt;
        this.grp_cnt = group_cnt;
        this.dsk_cnt = disk_cnt;
        this.levels = [];
        for (var i = 0; i < level_cnt; ++i) {
            // 每一层
            var level_obj = {
                idx: i,
                // 写保护
                write_protect: true,
                // 温度
                temperature: '-',
                // 湿度
                humidity: '-',
                // 硬盘组
                groups: [],
				// channel error
				channel_error: false
            };
            for (var j = 0; j < group_cnt; ++j) {
                // 每一组
                var group_obj = {
                    idx: j,
                    // 硬盘插槽
                    disks: []
                };
                for (var k = 0; k < disk_cnt; ++k) {
                    var disk_obj = new Disk(level_obj, group_obj, k);
                    disk_obj.parent = group_obj;
                    group_obj.disks.push(disk_obj);
                }

                group_obj.parent = level_obj;
                level_obj.groups.push(group_obj);
            }
            level_obj.parent = this;
            this.levels.push(level_obj);
        }

        this.select_disk(0, 0, 0);
        this.ready = true;
    },
    // 获得在位信息
    start_cmd_device_status: function () {
        if (this.is_device_status_cmd_going()) {
            global_modal_helper.show_modal({
                type: 'warning',
                title: '磁盘在位查询',
                html: '您所选择的<span class="bk-fg-primary"> [存储柜 ' + this.id + '#] </span>，正在进行<span class="bk-fg-primary"> [磁盘在位查询] </span>命令，请稍候再试！'
            });
            return;
        }
        if (this.id <= 0) return;

        global_modal_helper.show_modal({
            type: 'question',
            title: '磁盘在位查询',
            html: '您确定提交<span class="bk-fg-primary"> [存储柜 ' + this.id + '#] </span>的<span class="bk-fg-primary"> [磁盘在位查询] </span>命令？',
            on_click_handle: function (id) {
                var cmd_obj = {
                    cmd: 'DEVICESTATUS',
                    device_id: id
                };

                if (global_cabinet.cmd_device_status){
                    console.log('Cabinet is geting status.');
                    return;
                }

                global_cabinet.cmd_device_status = cmd_obj;

                global_cmd_helper.sendcmd(cmd_obj);
            },
            on_click_param: this.id.toString()
        });
    },
    get_select: function () {
        this.selected = true;
    },
    // 用于支持前端对存储柜选择硬盘
    select_disk: function (l, g, d) {
        this.curr = this.levels[l].groups[g].disks[d];
        this.curr.get_copy_busy_disk();
        this.curr.update_partitions();
    },
    //获取某块盘的指针
    i_get_disk: function (l, g, d) {
        console.log(l,g,d);
        return this.levels[l].groups[g].disks[d];
    },
    on_cmd_disk_info: function (json_cmd, is_add) {
        if (json_cmd.cmd != 'DISKINFO') return;

        var idx_l = parseInt(json_cmd.level) - 1, idx_g = parseInt(json_cmd.group) - 1, idx_d = parseInt(json_cmd.disk) - 1;
        if (idx_l < 0 || idx_l > 5 || idx_g < 0 || idx_g > 5 || idx_d < 0 || idx_d > 3) {
            console.log("Invalid 'DISKINFO' cmd", json_cmd);
            return;
        }

        var _dsk = this.levels[idx_l].groups[idx_g].disks[idx_d];
        _dsk.curr_cmd = is_add ? json_cmd : null;
		
		if (!is_add) {
			if (json_cmd.status != '0') {
				_dsk.cmd_queue = [];
			}
			
			if (_dsk.cmd_queue.length > 0) {			
				global_cmd_helper.sendcmd(_dsk.cmd_queue.shift());
			}
		}
    },
    on_cmd_bridge: function (json_cmd, is_add) {
        if (json_cmd.cmd != 'BRIDGE') return;

        var idx_l = parseInt(json_cmd.level) - 1, idx_g = parseInt(json_cmd.group) - 1;
        if (idx_l < 0 || idx_l > 5 || idx_g < 0 || idx_g > 5 || json_cmd.disks.length <= 0) {
            console.log("Invalid 'BRIDGE' cmd", json_cmd);
            return;
        }

        for (var i = 0; i < json_cmd.disks.length; ++i) {
            var idx_d = parseInt(json_cmd.disks[i].id) - 1;
            if (idx_d < 0 || idx_d > 3) {
                console.log("Invalid 'BRIDGE' cmd", json_cmd);
                return;
            }

            var _dsk = this.levels[idx_l].groups[idx_g].disks[idx_d];
            _dsk.curr_cmd = is_add ? json_cmd : null;
        }

        this.curr.update_partitions();
    },
    on_cmd_md5: function (json_cmd, is_add) {
        if (json_cmd.cmd != 'MD5') return;

        var idx_l = parseInt(json_cmd.level) - 1, idx_g = parseInt(json_cmd.group) - 1, idx_d = parseInt(json_cmd.disk) - 1;
        if (idx_l < 0 || idx_l > 5 || idx_g < 0 || idx_g > 5 || idx_d < 0 || idx_d > 3) {
            console.log("Invalid 'DISKINFO' cmd", json_cmd);
            return;
        }

        this.levels[idx_l].groups[idx_g].disks[idx_d].curr_cmd = is_add ? json_cmd : null;
    },
    on_cmd_copy: function (json_cmd, is_add) {
        if (json_cmd.cmd != 'COPY') return;

        var idx_sl = parseInt(json_cmd.srcLevel) - 1, idx_sg = parseInt(json_cmd.srcGroup) - 1, idx_sd = parseInt(json_cmd.srcDisk) - 1, idx_dl = parseInt(json_cmd.dstLevel) - 1, idx_dg = parseInt(json_cmd.dstGroup) - 1, idx_dd = parseInt(json_cmd.dstDisk) - 1;
        if (idx_sl < 0 || idx_sl > 5 || idx_sg < 0 || idx_sg > 5 || idx_sd < 0 || idx_sd > 3 || idx_dl < 0 || idx_dl > 5 || idx_dg < 0 || idx_dg > 5 || idx_dd < 0 || idx_dd > 3) {
            console.log("Invalid 'COPY' cmd", json_cmd);
            return;
        }

        this.levels[idx_sl].groups[idx_sg].disks[idx_sd].curr_cmd = is_add ? json_cmd : null;
        this.levels[idx_dl].groups[idx_dg].disks[idx_dd].curr_cmd = is_add ? json_cmd : null;
    },
    on_cmd_device_status: function (json_cmd, is_add) {
        if (json_cmd.cmd != 'DEVICESTATUS') return;
        
        this.cmd_device_status = is_add ? json_cmd : null;
    },
    on_cmd_write_protect: function (json_cmd, is_add) {
        if (json_cmd.cmd != 'WRITEPROTECT') return;

        if (!is_add) {
        }
    },
    on_cmd_filetree: function (json_cmd, is_add) {
        if (json_cmd.cmd != 'FILETREE') return;

        var idx_l = parseInt(json_cmd.level) - 1, idx_g = parseInt(json_cmd.group) - 1, idx_d = parseInt(json_cmd.disk) - 1;
        if (idx_l < 0 || idx_l > 5 || idx_g < 0 || idx_g > 5 || idx_d < 0 || idx_d > 3) {
            console.log("Invalid 'FILETREE' cmd", json_cmd);
            return;
        }

        this.levels[idx_l].groups[idx_g].disks[idx_d].curr_cmd = is_add ? json_cmd : null;
    },

    // 接口：激励，加载插槽基本信息，如在位、桥接等，参数data为'/index.php?m=admin&c=business&a=getDiskInfo'返回值
    i_load_disk: function (e) 
    {
        if (!e) {
            return;
        }

        var int_l = parseInt(e.level) - 1;
        var int_g = parseInt(e.zu) - 1;
        var int_d = parseInt(e.disk) - 1;

        if (int_l < 0 || int_l > 6) {
            console.log("i_load_disk(): Invalid param 'Level'" + e.level);
            return;
        }
        if (int_g < 0 || int_g > 6) {
            console.log("i_load_disk(): Invalid param 'Group'" + e.zu);
            return;
        }
        if (int_d < 0 || int_d > 4) {
            console.log("i_load_disk(): Invalid param 'Disk'" + e.disk);
            return;
        }

        var _dsk = this.levels[int_l].groups[int_g].disks[int_d];

        // 在位置位
        if (_dsk.base_info.loaded != (e.loaded == '1')) {
            _dsk.base_info.loaded = (e.loaded == '1');
        }

        if (_dsk.base_info.bridged != (e.bridged == '1')) {
            _dsk.base_info.bridged = (e.bridged == '1');
        }

        _dsk.detail_info.health = e.normal;

        if (e.loaded == '1' && e.bridged == '1') {
            _dsk.base_info.bridge_path = e.path;

            // 写保护状态置位
            _dsk.level_obj.write_protect = (e.protected == '1');
        }
        // 桥接置位            

        _dsk.detail_info.SN = e.sn;
        _dsk.detail_info.MD5 = e.md5;
        _dsk.detail_info.md5_time = e.md5_time;
        _dsk.detail_info.capacity = e.capacity;
    },

    // 接口：激励，加载柜子基本信息，如在位、桥接等，参数data为'/index.php?m=admin&c=business&a=getDeviceInfo'返回值
    i_load_disks_base_info: function (data, init) {

        // 置空所有插槽
        for (var i = 0; i < this.levels.length; ++i) {
            var lvl_obj = this.levels[i];
            for (var j = 0; j < lvl_obj.groups.length; ++j) {
                var grp_obj = lvl_obj.groups[j];
                for (var k = 0; k < grp_obj.disks.length; ++k) {
                    grp_obj.disks[k].loaded = false;
                }
            }
        }

        for (var i = 0; i < data.length; ++i) {
            this.i_load_disk(data[i]);
        }

        global_scope.is_ok = true;

        if(init === 0){
            return;
        }
    },

    // 接口：激励，当命令集合添加或移除一条命令时触发，当增加时bol_op为true，代表add；当移除时，bol_op为false,代表remove
    i_on_cmd_changed: function (json_cmd, bol_op) {
        //不是本柜子的命令不理会
        if(!json_cmd.cab_id || json_cmd.cab_id.toString() != this.id.toString())
        {
            return;
        }
        switch (json_cmd.cmd) {

            case 'DISKINFO':
                {
                    this.on_cmd_disk_info(json_cmd, bol_op);
                    break;
                }
            case 'BRIDGE':
                {
                    this.on_cmd_bridge(json_cmd, bol_op);
                    break;
                }
            case 'MD5':
                {
                    this.on_cmd_md5(json_cmd, bol_op);
                    break;
                }
            case 'COPY':
                {
                    this.on_cmd_copy(json_cmd, bol_op);
                    break;
                }
            case 'DEVICESTATUS':
                {
                    this.on_cmd_device_status(json_cmd, bol_op);
                    break;
                }
            case 'WRITEPROTECT':
                {
                    this.on_cmd_write_protect(json_cmd, bol_op);
                    break;
                }
            case 'FILETREE':
                {
                    this.on_cmd_filetree(json_cmd, bol_op);
                    break;
                }

            default:
                {
                    console.log('Unknown Cmd');
                    console.log(json_cmd.cmd);
                    break;
                }
        }
    }

};
