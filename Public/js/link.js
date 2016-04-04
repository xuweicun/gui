/**
 * Created by link on 2016/3/23.
 */
'use strict';

var sparklineLineVisitsData = [15, 16, 17, 19, 15, 25, 23, 35, 29, 15, 30, 45];

var app = angular.module('link_app', []);

app.controller('link_ctrl', function($scope){
    $scope.cab = {
        // 当前选中的硬盘对象
        curr: null,
        // 存储柜所有层集合，用于存放存储所有相关数据
        levels: [],

        /*
        工厂方法，用于生成标准的硬盘对象，
        其中l代表层索引，起始下标为0；
        g代表组索引，起始下标为0；
        d代表位索引，起始下标为0；
        */
        make_disk: function (l, g, d) {
            // 设置默认的“硬盘信息”命令超时时间
            var timeout_diskinfo = 45;
            // 设置默认的“桥接”命令超时时间
            var timeout_bridge = 180;

            return {
                // l：层索引；g：组索引；d：位索引
                // 索引下标均为0
                l: l, g: g, d: d,
                // 用于辅助执行“桥接”命令时，标志硬盘是否被选中
                isto_bridge: false,
                // 用于辅助执行“复制”命令时，指定另一块目的/源硬盘对象
                copy_disk: null,
                // 硬盘基本信息集合
                base_info:{
                    // 是否在位
                    loaded:false,
                    // 是否写保护
                    write_protected:false,
                    // 是否桥接
                    bridged:false,
                    // 已桥接状态的mount文件夹名
                    bridge_path:''
                },
                // 硬盘详细信息集合
                detail_info:{
                    // 硬盘容量，单位G
                    capacity : 0,
                    // 序列号
                    SN:'',
                    // smart属性
                    smarts:[
                    {
                        id : '00',
                        current_value : "00",
                        data: "00 00 00 00",
                        ext_data: "00 00",
                        threshold: "00",
                        worst_value: "00"
                    }
                    ]
                },
                // 硬盘正在执行的命令信息
                cmd_info: {
                    // 命令对象，即通过sendcmd()接口发出的json格式命令，
                    // cmd_obj对象是前端进行逻辑判断的基准，如果设置错误将导致整个前端混乱
                    // 因此，处理这个cmd_obj对象时，需要格外小心，尤其是在页面加载，cab初始
                    // 化的过程中。
                    // 注：任何时候、任一与本硬盘相关的执行类命令都需要赋值给cmd_obj对象
                    cmd_obj: null,
                    // 命令超时时间，如桥接、硬盘信息查询等命令
                    lefttime: 0,
                    // 命令执行进度，如MD5、复制等命令
                    progress : 0
                },
                
                // 判断是否在位
                is_loaded: function () { return this.base_info.loaded; },
                // 判断是否已桥接
                is_bridged: function () { return this.base_info.loaded && this.base_info.bridged; },
                // 获得硬盘位置描述，如1-1-1#等
                get_title: function () { return (this.l + 1) + '-' + (this.g + 1) + '-' + (this.d + 1) + ' #'; },

                // 获得硬盘容量大小，单位GB
                get_capacity: function () { return this.base_info.loaded ? this.detail_info.capacity : 0; },
                // 获得硬盘序列号
                get_SN: function () { return this.base_info.loaded ? this.detail_info.SN : ''; },

                // 依据硬盘状态计算出命令按钮的中文描述
                to_cmd_cn : function(cmd_name){
                    var title = '';
                    var cmd_key = '';

                    cmd_key = 'DISKINFO';
                    if(cmd_name == cmd_key){
                        title = '查询';
                        if(!this.is_loaded() || (this.get_cmd_name() == '' && this.get_cmd_name() != cmd_key)){
                            return title;
                        }

                        // 当前有命令在执行
                        if (this.get_cmd_name() == cmd_key){
                            title = '正在'+title+'('+ this.cmd_info.lefttime +'秒)'
                        }

                        return title;
                    }

                    cmd_key = 'BRIDGE';
                    if(cmd_name == cmd_key){
                        title = '桥接';
                        if(this.is_bridged()){
                            return '停止桥接';
                        }

                        // 当前有命令在执行
                        if (this.get_cmd_name() == cmd_key){
                            title = '正在'+title+'('+ this.cmd_info.lefttime +'秒)';
                        }

                        return title;
                    }

                    cmd_key = 'MD5';
                    if(cmd_name == cmd_key) {
                        var curr_cmd = this.get_cmd_name();

                        if (curr_cmd != cmd_key){
                            return 'MD5';
                        }
                        else{
                            return '停止MD5('+ this.cmd_info.progress +'%)';
                        }
                    }

                    cmd_key = 'COPY';
                    if(cmd_name == cmd_key) {
                        var curr_cmd = this.get_cmd_name();

                        if (curr_cmd != cmd_key){
                            return '复制';
                        }
                        else{
                            return '停止复制('+ this.cmd_info.progress +'%)';
                        }
                    }

                    return cmd_name;
                },

                // 依据硬盘状态计算出插槽栏的中文附加描述
                to_name_cn: function () {
                    var _name = this.get_cmd_name();
                    if(_name == 'DISKINFO'){
                        return '查询';
                    }
                    else if(_name == 'BRIDGE'){
                        return '桥接';
                    }
                    else if(_name == 'MD5'){
                        return 'MD5';
                    }
                    else if(_name == 'COPY'){
                        return '复制[' + (this.g%2==0?'源':'目的') + ']';
                    }
                    else{
                        return '';
                    }
                },
                // 获得当前命令
                get_cmd_name: function () { return (this.base_info.loaded && !this.base_info.bridged && this.cmd_info.cmd_obj != null) ? this.cmd_info.cmd_obj.cmd : ''; },
                // 判断硬盘是否busy
                is_busy: function () {
                    // 不在位硬盘，返回false
                    if (!this.base_info.loaded) return false;

                    // 已桥接或命令不为空（代表有命令正在执行），返回true
                    return this.base_info.bridged || this.get_cmd_name() != '';
                },
                // 在执行“复制”命令时，查找可能导致命令执行失败的Busy硬盘
                get_copy_busy_disk: function () {
                    var _sdisk = this.parent.get_busy_disk();
                    if (_sdisk != null) return _sdisk;

                    var _bdisk = this.parent.parent.groups[this.g + (this.g % 2 == 0 ? 1 : -1)].get_busy_disk();
                    this.busy_disk_copy = _bdisk;
                    return _bdisk;
                },
                // 获得邻居硬盘
                get_siblings : function(){
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
                get_copy_disks : function(){
                    return this.parent.parent.groups[this.g + (this.g%2==0?1:-1)].disks;
                },
                // 用于发送“查询”、“桥接”、“MD5”和“复制”命令的“START”子命令
                cmd_start : function(cmd_name){
                    var cmd_obj = { cmd: cmd_name };
                    this.cmd_info.cmd_obj = cmd_obj;

                    if (cmd_name == 'DISKINFO'){
                        cmd_obj.level = (this.l+1).toString();
                        cmd_obj.group = (this.g+1).toString();
                        cmd_obj.disk = (this.d + 1).toString();

                        this.cmd_info.lefttime = timeout_diskinfo;
                    }
                    else if(cmd_name == 'BRIDGE'){
                        cmd_obj.subcmd = 'START';
                        cmd_obj.level = (this.l+1).toString();
                        cmd_obj.group = (this.g + 1).toString();
                        this.cmd_info.lefttime = timeout_bridge;

                        cmd_obj.disks = [];
                        for(var x in this.parent.disks){
                            var _dsk = this.parent.disks[x];
                            if(_dsk.is_loaded() && _dsk.isto_bridge){
                                var disk_obj = {
                                    id : (_dsk.d+1).toString(),
                                    get_SN : _dsk.get_SN()
                                };
                                cmd_obj.disks.push(disk_obj);

                                if (_dsk !== this) {
                                    _dsk.cmd_info.cmd_obj = cmd_obj;
                                    _dsk.cmd_info.lefttime = timeout_bridge;
                                }
                            }
                        }
                        if(cmd_obj.disks.length == 0){
                            return false;
                        }
                    }
                    else if(cmd_name == 'MD5'){
                        cmd_obj.subcmd = 'START';
                        cmd_obj.level = (this.l+1).toString();
                        cmd_obj.group = (this.g+1).toString();
                        cmd_obj.disk = (this.d+1).toString();
                    }
                    else if(cmd_name == 'COPY'){
                        cmd_obj.subcmd = 'START';
                        this.cmd_info.progress = 0;

                        // 源盘
                        if (this.g % 2 == 0){
                            cmd_obj.srcLevel = (this.l+1).toString();
                            cmd_obj.srcGroup = (this.g+1).toString();
                            cmd_obj.srcDisk = (this.d+1).toString();

                            if (this.copy_disk == null) {
                                new PNotify({
                                    title: '失败!',
                                    text: '没有选择目标硬盘.',
                                    type: 'error'
                                });
                                return false;
                            }

                            var _dsk = this.get_copy_disks()[this.copy_disk];
                            cmd_obj.dstLevel = (_dsk.l+1).toString();
                            cmd_obj.dstGroup = (_dsk.g+1).toString();
                            cmd_obj.dstDisk = (_dsk.d + 1).toString();
                            _dsk.cmd_info.cmd_obj = cmd_obj;
                            _dsk.cmd_info.progress = 0;
                        }
                        else{
                            cmd_obj.dstLevel = (this.l+1).toString();
                            cmd_obj.dstGroup = (this.g+1).toString();
                            cmd_obj.dstDisk = (this.d+1).toString();

                            if (this.copy_disk == null) {
                                new PNotify({
                                    title: '失败!',
                                    text: '没有选择源硬盘.',
                                    type: 'error'
                                });
                                return false;
                            }

                            var _dsk = this.get_copy_disks()[this.copy_disk];
                            cmd_obj.srcLevel = (_dsk.l+1).toString();
                            cmd_obj.srcGroup = (_dsk.g+1).toString();
                            cmd_obj.srcDisk = (_dsk.d + 1).toString();
                            _dsk.cmd_info.cmd_obj = cmd_obj;
                            _dsk.cmd_info.progress = 0;
                        }
                    }

                    // send cmd;
                    console.log(cmd_obj);

                    $.magnificPopup.close();

                    new PNotify({
                        title: '提交命令!',
                        text: '成功提交开始命令至服务器。',
                        type: 'success'
                    });
                    return true;
                },
                // 用于发送“MD5”和“复制”命令的“STOP”子命令
                cmd_stop: function () {
                    var cmd_obj;
                    if (this.base_info.bridged) {
                        cmd_obj = {
                            cmd: 'BRIDGE',
                            subcmd: 'STOP',
                            level: this.l,
                            group: this.g,
                            disks: [
                                {
                                    id: this.d.toString(),
                                    SN: ''
                                }
                            ]
                        };

                        this.base_info.bridged = false;

                        new PNotify({
                            title: '提交命令!',
                            text: '提交“停止桥接”命令成功。',
                            type: 'success'
                        });
                    }
                    else {
                        cmd_obj = this.cmd_info.cmd_obj;
                        if (cmd_obj != null && cmd_obj.subcmd != null) {
                            cmd_obj.subcmd = 'STOP';

                            if (cmd_obj.cmd == 'COPY') {
                                this.parent.parent.groups[parseInt(cmd_obj.srcGroup) - 1].disks[parseInt(cmd_obj.srcDisk) - 1].cmd_info.cmd_obj = null;
                                this.parent.parent.groups[parseInt(cmd_obj.dstGroup) - 1].disks[parseInt(cmd_obj.dstDisk) - 1].cmd_info.cmd_obj = null;
                            }

                            this.cmd_info.cmd_obj = null;

                            // send stop cmd

                            new PNotify({
                                title: '提交命令!',
                                text: '提交“停止'+this.to_name_cn()+'”命令成功。',
                                type: 'success'
                            });
                        }
                    }
                    console.log(cmd_obj);

                    $.magnificPopup.close();
                }
            };
        },
        // 初始化存储柜的插槽信息
        init : function (level_cnt, group_cnt, disk_cnt) {
            for(var i=0;i<level_cnt;++i){
                // 每一层
                var level_obj = { groups : [] };
                for(var j=0;j<group_cnt;++j){
                    // 每一组
                    var group_obj = {
                        disks : [],
                        get_busy_disk : function(){
                            var _dsk = null;
                            for (var i=0; i<this.disks.length; ++i){
                                if (this.disks[i].is_busy()){
                                    _dsk = this.disks[i];
                                }
                            }

                            for (var i=0; i<this.disks.length; ++i){
                                this.disks[i].busy_disk = _dsk;
                            }

                            return _dsk;
                        }
                    };
                    for(var k=0;k<disk_cnt;++k){
                        var disk_obj = this.make_disk(i,j,k);
                        disk_obj.parent = group_obj;
                        group_obj.disks.push(disk_obj);
                    }

                    group_obj.parent = level_obj;
                    level_obj.groups.push(group_obj);
                }
                this.levels.push(level_obj);
            }

            this.select_disk(0,0,0);
        },
        // 用于支持前端对存储柜选择硬盘
        select_disk: function (l, g, d) {
            this.curr = this.levels[l].groups[g].disks[d];
            this.curr.get_copy_busy_disk();
        },

        // 接口：用于接收CmdPool的命令Resp推送
        on_cmd_resp: function (json_cmd) { },
        // 接口：用于接收CmdPool的每秒一次的时间激励
        on_time_second: function () { }
    };

    $scope.cab.init(6, 6, 4);

    $('.modal-with-move-anim').magnificPopup({
        type: 'inline',

        fixedContentPos: false,
        fixedBgPos: true,

        overflowY: 'auto',

        closeBtnInside: true,
        preloader: false,

        midClick: true,
        removalDelay: 300,
        mainClass: 'my-mfp-slide-bottom',
        modal: true,

        callbacks:{
            beforeOpen:function(){
                $scope.cab.curr.copy_disk = null;
            }
        }
    });

    $(document).on('click', '.modal-dismiss', function (e) {
        e.preventDefault();
        $.magnificPopup.close();
    });

    /*
     Modal Confirm
     */
    $(document).on('click', '.modal-confirm', function (e) {
        e.preventDefault();
        $.magnificPopup.close();

        new PNotify({
            title: '成功!',
            text: '提交命令到服务器.',
            type: 'success'
        });
    });
    $scope.apples = [1,2,3,4,5,6];

    var test = function(){
        var disk;
        disk = $scope.cab.levels[0].groups[0].disks[0];
        disk.base_info.loaded = true;
        disk.base_info.bridged = true;
        disk.detail_info.capacity = 80;
        disk.detail_info.SN = '123456';

        disk = $scope.cab.levels[0].groups[0].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 120;
        disk.detail_info.SN = 'abcdef';

        disk = $scope.cab.levels[0].groups[1].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaaaaa';
        disk.cmd_info.cmd='DISKINFO';
        disk.cmd_info.lefttime=32;

        disk = $scope.cab.levels[0].groups[1].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 1050;
        disk.detail_info.SN = 'daaaaa';


        disk = $scope.cab.levels[0].groups[2].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 1150;
        disk.detail_info.SN = 'daaaaa1';

        disk = $scope.cab.levels[0].groups[2].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 500;
        disk.detail_info.SN = 'aaaaab';
        disk.cmd_info.cmd = 'BRIDGE';
        disk.cmd_info.lefttime = 54;

        disk = $scope.cab.levels[0].groups[3].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 1150;
        disk.detail_info.SN = 'daaaaa1';
        disk = $scope.cab.levels[0].groups[3].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaaaac';
        disk.cmd_info.cmd = 'MD5';
        disk.cmd_info.progress = 36.5;

        disk = $scope.cab.levels[0].groups[4].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaabaa';

        disk = $scope.cab.levels[0].groups[4].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaabba';
        disk.cmd_info.cmd = 'COPY';
        disk.cmd_info.progress = 13.1;

        disk = $scope.cab.levels[0].groups[5].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaacaa';
        disk = $scope.cab.levels[0].groups[5].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 251;
        disk.detail_info.SN = 'aaacaa1';
        disk = $scope.cab.levels[0].groups[5].disks[2];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 252;
        disk.detail_info.SN = 'aaacaa2';
        disk = $scope.cab.levels[0].groups[5].disks[3];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 253;
        disk.detail_info.SN = 'aaacaa3';
        disk.cmd_info.cmd = 'COPY';
        disk.cmd_info.progress = 13.1;

        disk = $scope.cab.levels[1].groups[0].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 120;
        disk.detail_info.SN = 'abcdef';
        disk.cmd_info.cmd = 'COPY';
        disk.cmd_info.progress = 32;

        disk = $scope.cab.levels[1].groups[1].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaaaaa';
        disk.cmd_info.cmd = 'COPY';
        disk.cmd_info.progress = 32;


        disk = $scope.cab.levels[1].groups[2].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 120;
        disk.detail_info.SN = 'abcdef';

        disk = $scope.cab.levels[1].groups[3].disks[0];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaaaaa';

        disk = $scope.cab.levels[1].groups[3].disks[1];
        disk.base_info.loaded = true;
        disk.detail_info.capacity = 250;
        disk.detail_info.SN = 'aaaaaade';
    };

    test();


});
