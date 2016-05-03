// 硬盘Disk类的构造函数
function Disk(l, g, d) {
    // l：层索引；g：组索引；d：位索引
    // 索引下标均为0
    this.l = l;
    this.g = g;
    this.d = d;

    // 温度
    this.temperature = '-';
    // 是否写保护
    this.write_protected = true,

    // 用于辅助执行“桥接”命令时，标志硬盘是否被选中
    this.isto_bridge = false;
    // 用于辅助执行“复制”命令时，指定另一块目的/源硬盘对象
    this.copy_disk = null;
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
                return '查询';
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
        else if (_name == 'COPY') {
            return '复制-' + (this.g % 2 == 0 ? '源' : '目');
        }
        else {
            return '';
        }
    },
    // 依据硬盘状态计算出插槽栏的中文附加描述
    get_extent_title: function () {        
        var _name = this.get_cmd_name();
        if (_name == 'DISKINFO' || _name == 'BRIDGE') {
            return this.curr_cmd.usedTime + 's';
        }
        else if (_name == 'MD5' || _name == 'COPY') {
            return this.curr_cmd.progress + '%，' + this.temperature + '℃';
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
            _msg += '正在执行[' + _dsk.get_curr_cmd_title() + ']命令';
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
                                    if (_dsk.is_bridged() || _dsk.curr_cmd.cmd == 'BRIDGE') {
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

                        return bridged_cnt>=2? 'TwoBridgedBusy':'Start';
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
        global_cmd_helper.sendcmd(cmd_obj);

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

        global_cmd_helper.sendcmd(cmd_obj);

        //console.log(cmd_obj);

        $.magnificPopup.close();
    }
};
