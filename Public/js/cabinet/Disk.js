// 硬盘Disk类的构造函数
function Disk(lvl_obj, grp_obj, d) {
    // l：层索引；g：组索引；d：位索引
    // 索引下标均为0
    this.l = lvl_obj.idx;
    this.g = grp_obj.idx;
    this.d = d;

    this.level_obj = lvl_obj;
    this.group_obj = grp_obj;

    // 分区情况
    this.partitions = [];

    // 温度
    this.temperature = '-';

    // 是否写保护, 已过期，使用层对象的写保护，由于写保护是针对层的
    this.write_protected = true,

    // 用于辅助执行“桥接”命令时，标志硬盘是否被选中
    this.isto_bridge = false;
    // 用于辅助执行“复制”命令时，指定另一块目的/源硬盘对象
    this.copy_disk = null;
    this.copy_src_or_dst = this.g % 2 == 0 ? 'src' : 'dst';
    // 硬盘基本信息集合
    this.base_info = {
        // 是否在位
        loaded: false,
        // 是否桥接
        bridged: false,
        // 已桥接状态的mount文件夹名
        bridge_path: ''
    };
    // 硬盘详细信息集合
    this.detail_info = {
        // 硬盘容量，单位G
        capacity: 0,
        // 序列号
        SN: '',
        MD5: '',
        md5_time: '',
        // 健康状况, 1代表健康，0代表异常
        health:'1',
        // smart属性
        smarts: [
            {
                id: '00',
                current_value: "00",
                data: "00 00 00 00",
                ext_data: "00 00",
                threshold: "00",
                worst_value: "00"
            }
        ]
    };
    // 硬盘正在执行的命令信息
    this.curr_cmd = null;
    // 导致命令执行失败的Busy硬盘
    this.busy_disk = null;
    // 用户尝试提交的命令名称
    this.cmd_name_to_commit = '';
	
	// 待发送队列
	this.cmd_queue = [];
}

