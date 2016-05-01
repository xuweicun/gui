function link_send_cmd(json_cmd) {
    global_cmd_helper.sendcmd(json_cmd);
}

// 硬盘Disk类的构造函数
function Disk(l, g, d) {
    // l：层索引；g：组索引；d：位索引
    // 索引下标均为0
    this.l = l;
    this.g = g;
    this.d = d;

    // 用于辅助执行“桥接”命令时，标志硬盘是否被选中
    this.isto_bridge = false;
    // 用于辅助执行“复制”命令时，指定另一块目的/源硬盘对象
    this.copy_disk = null;
    // 硬盘基本信息集合
    this.base_info = {
        // 是否在位
        loaded: false,
        // 是否写保护
        write_protected: false,
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
}

// 硬盘Disk类的原型
Disk.prototype = {
    // 用户提交命令
    cmd_commit: function (cmd_name) {
        this.clear_status();
        if (cmd_name != 'DISKINFO' && cmd_name != 'BRIDGE' && cmd_name != 'MD5' && cmd_name != 'COPY') {

            console.log('unknown cmd = ' + cmd_name);
            return;
        }

        if (cmd_name == 'DISKINFO' || cmd_name == 'MD5') {
            var bdsk = this.get_busy_disk();
            if (bdsk != null) this.busy_disk = bdsk;
        }
        else if (cmd_name == 'COPY') {
            var bdsk = this.get_copy_busy_disk();
            if (bdsk != null) this.busy_disk = bdsk;
        }
        else if (cmd_name == 'BRIDGE') {
            var bdsk = this.get_bridge_busy_disk();
            if (bdsk != null) this.busy_disk = bdsk;
        }


        if (cmd_name == 'BRIDGE') {
            this.isto_bridge = true;
        }

        this.cmd_name_to_commit = cmd_name;
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

    // 获得命令中文名
    get_commit_cmd_title: function () {
        switch (this.cmd_name_to_commit) {
            case 'DISKINFO':
                return '桥接';
            case 'BRIDGE':
                return '桥接';
            case 'MD5':
                return 'MD5';
            case 'COPY':
                return '复制';
            default:
                return '未知';
        }
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
    // 依据硬盘状态计算出插槽栏的中文附加描述
    get_extent_title: function () {
        if (!this.is_loaded()) {
            return '(无盘)';
        }

        if (this.is_bridged()) {
            if (this.curr_cmd != null && this.curr_cmd.subcmd == 'STOP') {
                return '停止桥接中(' + this.curr_cmd.usedTime + 's)';
            }
            return '已桥接';
        }

        var _name = this.get_cmd_name();
        if (_name == 'DISKINFO') {
            return '查询';
        }
        else if (_name == 'BRIDGE') {
            return '桥接(' + this.curr_cmd.usedTime + 's)';
        }
        else if (_name == 'MD5') {
            return 'MD5(' + this.curr_cmd.progress + '%)';
        }
        else if (_name == 'COPY') {
            return '复制-' + (this.g % 2 == 0 ? '源' : '目') + '(' + this.curr_cmd.progress + '%)';
        }
        else {
            return '';
        }
    },
    // 获得当前命令
    get_cmd_name: function () {
        return (this.base_info.loaded && !this.base_info.bridged && this.curr_cmd != null) ? this.curr_cmd.cmd : '';
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
        var _sdisk = this.get_busy_disk();
        if (_sdisk != null) return _sdisk;

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
        var _dsk = this.busy_disk;
        if (_dsk == null) return '';

        var _msg = '';

        if (_dsk.is_bridged()) {
            _msg += '已经处于桥接状态';
        }
        else {
            _msg += '正在执行[' + _dsk.get_extent_title() + ']命令';
        }

        _msg += '（需要持续占用总线资源），无法对该组内的硬盘进行其他操作！';

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
                        return 'Start';
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
    // 用于辅助“复制”命令执行，查找可匹配的目的/源硬盘集合
    get_copy_disks: function () {
        return this.parent.parent.groups[this.g + (this.g % 2 == 0 ? 1 : -1)].disks;
    },
    // 用于发送“查询”、“桥接”、“MD5”和“复制”命令的“START”子命令
    cmd_start: function (cmd_name) {
        if (this.get_cmd_error() != '') {
            return false;
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
        else if (cmd_name == 'MD5') {
            cmd_obj.subcmd = 'START';
            cmd_obj.level = (this.l + 1).toString();
            cmd_obj.group = (this.g + 1).toString();
            cmd_obj.disk = (this.d + 1).toString();
        }
        else if (cmd_name == 'COPY') {
            cmd_obj.subcmd = 'START';

            // 源盘
            if (this.g % 2 == 0) {
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
                _dsk.curr_cmd = cmd_obj;
                _dsk.curr_cmd.progress = 0;
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
                _dsk.curr_cmd = cmd_obj;
            }
        }
        else if (cmd_name == 'FILETREE') {
            cmd_obj.subcmd = 'START';
            cmd_obj.level = (this.l + 1).toString();
            cmd_obj.group = (this.g + 1).toString();
            cmd_obj.disk = (this.d + 1).toString();
            cmd_obj.mount_path = this.base_info.bridge_path;
        }
        else {
            return false;
        }

        // send cmd;
        link_send_cmd(cmd_obj);

        $.magnificPopup.close();

        //console.log(cmd_obj);
        return true;
    },
    // 用于发送“MD5”和“复制”命令的“STOP”子命令
    cmd_stop: function () {
        var cmd_obj = null;
        if (this.is_bridged()) {
            var disk_array = [];
            var disks = this.get_siblings();
            for (var i = 0; i < disks.length; ++i) {
                if (disks[i].is_bridged()) {
                    disk_array.push({
                        id: (disks[i].d + 1).toString(),
                        SN: disks[i].get_SN()
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

        link_send_cmd(cmd_obj);

        //console.log(cmd_obj);

        $.magnificPopup.close();
    }
};

// 柜子Cabinet类的构造函数
function Cabinet() {
    // 柜子ID，用于支持多个柜子
    this.id = -1;
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
    // 电压
    this.voltage = 0;
    // 电流
    this.current = 0;
    // 电量
    this.electricity = 0;
    // 温度
    this.temperature = 0;
    // 湿度
    this.humidity = 0;
}


// 柜子Cabinet类的原型
Cabinet.prototype = {
    // 初始化存储柜的插槽信息
    i_on_init: function (id, level_cnt, group_cnt, disk_cnt) {
        this.id = id;
        this.lvl_cnt = level_cnt;
        this.grp_cnt = group_cnt;
        this.dsk_cnt = disk_cnt;
        for (var i = 0; i < level_cnt; ++i) {
            // 每一层
            var level_obj = { groups: [] };
            for (var j = 0; j < group_cnt; ++j) {
                // 每一组
                var group_obj = {
                    disks: []
                };
                for (var k = 0; k < disk_cnt; ++k) {
                    var disk_obj = new Disk(i, j, k);
                    disk_obj.parent = group_obj;
                    group_obj.disks.push(disk_obj);
                }

                group_obj.parent = level_obj;
                level_obj.groups.push(group_obj);
            }
            this.levels.push(level_obj);
        }

        this.select_disk(0, 0, 0);
        this.ready = true;
    },
    // 获得在位信息
    start_cmd_device_status: function () {
        if (this.id <= 0) return;

        var json_cmd = {
            cmd: 'DEVICESTATUS',
            device_id: this.id.toString()
        };

        link_send_cmd(json_cmd);

        $.magnificPopup.close();
    },
    get_select: function () {
        this.selected = true;
    },
    // 用于支持前端对存储柜选择硬盘
    select_disk: function (l, g, d) {
        this.curr = this.levels[l].groups[g].disks[d];
        this.curr.get_copy_busy_disk();

        console.log(this.curr);
    },
    //获取某块盘的指针
    i_get_disk: function (l, g, d) {
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

    // 接口：激励，加载柜子基本信息，如在位、桥接等，参数data为'/index.php?m=admin&c=business&a=getDeviceInfo'返回值
    i_load_disks_base_info: function (data) {
        for (var i = 0; i < data.length; ++i) {
            var e = data[i];
            var int_l = parseInt(e.level) - 1;
            var int_g = parseInt(e.zu) - 1;
            var int_d = parseInt(e.disk) - 1;

            if (int_l < 0 || int_l > 6) {
                console.log("load_disks(): Invalid param 'Level'");
                continue;
            }
            if (int_g < 0 || int_g > 6) {
                console.log("load_disks(): Invalid param 'Group'");
                continue;
            }
            if (int_d < 0 || int_d > 4) {
                console.log("load_disks(): Invalid param 'Disk'");
                continue;
            }

            var _dsk = this.levels[int_l].groups[int_g].disks[int_d];
            // 在位置位
            _dsk.base_info.loaded = (e.loaded == 1);
            _dsk.base_info.bridged = e.bridged == 1;
            // 桥接置位
            if (e.bridged == 1) {
                _dsk.base_info.bridge_path = e.path;

            }
            _dsk.detail_info.SN = e.sn;
            _dsk.detail_info.MD5 = e.md5;
            _dsk.detail_info.capacity = e.capacity;
        }
    },

    // 接口：激励，当命令集合添加或移除一条命令时触发，当增加时bol_op为true，代表add；当移除时，bol_op为false,代表remove
    i_on_cmd_changed: function (json_cmd, bol_op) {
        console.log(bol_op?'add':'remove', json_cmd);
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
            default:
                {
                    console.log('Unknown Cmd');
                    console.log(json_cmd.cmd);
                    break;
                }
        }
    }

};