// 硬盘Disk类的原型
Disk.prototype = {

    // 变更桥接状态
    i_change_brdige_status: function (is_bridged, path) {
        this.base_info.bridged = is_bridged;
        this.base_info.bridge_path = path;
    },
    // 健康状态
    get_health: function(){
        return this.detail_info.health;
    },
    // 获得柜子ID
    get_cabinet_id:function(){
        return this.parent.parent.parent.id;
    },
    // 获得柜子SN
    get_cabinet_sn:function(){
        return this.parent.parent.parent.sn;
    },
    // 更新分区大小
    update_partitions: function(){
        // 分区大小只有在已桥接的状态下才能获取
        if (this.is_bridged()){
            var _data = {
                device_id: this.get_cabinet_id().toString(),
                level: (this.l + 1).toString(),
                group: (this.g + 1).toString(),
                disk: (this.d + 1).toString()
            };
            global_http.post(global_root+"&a=getPartition", _data).success(function(data){
                try{
                    var _data = JSON.parse(data['partition']);
                    if (_data.partitions){
                        // 必须为当前柜子ID
                        if (parseInt(_data.device_id) != global_cabinet.id){
                            throw "invalid cabinet id: " + _data.device_id;
                        }

                        var lvl = parseInt(_data.level) - 1;
                        var grp = parseInt(_data.group) - 1;
                        var dsk = parseInt(_data.disk) - 1;
                        var _disk = global_cabinet.levels[lvl].groups[grp].disks[dsk];
                        if (!_disk || !_disk.is_bridged()){
                            throw "invalid disk";
                        }

                        // 更新信息
                        _disk.partitions = _data.partitions;
                    }
                }
                catch(e){
                    //console.log('error', e);
                }
                finally{
                    delete _data;
                    _data = undefined;
                }
            });
        }
    },
    has_bridge_disk_selected: function(){
        for (var i=0;i<this.parent.disks.length;++i){
            if (this.parent.disks[i].isto_bridge){
                return true;
            }
        }
        return false;
    },

    cmd_commit_copy_confirm: function(){
        global_modal_helper.show_modal_user('userModalCopyConfirm');
    },
    can_stop: function (cmd_name) {
        if (cmd_name == 'BRIDGE') {
            return this.is_bridged();
        }
        else {
            return cmd_name == 'COPY' || cmd_name == 'MD5';
        }        
    },
    // 用户提交命令
    cmd_commit: function (cmd_name) {
        this.clear_status();

        if (cmd_name == 'FILETREE' && this.is_bridged()) {
            var sibs = this.get_siblings();
            for (var i = 0; i < sibs.length; ++i) {
                var _dsk = sibs[i];
                if (_dsk.get_cmd_name() == cmd_name) {
                    global_modal_helper.show_modal({
                        type: 'warning',
                        title: '硬盘命令 -- 构建索引',
                        html: '硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i> ' + _dsk.get_title() + '</span>）正在进行<span class="bk-fg-primary"> [构建索引] </span>命令，受硬件资源限制无法同时进行构建索引命令，请稍候！'
                    });
                    return;
                }
            }

            global_modal_helper.show_modal({
                type: 'question',
                title: '硬盘命令 -- 构建索引',
                html: '您确定提交硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i> ' + this.get_title() + '</span>）的<span class="bk-fg-primary"> [构建索引] </span>操作？以支持硬盘的离线访问。',
                on_click_target: this,
                on_click_handle: 'cmd_start',
                on_click_param: cmd_name
            });
            return;
        }

        var bdsk = this.get_busy_disk();

        // 停止命令
        if (bdsk === this && this.can_stop(cmd_name)) {
            if (bdsk.is_bridged() && cmd_name == 'BRIDGE') {
                global_modal_helper.show_modal({
                    type: 'question',
                    title: '桥接断开',
                    html: '您确定断开与硬盘（<span class="bk-fg-' + (this.is_bridged() ? 'success' : 'primary') + '"><i class="glyphicon glyphicon-hdd"></i> ' + this.get_title() + '</span>）之间的 <span class="bk-fg-success">[桥接]</span> 状态？',
                    on_click_target: this,
                    on_click_handle: 'cmd_stop'
                });
            }
            else if (this.curr_cmd != null && this.curr_cmd.cmd == cmd_name) {
                global_modal_helper.show_modal({
                    type: 'question',
                    title: '命令停止 -- ' + this.cmd2chs(cmd_name),
                    html: '您确定停止硬盘（<span class="bk-fg-' + (this.is_bridged() ? 'success' : 'primary') + '"><i class="glyphicon glyphicon-hdd"></i> ' + this.get_title() + '</span>）的 <span class="bk-fg-primary">[' + this.cmd2chs(cmd_name) + ']</span> 命令？',
                    on_click_target: this,
                    on_click_handle: 'cmd_stop'
                });
            }
            else {
                global_modal_helper.show_modal({
                    type: 'warning',
                    title: '总线忙',
                    html: '硬盘（<span class="bk-fg-' + (bdsk.is_bridged() ? 'success' : 'primary') + '"><i class="glyphicon glyphicon-hdd"></i> ' + bdsk.get_title() + '</span>）' + bdsk.to_modal_busy_msg()
                });
            }
            
            return;
        }

        if (bdsk) {
            global_modal_helper.show_modal({
                type: 'warning',
                title: '总线忙',
                html: '硬盘（<span class="bk-fg-' + (bdsk.is_bridged() ? 'success' : 'primary') + '"><i class="glyphicon glyphicon-hdd"></i> ' + bdsk.get_title() + '</span>）' + bdsk.to_modal_busy_msg()
            });
            return;
        }        

        if (cmd_name == 'DISKINFO') {
            global_modal_helper.show_modal({
                type: 'question',
                title: '硬盘信息查询',
                html: '您确定提交硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i> ' + this.get_title() + '</span>）的<span class="bk-fg-primary"> [查询] </span>操作？以重新获取硬盘的基本信息。',
                on_click_target: this,
                on_click_handle: 'cmd_start',
                on_click_param: cmd_name
            });
        }
        else if (cmd_name == 'BRIDGE'){
            // 如果有桥接Busy硬盘
            bdsk = this.get_bridge_busy_disk();
            if (bdsk != null) {
                global_modal_helper.show_modal({
                    type: 'warning',
                    title: '总线忙',
                    html: '硬盘（<span class="bk-fg-' + (bdsk.is_bridged() ? 'success' : 'primary') + '"><i class="glyphicon glyphicon-hdd"></i> ' + bdsk.get_title() + '</span>）' + bdsk.to_modal_busy_msg()
                });
                return;
            }
            else {
                // 判断柜子是否已经桥接了2组以上的硬盘
                var bridged_cnt = 0;
                var html = '';
                var _lvls = this.parent.parent.parent.levels;
                for (var i = 0; i < _lvls.length; ++i) {
                    var _grps = _lvls[i].groups;
                    for (var j = 0; j < _grps.length; ++j) {
                        var _grp = _grps[j];
                        var _dsks = _grp.disks;
                        var gb = false;
                        var htmlGrp = '硬盘组'+(i+1)+'-'+(j+1)+'#：'
                        for (var k = 0; k < _dsks.length; ++k) {
                            var _dsk = _dsks[k];
                            if (_dsk.is_bridged()) {
                                if (gb) htmlGrp += '，';

                                htmlGrp += '<span class="bk-fg-success"><i class="glyphicon glyphicon-hdd"></i> ' + _dsk.get_title() + '</span>';

                                gb = true;
                            }
                        }
                        if (gb) {
                            bridged_cnt++;
                            if (html){
                                html += '<br>';
                            }
                            html += '(' + bridged_cnt + ') ' + htmlGrp;
                            break;
                        }
                    }
                }

                if (bridged_cnt >= 2){
                    global_modal_helper.show_modal({
                        type: 'warning',
                        title: '总线忙',
                        html: '当前柜子已经同时桥接了两组硬盘，详情如下：<br>' + html + '<br>无法再桥接更多的硬盘！'
                    });
                    return;
                }
            }

            global_modal_helper.show_modal_user('userModelBridge');
        }
        else if (cmd_name == 'COPY'){
            bdsk = this.get_copy_busy_disk();
            if (bdsk){
                global_modal_helper.show_modal({
                    type: 'warning',
                    title: '总线忙',
                    html: '硬盘（<span class="bk-fg-' + (bdsk.is_bridged() ? 'success' : 'primary') + '"><i class="glyphicon glyphicon-hdd"></i> ' + bdsk.get_title() + '</span>）' + bdsk.to_modal_busy_msg()
                });
                return;
            }

            global_modal_helper.show_modal_user('userModalCopy');
        }
        else if(cmd_name == 'MD5'){
            global_modal_helper.show_modal({
                type: 'question',
                title: '硬盘命令 -- MD5',
                html: '您确定提交硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i> ' + this.get_title() + '</span>）的<span class="bk-fg-primary"> [MD5] </span>操作？以获取硬盘的数据有效性（为保证数据一致性，系统将自动发送<span class="bk-fg-primary"> [查询] </span>命令）。',
                on_click_target: this,
                on_click_handle: 'cmd_start',
                on_click_param: cmd_name
            });
        }
        else {
            global_modal_helper.show_modal({
                type: 'warning',
                title: '硬盘命令 -- 未知',
                html: '未知命令 <span class="bk-fg-primary"> [MD5] </span>，请联系系统维护人员！'
            });
        }
    },

    // 提交写保护命令
    cmd_write_protect_commit: function () {
        // 弹出功能完善功能模态框
        //global_modal_helper.show_modal_working();return;
        
        var html = '';
        var on_click = {};
        var param = this;
        if (!this.is_write_protected()) {
            html = '您确定开启硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i> ' + this.get_title() +
            '</span>）的 [<span class="bk-fg-danger"><i class="fa fa-shield bk-fg-danger"></i> 写保护</span>] 功能？恢复写保护后，所有针对本层硬盘的数据写入操作将会失败。';
            on_click = function (param) {
                global_user.show_second_pwd_modal_with_action(function (lvl) {
                    console.log(1);
                    // send cmd;
                    global_cmd_helper.sendcmd({
                        cmd: 'WRITEPROTECT',
                        subcmd: 'START',
                        level: lvl 
                        });
                }, (param.l + 1).toString());                
            };
        }
        else {
            html = '您确定关闭硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i> ' + this.get_title() +
                '</span>）的 [<span class="bk-fg-danger"><i class="fa fa-shield bk-fg-danger"></i> 写保护</span>] 功能？关闭后，其他用户将有可能篡改(甚至<span class="bk-fg-danger"><b>删除</b></span>)硬盘的重要数据，请慎重！！！';
            on_click = function (param) {
                global_user.show_second_pwd_modal_with_action(function (lvl) {
                    // send cmd;
                    global_cmd_helper.sendcmd({
                        cmd: 'WRITEPROTECT',
                        subcmd: 'STOP',
                        level: lvl
                    });
                }, (param.l + 1).toString());
            };
        }
        global_modal_helper.show_modal({
            type: 'question',
            title: '写保护功能',
            html: html,
            on_click_handle: on_click,
            on_click_param: this,
            on_click_close: false
        });
    },

    get_cmd_error: function () {
        if (this.curr_cmd == null) return '';

        var _cmd = this.curr_cmd;
        if (_cmd.cmd == 'BRIDGE') {
            for (var i = 0; i < _cmd.disks.length; ++i) {
                if (!_cmd.disks[i].SN) {
                    return '硬盘 ' + _cmd.level + '-' + _cmd.group + '-' + _cmd.disks[i].id + '# 的SN号为空，请先执行“查询”命令获取硬盘信息';
                }
            }
        }
        else if (_cmd.cmd == 'COPY') {
            var _lvl = this.parent.parent;
            var _src = _lvl.groups[parseInt(_cmd.srcGroup) - 1].disks[parseInt(_cmd.srcDisk) - 1];
            var _dst = _lvl.groups[parseInt(_cmd.dstGroup) - 1].disks[parseInt(_cmd.dstDisk) - 1];

            var _srcCap = _src.get_capacity();
            var _dstCap = _dst.get_capacity();
            if (_srcCap == '') {
                return '硬盘 ' + _src.get_title() + ' 的容量为空，请先执行“查询”命令获取该硬盘信息';
            }
            if (_dstCap == '') {
                return '硬盘 ' + _dst.get_title() + ' 的容量为空，请先执行“查询”命令获取该硬盘信息';
            }
            if (parseInt(_srcCap) > parseInt(_dstCap)) {
                return '无进行复制，原因：源硬盘 ' + _src.get_title() + ' 的容量(' + _srcCap + 'GB) 超过目的硬盘 ' + _dst.get_title() + ' 的容量(' + _dstCap + 'GB)';
            }
        }
        else {
            return '';
        }

        return '';
    },

    // 选择状态清空
    clear_status: function () {
        var sibs = this.get_siblings();
        for (var i in sibs) {
            sibs[i].isto_bridge = false;
        }

        this.copy_disk = null;
    },

    // 复位
    reset: function () {
        this.curr_cmd = null;
        this.busy_disk = null;
        this.cmd_name_to_commit = '';
        this.base_info.loaded = false;
        this.base_info.bridged = false;
    },

    // 判断是否在位
    is_loaded: function () {
        return this.base_info.loaded;
    },
    // 判断是否已桥接
    is_bridged: function () {
        return this.base_info.loaded && this.base_info.bridged;
    },
    // 判断是否开启了写保护
    is_write_protected: function () {
        return  this.is_bridged() && this.level_obj.write_protect;
    },
    // 获得硬盘位置描述，如1-1-1#等
    get_title: function () {
        return (this.l + 1) + '-' + (this.g + 1) + '-' + (this.d + 1) + ' #';
    },

    // 获得硬盘容量大小，单位GB
    get_capacity: function () {
        return this.base_info.loaded ? this.detail_info.capacity : 0;
    },
    // 获得硬盘序列号
    get_SN: function () {
        return this.base_info.loaded ? this.detail_info.SN : '';
    },
    // 获得硬盘MD5
    get_MD5: function () {
        return this.base_info.loaded ? this.detail_info.MD5 : '';
    },
	get_md5_time: function()
	{
		return this.base_info.loaded? this.detail_info.md5_time: '';
	},

    cmd2chs:function(cmd_name){
        switch (cmd_name) {
            case 'DISKINFO':
                return '查询';
            case 'BRIDGE':
                return '桥接';
            case 'MD5':
                return 'MD5';
            case 'COPY':
                return '复制';
            case 'WRITEPROTECT':
                return '写保护';
            case 'FILETREE':
                return '重建索引';
            default:
                return '未知';
        }
    },
    // 获得命令中文名
    get_commit_cmd_title: function () {
        return this.cmd2chs(this.cmd_name_to_commit);
    },
    is_copy_dsk: function () {
        return this.curr_cmd != null && this.curr_cmd.cmd == 'COPY' && (this.l + 1).toString() == this.curr_cmd.dstLevel && (this.g+1).toString() == this.curr_cmd.dstGroup && (this.d+1).toString() == this.curr_cmd.dstDisk;
    },
    // 依据硬盘状态计算出命令按钮的中文描述
    get_btn_title: function (cmd_name) {
        var title = '';
        var cmd_key = '';

        cmd_key = 'DISKINFO';
        if (cmd_name == cmd_key) {
            title = '查询';
            if (!this.is_loaded() || (this.get_cmd_name() == '' && this.get_cmd_name() != cmd_key)) {
                return title;
            }

            // 当前有命令在执行
            if (this.get_cmd_name() == cmd_key) {
                title = '查询中';
            }

            return title;
        }

        cmd_key = 'FILETREE';
        if (cmd_name == cmd_key) {
            return this.get_cmd_name() == cmd_key ? '索引建立中' : '重建索引';
        }

        cmd_key = 'BRIDGE';
        if (cmd_name == cmd_key) {
            title = '桥接';
            if (this.is_bridged()) {
                return '停止桥接';
            }

            // 当前有命令在执行
            if (this.get_cmd_name() == cmd_key) {
                title = '桥接中';
            }

            return title;
        }

        cmd_key = 'MD5';
        if (cmd_name == cmd_key) {
            var curr_cmd = this.get_cmd_name();

            if (curr_cmd != cmd_key) {
                return 'MD5';
            }
            else {
                return '停止MD5';
            }
        }

        cmd_key = 'COPY';
        if (cmd_name == cmd_key) {
            var curr_cmd = this.get_cmd_name();

            if (curr_cmd != cmd_key) {
                return '复制';
            }
            else {
                return '停止复制';
            }
        }

        return cmd_name;
    },
    get_curr_cmd_title: function(){
        if (!this.is_loaded()) {
            return '(无盘)';
        }

        if (this.is_bridged()) {
            if (this.curr_cmd != null && this.curr_cmd.subcmd == 'STOP') {
                return '停止桥接中';
            }
            return '已桥接';
        }

        var _name = this.get_cmd_name();
        if (_name == 'DISKINFO') {
            return '查询';
        }
        else if (_name == 'BRIDGE') {
            return '桥接';
        }
        else if (_name == 'MD5') {
            return 'MD5';
        }
        else if (_name == 'FILETREE') {
            return '索引';
        }
        else if (_name == 'COPY') {
            if (!this.is_copy_dsk()) {
                return '复制-源';
            }
            else {
                return '复制-目';
            }
        }
        else {
            return '';
        }
    },
    // 依据硬盘状态计算出插槽栏的中文附加描述
    get_extent_title: function () {      
        var ex_title = '';
/*
	var time_text = '';
	var use_time = this.curr_cmd.usedTime;
	if (use_time)
	if (use_time < 60){
		time_text = use_time + 's';
	}
	else if (use_time < 3600){
		time_text = use_time / 60 + 'm';
	}
	else if (use_time < 3600 * 24){
		time_text = use_time / 3600 + 'h';
	}
	else {
		time_text = use_time / 3600 / 24 + 'd';
	}
*/
        if (this.curr_cmd) {
        	var time_text = '';
			var use_time = this.curr_cmd.usedTime;
			if (!use_time){
				return '0s';				
			}
			if (use_time < 60){
				time_text = use_time + 's';
			}
			else if (use_time < 3600){
				time_text = (use_time / 60).toFixed(0) + 'm';
			}
			else if (use_time < 3600 * 24){
			    time_text = (use_time / 3600).toFixed(0) + 'h';
			}
			else {
			    time_text = (use_time / 3600 / 24).toFixed(0) + 'd';
			}    
			ex_title = '' + time_text + ', ' + this.curr_cmd.progress + '%';
        }

        var _name = this.get_cmd_name();
        if (_name == 'DISKINFO' || _name == 'BRIDGE' || _name == 'FILETREE') {
            return ex_title;
        }
        else if (_name == 'MD5') {	
			if (this.curr_cmd.extra_info){
				ex_title += ', ' + this.curr_cmd.extra_info.temp + '℃';
			}
			
            return ex_title;
        }
        else if (_name == 'COPY') {
			if (this.curr_cmd.extra_info) {
				if (this.curr_cmd.srcLevel == (this.l + 1) && this.curr_cmd.srcGroup == (this.g + 1) && this.curr_cmd.srcDisk == (this.d + 1)) {
					ex_title += ', ' + this.curr_cmd.extra_info.src_temp + '℃';
				}
				else {
					ex_title += ', ' + this.curr_cmd.extra_info.dst_temp + '℃';
				}
			}
            return ex_title;
        }
        else {
            return '';
        }
    },
    // 获得当前命令
    get_cmd_name: function () {
		if (!this.base_info.loaded) return '';
		
		if (this.base_info.bridged) {
			if (this.curr_cmd != null && this.curr_cmd.cmd == 'FILETREE') {
				return 'FILETREE';
			}
			else {
				return '';
			}
		}
		else {
			return this.curr_cmd != null ? this.curr_cmd.cmd : '';
		}
    },
    // 判断硬盘是否busy
    is_busy: function () {
        // 不在位硬盘，返回false
        if (!this.base_info.loaded) return false;

        // 已桥接或命令不为空（代表有命令正在执行），返回true
        return this.base_info.bridged || this.get_cmd_name() != '';
    },
    // 获得可能导致命令执行失败的本组中Busy硬盘
    get_busy_disk: function () {
        // 若自身Busy，则返回this
        if (this.is_busy()) {
            return this;
        }

        // 查看本组中其他盘是否Busy
        var sibs = this.get_siblings();
        for (var i in sibs) {
            var _dsk = sibs[i];
            if (_dsk.is_busy()) {
                return _dsk;

            }
        }

        return null;
    },
    // 在执行“复制”命令时，查找可能导致命令执行失败的Busy硬盘
    get_copy_busy_disk: function () {
        //var _sdisk = this.get_busy_disk();
        //if (_sdisk != null) return _sdisk;

        return this.parent.parent.groups[this.g + (this.g % 2 == 0 ? 1 : -1)].disks[0].get_busy_disk();
    },
    // 在执行“桥接”命令时，查找可能导致命令执行失败的Busy硬盘
    get_bridge_busy_disk: function () {
        // 内部总线是否占用
        var _dsk = this.get_busy_disk();
        if (_dsk != null) return _dsk;

        // 外部总线是否占用，即本层是否有硬盘处于桥接状态
        var _lvl = this.parent.parent;
        for (var i = 0; i < _lvl.groups.length; ++i) {
            var _grp = _lvl.groups[i];
            for (var j = 0; j < _grp.disks.length; ++j) {
                var dsk = _grp.disks[j];
                // 1) 已桥接；2）已发出桥接命令
                if (dsk.is_bridged() || (dsk.curr_cmd != null && dsk.curr_cmd.cmd == 'BRIDGE' && dsk.curr_cmd.subcmd == 'START')) {
                    return dsk;
                }
            }
        }
        return null;
    },
    // 命令执行时，构建“硬盘忙”模态框的显示信息
    to_modal_busy_msg: function () {
        var _dsk = this;

        var _msg = '';

        if (_dsk.is_bridged()) {
            _msg += '已经处于桥接状态';
        }
        else {
            _msg += '正在执行[' + _dsk.get_curr_cmd_title() + ']命令';
        }

        _msg += '（需要持续占用总线资源），无法对受本硬盘影响的其他硬盘进行任意操作！';

        return _msg;
    },
    // 根据硬盘状态获得弹出模态框的类型
    get_modal_type: function (btn_type) {
        switch (btn_type) {
            case 'BRIDGE':
                {
                    if (this.is_bridged()) {
                        return 'Stop';
                    }

                    // 如果有桥接Busy硬盘
                    if (this.get_bridge_busy_disk() != null) {
                        return 'Busy';
                    }
                    else {
                        // 判断柜子是否已经桥接了2组以上的硬盘
                        var bridged_cnt = 0;
                        var _lvls = this.parent.parent.parent.levels;
                        for (var i = 0; i < _lvls.length; ++i) {
                            var _grps = _lvls[i].groups;
                            for (var j = 0; j < _grps.length; ++j) {
                                var _dsks = _grps[j].disks;
                                var gb = false;
                                for (var k = 0; k < _dsks.length; ++k) {
                                    var _dsk = _dsks[k];                                  
                                    if (_dsk.is_bridged()) {
                                        gb = true;
                                        break;
                                    }
                                }
                                if (gb) {
                                    bridged_cnt++;
                                    break;
                                }
                            }
                        }
						
						if (bridged_cnt >= 2){
							return 'TwoBridgedBusy';
						}
						else{
							if (this.detail_info.SN && this.detail_info.SN != ''){
								return 'Start';
							}
							else{
								return 'NoSN';
							}
						}
                    }
                }
                break;
            case 'COPY':
                {
                    if (this.curr_cmd != null && this.curr_cmd.cmd == 'COPY') {
                        return 'Stop';
                    }

                    // 如果有复制Busy硬盘
                    if (this.get_copy_busy_disk() != null) {
                        return 'Busy';
                    }
                    else {
                        return 'Start';
                    }
                }
                break;
            case 'DISKINFO':
                {
                    if (this.get_busy_disk() != null) {
                        return 'Busy';
                    }
                    else {
                        return 'Start';
                    }
                }
                break;
            case 'MD5':
                {
                    if (this.curr_cmd != null && this.curr_cmd.cmd == 'MD5') {
                        return 'Stop';
                    }

                    if (this.get_busy_disk() != null) {
                        return 'Busy';
                    }
                    else {
                        return 'Start';
                    }
                }
                break;
            default:
                break;
        }
        return '';
    },
    // 获得邻居硬盘
    get_siblings: function () {
        return this.parent.disks;
    },
    // 判断是否可执行“桥接”命令
    can_bridge: function () {
        for (var i = 0; i < this.parent.disks.length; ++i) {
            if (this.parent.disks[i].isto_bridge) return true;
        }
        return false;
    },
    get_copy_disk:function(){
        return this.get_copy_disks()[parseInt(copy_disk)];
    },
    // 用于辅助“复制”命令执行，查找可匹配的目的/源硬盘集合
    get_copy_disks: function () {
        return this.parent.parent.groups[this.g + (this.g % 2 == 0 ? 1 : -1)].disks;
    },
    // 用于发送“查询”、“桥接”、“MD5”和“复制”命令的“START”子命令
    cmd_start: function (cmd_name) {
        if (this.get_cmd_error() != '') {
            return false;
        }

        if (this.curr_cmd) {
            console.log('Disk Busy: ' + this.curr_cmd.cmd);
            return;
        }

        var cmd_obj = { cmd: cmd_name };

        if (cmd_name == 'DISKINFO') {
            cmd_obj.level = (this.l + 1).toString();
            cmd_obj.group = (this.g + 1).toString();
            cmd_obj.disk = (this.d + 1).toString();
        }
        else if (cmd_name == 'BRIDGE') {
            cmd_obj.subcmd = 'START';
            cmd_obj.level = (this.l + 1).toString();
            cmd_obj.group = (this.g + 1).toString();

            cmd_obj.disks = [];
            for (var x in this.parent.disks) {
                var _dsk = this.parent.disks[x];
                if (_dsk.is_loaded() && _dsk.isto_bridge) {
                    var disk_obj = {
                        id: (_dsk.d + 1).toString(),
                        SN: _dsk.get_SN()
                    };
                    cmd_obj.disks.push(disk_obj);
                }
            }
            if (cmd_obj.disks.length == 0) {
                return false;
            }
        }
        else if(cmd_name == 'WRITEPROTECT')
        {
            cmd_obj.subcmd = 'START';
            cmd_obj.level = (this.l + 1).toString();
        }
        else if (cmd_name == 'MD5') {
            cmd_obj.subcmd = 'START';
            cmd_obj.level = (this.l + 1).toString();
            cmd_obj.group = (this.g + 1).toString();
            cmd_obj.disk = (this.d + 1).toString();
			
			// 构建DISKINFO命令，并将MD5命令缓存 -- 作废
			/*
			var cmd_queue_item = {};
			angular.copy(cmd_obj, cmd_queue_item);
			this.cmd_queue.push(cmd_queue_item);
			cmd_obj.cmd = 'DISKINFO';
			*/
        }
        else if (cmd_name == 'COPY') {
            cmd_obj.subcmd = 'START';

            // 源盘
            if (this.copy_src_or_dst == 'src') {
                cmd_obj.srcLevel = (this.l + 1).toString();
                cmd_obj.srcGroup = (this.g + 1).toString();
                cmd_obj.srcDisk = (this.d + 1).toString();

                if (this.copy_disk == null) {
                    return false;
                }

                var _dsk = this.get_copy_disks()[this.copy_disk];
                cmd_obj.dstLevel = (_dsk.l + 1).toString();
                cmd_obj.dstGroup = (_dsk.g + 1).toString();
                cmd_obj.dstDisk = (_dsk.d + 1).toString();
            }
            else {
                cmd_obj.dstLevel = (this.l + 1).toString();
                cmd_obj.dstGroup = (this.g + 1).toString();
                cmd_obj.dstDisk = (this.d + 1).toString();

                if (this.copy_disk == null) {
                    return false;
                }

                var _dsk = this.get_copy_disks()[this.copy_disk];
                cmd_obj.srcLevel = (_dsk.l + 1).toString();
                cmd_obj.srcGroup = (_dsk.g + 1).toString();
                cmd_obj.srcDisk = (_dsk.d + 1).toString();
            }
        }
        else if (cmd_name == 'FILETREE') {
            cmd_obj.subcmd = 'START';
            cmd_obj.level = (this.l + 1).toString();
            cmd_obj.group = (this.g + 1).toString();
            cmd_obj.disk = (this.d + 1).toString();
            cmd_obj.mount_path = this.get_cabinet_sn() + '_' + cmd_obj.level + '_' + cmd_obj.group + '_' + cmd_obj.disk;
        }
        else {
            return false;
        }


        // send cmd;
        // 需要二次验证
        if (cmd_name == 'COPY') {
            global_user.show_second_pwd_modal_with_action(function (obj) {
        //        this.curr_cmd = cmd_obj;
                global_cmd_helper.sendcmd(obj);
            }, cmd_obj);
        }
        else {
        //    this.curr_cmd = cmd_obj;

    	    var mid = global_modal_helper.get_curr_id();
	        global_modal_helper.close_modal(mid);

			global_cmd_helper.sendcmd(cmd_obj);				
        }

        return true;
    },
    // 用于发送“MD5”和“复制”命令的“STOP”子命令
    cmd_stop: function () {
        $.magnificPopup.close();
		
        if (this.curr_cmd && this.curr_cmd.subcmd == 'STOP'){
            return;
        }

        var cmd_obj = null;
        if (this.is_bridged()) {
            var disk_array = [];
            var disks = this.get_siblings();
            for (var i = 0; i < disks.length; ++i) {
                if (disks[i].is_bridged()) {
                    disk_array.push({
                        id: (disks[i].d + 1).toString(),
						SN: 'AA'
                        //SN: disks[i].get_SN()
                    });
                }
            }

            cmd_obj = {
                cmd: 'BRIDGE',
                subcmd: 'STOP',
                level: (this.l + 1).toString(),
                group: (this.g + 1).toString(),
                disks: disk_array
            };
        }
        else {
            cmd_obj = JSON.parse(this.curr_cmd.msgStr);
            cmd_obj.subcmd = 'STOP';
        }

        this.curr_cmd = cmd_obj;

        global_cmd_helper.sendcmd(cmd_obj);
    }
};
