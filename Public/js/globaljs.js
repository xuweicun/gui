angular.module('device.controllers', [])
    .controller('statusMonitor', function ($scope, $http, $interval) {
        //服务器错误信息池，格式[{errMsg:'err'},{errMsg:'err'}]
        var Cmd = {};
        Cmd.createCmd = function (msg) {
            var newcmd = {
                id: msg.CMD_ID,
                cmd: msg.cmd,
                subcmd: msg.subcmd,
                //正在进行命令的status取值
                going: -1,
                //已经取消命令的status取值
                canceled: -2,
                //超时命令的status值
                timeout: -3,
                //level和group是通用值，多数命令都用到
                level: msg.level,
                group: msg.group,
                //disks对于桥接命令有意义，其内部为[{id:1,sn:2},{id:2,sn:3}]的格式，具体可参考通讯协议
                disks: msg.disks,
                //src和dst仅对拷贝命令有意义
                srcDisk: msg.srcDisk,
                srcLevel: msg.srcGroup,
                srcGroup: msg.srcLevel,
                dstDisk: msg.dstDisk,
                dstLevel: msg.dstLevel,
                dstGroup: msg.dstDisk,
                //MD5、diskinfo等命令中，disk值有效
                disk: msg.disk,
                //命令状态，初始值为-1
                status: this.going,
                //剩余时间，为0时表示时间用完
                usedTime: 0,
                progress: 0,
                //最大等待时间，300秒
                maxTime: 300,
                //最小等待时间，120秒
                minTime: 120,
                //错误信息
                errMsg: '',
                init: function () {
                    //根据命令名称判断
                    switch (this.cmd) {
                        case 'BRIDGE':
                            if (this.subcmd == 'START') {
                                this.usedTime = this.maxTime;
                            }
                            else {
                                this.usedTime = this.minTime;
                            }
                            break;
                        default:
                            this.usedTime = this.minTime;
                            break;
                    }
                },
                setStatus: function (status) {
                    this.status = status;
                    if (status == 0 || status == this.canceled) {
                        return;
                    }
                    ///如果出错
                    switch (status) {
                        case this.timeout:
                            this.errMsg = "命令执行超时，请联系维护人员处理。";
                            break;
                        default:
                            this.errMsg = $scope.errCodes.codes[status.toString()];
                    }

                }
            };
            newcmd.init();
            return newcmd;
        }
        Cmd.checkCollision = function () {
            $http({
                url: 'http://localhost/index.php/business/checkCollision',

                method: 'GET'
            }).success(function (data) {
                return data['isLegal'];
            });
        }
        Cmd.getdiskinfo = function (level, group, disk, type) {
            var disk = $scope.disk;
            $scope.bridgeReady = 0;
            if (type > 0) {//手动初始化
                $scope.diskinfo(disk.level.toString(), disk.group.toString(), disk.index.toString());
                var $diskInfoTimer = 0;
                var diskInfoStatus = $interval(function () {
                    $diskInfoTimer++;
                    if ($diskInfoTimer > 24) {
                        $interval.cancel(diskInfoStatus);//超过2分钟即认为失败。
                    }
                    $http({
                        url: '/index.php?m=admin&c=business&a=getDiskInfo&type=1',
                        data: {level: disk.level, group: disk.group, disk: disk.index, maxtime: 0, type: type},
                        method: 'POST'
                    }).success(function (data) {
                        if (data['errmsg']) {
                            console.log(data['errmsg']);
                        }
                        else {
                            updateDiskInfo(data);

                            if (type == 1)//现阶段手动初始化手段
                                $interval.cancel(diskInfoStatus);
                        }

                    });
                }, 20000);
            }
            else {
                $http({
                    url: '/index.php?m=admin&c=business&a=getDiskInfo&type=' + type,
                    data: {level: disk.level, group: disk.group, disk: disk.index, maxtime: 0, type: type},
                    method: 'POST'
                }).success(function (data) {
                    if (data['errmsg']) {//不存在
                        disk.capacity = '未知';
                        disk.sn = '未知';
                        disk.bridged = 0;
                        disk.loaded = 0;
                        updateDiskView(disk);
                        return;
                    }
                    updateDiskInfo(data);

                });
            }
        }
        Cmd.devicestatus = function () {
            var msg = {cmd: 'DEVICESTATUS'};
            return Cmd.sendcmd(msg);
        }
        Cmd.testPost = function () {
            $http({
                url: '/index.php?m=admin&c=msg&a=index',
                data: {
                    "CMD_ID": "1",
                    "cmd": "BRIDGE",
                    "disks": [{"SN": "S4Z0AJ8T", "id": "1"}],
                    "group": "1", "level": "1",
                    "paths": [{"errno": "0", "id": "1", "status": "0", "value": "sbc"}],
                    "subcmd": "STOP"
                },
                method: 'POST'
            }).success(function (data) {
                alert("done");

            });
        }
        Cmd.writeprotect = function (level) {
            var msg = {cmd: "WRITEPROTECT", subcmd: 'START', level: level};
            Cmd.sendcmd(msg);
        }
        Cmd.md5 = function (level, group, disk) {
            var msg = {cmd: 'MD5', subcmd: 'START', level: level, group: group, disk: disk};
            Cmd.sendcmd(msg);
        }
        Cmd.stop = function (id) {
            //获取命令参数
            $http({
                url: '/index.php?m=admin&c=business&a=getCmdResult&cmdid=' + id,
                method: 'GET'
            }).success(function (data) {
                if (data['errmsg']) {
                    $scope.svrErrPool.add(data);
                }
                else {
                    var msg = JSON.parse(data['msg']);
                    msg.CMD_ID = id.toString();
                    msg.subcmd = 'STOP';
                    this.sendcmd(msg);
                }
            });
            //增加命令日志
            //发送命令
        }
        Cmd.update = function (id, subcmd) {
            //获取命令参数
            $http({
                url: '/index.php?m=admin&c=business&a=getCmdResult&cmdid=' + id,
                method: 'GET'
            }).success(function (data) {
                if (data['errmsg']) {
                    $scope.svrErrPool.add(data);
                }
                else {
                    var msg = JSON.parse(data['msg']);
                    msg.CMD_ID = id.toString();
                    msg.subcmd = subcmd;
                    $http.post(proxy, msg).error(function () {
                        $scope.svrErrPool.add();
                    });
                }
            });

        }
        Cmd.copy = function (srcLvl, srcGrp, srcDisk, dstLvl, dstGrp, dstDisk) {
            var msg = {
                cmd: 'COPY',
                subcmd: 'START',
                srcLevel: srcLvl,
                srcGroup: srcGrp,
                srcDisk: srcDisk,
                dstLevel: dstLvl,
                dstGroup: dstGrp,
                dstDisk: dstDisk
            };
            Cmd.sendcmd(msg);
        }
        Cmd.diskinfo = function (level, group, disk) {
            var msg = {cmd: 'DISKINFO', level: level.toString(), group: group.toString(), disk: disk.toString()};
            Cmd.sendcmd(msg);

        }
        Cmd.bridge = function (level,group,disk) {

            var msg = {
                cmd: 'BRIDGE', subcmd: 'START', level: disk.level.toString(), group: disk.group.toString(), disks: [
                    {id: disk.disk.toString(), SN: disk.sn}], filetree:1
            };
            $scope.cmd.sendcmd(msg);
        }
        Cmd.sendcmd = function (msg) {
            /*****test******/
            if (msg.subcmd == 'START') {
                msg.usedTime = 45;
                msg.progress = 36.7;
                $scope.cab.i_on_cmd_changed(msg, true);
            }
            else if (msg.subcmd == 'STOP') {
                $scope.cab.i_on_cmd_changed(msg, false);
            }

            if (msg.cmd == 'BRIDGE') {
                msg.paths = [];

                for (var i in msg.disks) {
                    var _dsk = msg.disks[i];

                    msg.paths.push({
                        "status": "0",
                        // 硬盘号，类型int，取值：1-4
                        "id": _dsk.id.toString(),
                        //路径，类型字符串，长度16字节
                        "value": "sdb" + _dsk.id
                    });
                }

                $scope.cab.i_on_bridge_resp(msg);
            }
            return;
            /*****test end******/
            //先发送消息告知服务器即将发送指令；
            $http.post(server, msg).
                success(function (data) {
                    if (data['errmsg']) {
                        $scope.svrErrPool.add(data);
                    }
                    //如果命令为停止，则cmd_id实际为目标ID，且不需要再次赋值
                    if (msg.subcmd != 'STOP') {
                        msg.CMD_ID = data['id'].toString();
                    }
                    var msgStr = JSON.stringify(msg);

                    //服务器收到通知后，联系APP，发送指令；
                    $http.post(proxy, msg).
                        success(function (data) {
                            //命令池更新
                            var newCmd = this.createCmd(msg);
                            $scope.taskPool.add(newCmd);
                        }).
                        error(function (data) {
                            $scope.svrErrPool.add();
                        });
                    //更新日志内容，将命令所涉及的插槽信息发送给日志
                    $http.post(server, {msg: msgStr, id: msg.CMD_ID});
                }).
                error(function (data) {
                    $scope.svrErrPool.add();
                });

        }
        $scope.cmd = Cmd;
        $scope.svrErrPool = {
            pool: [],
            svrDown: false,
            maxPoolSize: 10,
            add: function (data) {
                if (data == undefined) {
                    data = {errMsg: '与服务器通信失败。'};
                }
                this.pool.push(data);
                if (this.pool.length > this.maxPoolSize) {
                    $scope.taskPool.stopWatch();
                    this.svrDown = true;
                }
            }
        };
       $scope.updateDeviceStatus = function()
        {
            $http({
                url: '/index.php?m=admin&c=business&a=getDeviceInfo',
                method: 'GET'
            }).success(function (data) {
                $scope.cab.i_load_disks_base_info(data);
            }).error(function (data) {
                console.log("系统初始化失败.");
            });
        }
        //！！服务器出错标志，慎重使用！！
        $scope.taskPool = {
            ready: false,
            //池子里有完成的命令
            dirty: false,
            //正在执行的任务
            going: [],
            //停止的任务
            done: [],
            //最小轮询时间单元
            unitTimer: 1000,
            //小号放大器
            smAmp: 2,
            //中号放大器
            mdAmp: 10,
            //大号放大器
            LgAmp: 20,
            //轮询次数计数器
            queryCnt: 0,
            stopFlag: false,
            maxPoolSize: 50,
            add: function (task) {
                this.going.forEach(function(e){
                    if (e.id == task.id) {
                        //判断是否是新命令，如果不是新命令，不执行任何操作
                        return;
                    }
                });

                this.going.push(task);
            },
            updateQueryCnt: function () {
                this.queryCnt++;
                if (this.queryCnt > this.lgAmer) {
                    this.queryCnt = 0;
                }
            },
            deactivate: function (task) {
                var idx = this.going.indexOf(task);
                if (idx == -1) {
                    idx = 0;
                    for (idx; idx < this.going.length; idx++) {
                        if (this.going[idx].id == task.id) {
                            this.going.splice(idx, 1);
                            break;
                        }
                        idx++;
                    }
                }
                else {
                    this.going.splice(idx, 1);
                }
                if (task.subcmd == "START" || task.subcmd == "STOP") {
                    this.done.push(task);
                }
            },

            startWatch: function () {
                var pool = this;
                var taskWatcher = $interval(function () {
                    if (this.stopFlag == true) {
                        $interval.cancel(taskWatcher);
                    }
                    for (var idx = 0; idx < pool.going.length; idx++) {
                        var task = pool.going[idx];

                        var timeFlag = false;
                        //更新时间

                        if (--task.usedTime < 0) {
                            task.status = task.timeout;
                            pool.dirty = true;
                        }

                        if (task.status != $scope.cmd.going) {
                            continue;
                        }
                        switch (pool.going[idx].cmd) {
                            case 'BRIDGE':
                                if (0 == pool.queryCnt % pool.mdAmp)timeFlag = true;
                                break;
                            case 'MD5':
                                if (0 == pool.queryCnt % pool.lgAmp)timeFlag = true;
                                break;
                            case 'COPY':
                                if (0 == pool.queryCnt % pool.lgAmp)timeFlag = true;
                                break;
                            default:
                                if (0 == pool.queryCnt % pool.smAmp)timeFlag = true;
                                break;
                        }
                        if (timeFlag != true) {
                            continue;
                        }
                        $http({
                            url: '/index.php?m=admin&c=business&a=getCmdResult&cmdid=' + task.id,
                            method: 'GET'
                        }).success(function (data) {
                            if (data['errmsg']) {
                                $scope.svrErrPool.add(data);
                            }
                            else {
                                task.status = data['status'];
                            }
                        }).error(function () {
                            $scope.svrErrPool.add();
                        });
                        pool.checkProgress(idx);
                    }
                    pool.updateQueryCnt();
                    //检查命令池大小

                    if (pool.dirty === true) {
                        //更新命令池
                        $interval.cancel(taskWatcher);
                        pool.cleanCmdPool();
                    }
                }, this.unitTimer);
            },
            stopWatch: function () {
                this.stopFlag = true;
            },
            //通知
            notify:function(task){
                var result = '成功';
                var type = 'success';
                var icon='fa fa-check';
                switch(task.status)
                {

                    case task.timeout:
                        result = '超时';
                        type =  'error';
                        icon='fa fa-alarm';
                        break;
                    case task.canceled:
                        result = '取消';
                        type = 'info';
                        icon='fa fa-alarm';
                        break;
                    default :
                        //失败
                        result  = '失败';
                        type =  'error';
                        icon='fa fa-alarm';
                        break;
                }
                new PNotify({
                   title:'命令执行结果',
                    text:task.cmd+'命令执行'+ result,
                    type: type,
                    addclass: 'notficiation-primary',
                    icon: icon
                });
            },
            //更新命令池
            cleanCmdPool: function () {
                var newPool = [];
                var pool = this.going;
                for (var i = 0; i < this.going.length; i++) {
                    if (pool[i].status != $scope.cmd.going) {
                        //根据命令状态弹出响应消息

                        this.notify(pool[i]);
                        this.done.push(pool[i]);
                    }
                    else
                        newPool.push(pool[i]);
                }
                this.going = [];
                this.going = newPool;
                this.startWatch();
            },
            //发送消息检查命令进度
            checkProgress: function (idx) {
                var task = this.going[idx];
                if (task.cmd != 'MD5' && task.cmd != 'COPY')
                    return;
                if (task.subcmd != 'START' || parseInt(task.progress) >= 100) {
                    var prog = parseInt(task.progress);
                    if (prog == 100) {
                        this.success(idx);
                    }
                    return;
                }
                $scope.cmd.update(task.id, 'PROGRESS');
            },
            init: function () {
                var pool = this;
                $http({
                    url: '/index.php?m=admin&c=business&a=getGoingTasks',
                    method: 'GET'
                }).success(function (data) {
                    var time = new Date();
                    data.forEach(function (e) {
                        if (e.msg != '' && e.cmd !='MD5') {

                            var msg = JSON.parse(e.msg);
                            console.log(e['start_time']);
                            console.log($scope.cmd);
                            var task = $scope.cmd.createCmd(msg);
                            task.usedTime = parseInt(task.usedTime - (time.getTime() / 1000 - parseInt(e.start_time)));
                            pool.add(task);
                        }
                    });
                    pool.ready = true;
                    pool.startWatch();
                }).error(function () {
                    $scope.svrErrPool.add();
                });
            },
            /*
             * success:成功处理
             * error:失败处理
             * */
            success: function (idx) {
                var task = this.going[idx];

                if (task.progress > 100) {
                    return;
                }
                task.progress = 101;
                $scope.cmd.update(task.id, 'RESULT');
            },
            error: function (idx) {

            }

        };
        $scope.errCodes = {
            ready: false,
            init: function () {
                var that = this;
                $http({
                    url: '/Public/js/errcode.json',
                    method: 'GET'
                }).success(function (data) {
                    that.codes = data;
                    that.ready = true;
                }).error(function () {
                    $scope.svrErrPool.add();
                });
            }
        };


        var businessRoot = '/index.php?m=admin&c=business';
        $scope.bridgeUrl = '/Public/js/bridge.html';
        var server = businessRoot + '&a=addcmdlog';
        var proxy = "http://222.35.224.230:8080";
        $scope.cabId = 0;
        $scope.levelCnt = 6;
        $scope.groupCnt = 6;
        $scope.diskCnt = 4;
        $scope.cabUrl = '/Public/tpl/cab.html';
        function init_popup() {
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
                modal: true
            });

            $(document).on('click', '.modal-dismiss', function (e) {
                e.preventDefault();
                $.magnificPopup.close();
            });

            $(".chk-radios-form").each(function () {
                $(this).validate({
                    highlight: function (element) {
                        $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
                    },
                    success: function (element) {
                        $(element).closest('.form-group').removeClass('has-error');
                    }
                })
            });

            $.extend($.validator.messages, {
                required: "（必填）",
                remote: "请修正此字段",
                email: "请输入有效的电子邮件地址",
                url: "请输入有效的网址",
                date: "请输入有效的日期",
                dateISO: "请输入有效的日期 (YYYY-MM-DD)",
                number: "请输入有效的数字",
                digits: "只能输入数字",
                creditcard: "请输入有效的信用卡号码",
                equalTo: "你的输入不相同",
                extension: "请输入有效的后缀",
                maxlength: $.validator.format("最多可以输入 {0} 个字符"),
                minlength: $.validator.format("最少要输入 {0} 个字符"),
                rangelength: $.validator.format("请输入长度在 {0} 到 {1} 之间的字符串"),
                range: $.validator.format("请输入范围在 {0} 到 {1} 之间的数值"),
                max: $.validator.format("请输入不大于 {0} 的数值"),
                min: $.validator.format("请输入不小于 {0} 的数值")
            });
        }
        init_popup();

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
                loaded:false,
                // 是否写保护
                write_protected:false,
                // 是否桥接
                bridged:false,
                // 已桥接状态的mount文件夹名
                bridge_path:''
            };
            // 硬盘详细信息集合
            this.detail_info = {
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

                if (cmd_name != 'BRIDGE' && cmd_name != 'MD5' && cmd_name != 'COPY') {
                    console.log('unknown cmd = ' + cmd_name);
                    return;
                }

                this.cmd_name_to_commit = cmd_name;
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
            reset: function(){
                this.curr_cmd = null;
                this.busy_disk = null;
                this.cmd_name_to_commit = '';
                this.base_info.loaded = false;
                this.base_info.bridged = false;
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

            // 获得命令中文名
            get_commit_cmd_title: function () {
                switch (this.cmd_name_to_commit) {
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
                        title = '正在查询中';
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
                        title = '正在桥接中';
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
            get_cmd_name: function () { return (this.base_info.loaded && !this.base_info.bridged && this.curr_cmd != null) ? this.curr_cmd.cmd : ''; },
            // 判断硬盘是否busy
            is_busy: function () {
                // 不在位硬盘，返回false
                if (!this.base_info.loaded) return false;

                // 已桥接或命令不为空（代表有命令正在执行），返回true
                return this.base_info.bridged || this.get_cmd_name() != '';
            },
            // 获得可能导致命令执行失败的本组中Busy硬盘
            get_busy_disk: function () {
                // 清空状态
                this.busy_disk = null;

                // 若自身Busy，则返回this
                if (this.is_busy()) {
                    this.busy_disk = this;
                    return this;
                }

                // 查看本组中其他盘是否Busy
                var sibs = this.get_siblings();
                for (var i in sibs) {
                    var _dsk = sibs[i];
                    if (_dsk.is_busy()) {
                        this.busy_disk = _dsk;
                        break;
                    }
                }

                return this.busy_disk;
            },
            // 在执行“复制”命令时，查找可能导致命令执行失败的Busy硬盘
            get_copy_busy_disk: function () {
                var _sdisk = this.get_busy_disk();
                if (_sdisk != null) return _sdisk;

                this.busy_disk = this.parent.parent.groups[this.g + (this.g % 2 == 0 ? 1 : -1)].disks[0].get_busy_disk();
                return this.busy_disk;
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

                _msg += '（需要持续占用总线资源），无法对该组内的硬盘进行操作！';

                return _msg;
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
                        _dsk.curr_cmd.progress = 0;
                    }
                }

                // send cmd;
                $scope.cmd.sendcmd(cmd_obj);

                $.magnificPopup.close();

                //console.log(cmd_obj);
                return true;
            },
            // 用于发送“MD5”和“复制”命令的“STOP”子命令
            cmd_stop: function () {
                var cmd_obj = null;
                if (this.base_info.bridged) {
                    cmd_obj = {
                        cmd: 'BRIDGE',
                        subcmd: 'STOP',
                        level: (this.l + 1).toString(),
                        group: (this.g + 1).toString(),
                        disks: [
                            {
                                id: (this.d + 1).toString(),
                                SN: ''
                            }
                        ]
                    };
                }
                else {
                    cmd_obj = this.curr_cmd;
                    cmd_obj.subcmd = 'STOP';

                    if (cmd_obj != null && cmd_obj.subcmd != null) {
                        if (cmd_obj.cmd == 'COPY') {
                            this.parent.parent.groups[parseInt(cmd_obj.srcGroup) - 1].disks[parseInt(cmd_obj.srcDisk) - 1].curr_cmd = null;
                            this.parent.parent.groups[parseInt(cmd_obj.dstGroup) - 1].disks[parseInt(cmd_obj.dstDisk) - 1].curr_cmd = null;
                        }

                        this.curr_cmd = null;
                    }
                }

                $scope.cmd.sendcmd(cmd_obj);
                //console.log(cmd_obj);

                $.magnificPopup.close();
            }
        };

        // 柜子Cabinet类的构造函数
        function Cabinet() {
            // 柜子ID，用于支持多个柜子
            this.id = -1;
            // 当前选中的硬盘对象
            this.curr = null;
            // 存储柜所有层集合，用于存放存储所有相关数据
            this.levels = [];
        }
        // 柜子Cabinet类的原型
        Cabinet.prototype = {
            // 初始化存储柜的插槽信息
            i_on_init: function (id, level_cnt, group_cnt, disk_cnt) {
                this.id = id;
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
            },
            // 用于支持前端对存储柜选择硬盘
            select_disk: function (l, g, d) {
                this.curr = this.levels[l].groups[g].disks[d];
                this.curr.get_copy_busy_disk();
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
                    _dsk.base_info.loaded = (e.loaded==1);
                    _dsk.base_info.bridged = e.bridged == 1;
                    // 桥接置位
                    if (e.bridged == 1) {
                        _dsk.base_info.bridge_path = e.bridge_path;
                    }
                }
            },

            // 接口：激励，当命令集合添加或移除一条命令时触发，当增加时bol_op为true，代表add；当移除时，bol_op为false,代表remove
            i_on_cmd_changed: function (json_cmd, bol_op) {
                switch (json_cmd.cmd) {
                    case 'DISKINFO': {
                        this.on_cmd_disk_info(json_cmd, bol_op);
                        break;
                    }
                    case 'BRIDGE': {
                        this.on_cmd_bridge(json_cmd, bol_op);
                        break;
                    }
                    case 'MD5': {
                        this.on_cmd_md5(json_cmd, bol_op);
                        break;
                    }
                    case 'COPY': {
                        this.on_cmd_copy(json_cmd, bol_op);
                        break;
                    }
                    default: {
                        console.log('Unknown Cmd');
                        break;
                    }
                }
            },

            // 接口：激励，当桥接命令返回时触发，用于更新硬盘的桥接状态
            i_on_bridge_resp: function (resp) {
                if (resp.cmd != 'BRIDGE') return;

                var idx_l = parseInt(resp.level) - 1, idx_g = parseInt(resp.group) - 1;
                if (idx_l < 0 || idx_l > 5 || idx_g < 0 || idx_g > 5) {
                    console.log("Invalid bridge resp", resp);
                    return;
                }

                // 遍历所有硬盘
                for (var i in resp.paths) {
                    var path = resp.paths[i];
                    var idx_d = parseInt(path.id) - 1;
                    if (idx_d < 0 || idx_d > 3) {
                        console.log("Invalid bridge resp, path id=" + path.id, resp);
                        return;
                    }

                    // 桥接失败
                    if (path.status != '0') {
                        continue;
                    }

                    if (resp.subcmd == 'START') {
                        // 桥接置位
                        this.levels[idx_l].groups[idx_g].disks[idx_d].base_info.bridged = true;
                    }
                    else if (resp.subcmd == 'STOP') {
                        // 桥接置零
                        this.levels[idx_l].groups[idx_g].disks[idx_d].base_info.bridged = false;
                    }
                    else {
                        return;
                    }
                }
            }
        };
        $scope.cab = new Cabinet();
        $scope.cab.i_on_init($scope.cabId, $scope.levelCnt, $scope.groupCnt, $scope.diskCnt);




        var test = function () {
            var disk;
            disk = $scope.cab.levels[0].groups[0].disks[0];
            disk.base_info.loaded = true;
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

            disk = $scope.cab.levels[0].groups[3].disks[0];
            disk.base_info.loaded = true;
            disk.detail_info.capacity = 1150;
            disk.detail_info.SN = 'daaaaa1';

            disk = $scope.cab.levels[0].groups[3].disks[1];
            disk.base_info.loaded = true;
            disk.detail_info.capacity = 250;
            disk.detail_info.SN = 'aaaaac';

            disk = $scope.cab.levels[0].groups[4].disks[0];
            disk.base_info.loaded = true;
            disk.detail_info.capacity = 250;
            disk.detail_info.SN = 'aaabaa';

            disk = $scope.cab.levels[0].groups[4].disks[1];
            disk.base_info.loaded = true;
            disk.detail_info.capacity = 250;
            disk.detail_info.SN = 'aaabba';

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

            disk = $scope.cab.levels[1].groups[0].disks[1];
            disk.base_info.loaded = true;
            disk.detail_info.capacity = 120;
            disk.detail_info.SN = 'abcdef';

            disk = $scope.cab.levels[1].groups[1].disks[0];
            disk.base_info.loaded = true;
            disk.detail_info.capacity = 250;
            disk.detail_info.SN = 'aaaaaa';


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


      //  test();
/*
        $(".chk-radios-form").validate({
            highlight: function (element) {
                $(element).closest('.form-group').removeClass('has-success').addClass('has-error');
            },
            success: function (element) {
                $(element).closest('.form-group').removeClass('has-error');
            }
        });*/
        $scope.start = function () {
          //  $scope.updatetime = myDate.getTime();
            $scope.errCodes.init();
          //  $scope.cab.init($scope.levelCnt, $scope.groupCnt, $scope.diskCnt);
            $scope.cab.ready = true;
            //等待柜子初始化完成后，开始监控程序；
            var waitCab = $interval(function () {
                if ($scope.cab.ready) {
                    $scope.taskPool.init();
                    $interval.cancel(waitCab);
                }
            }, 2000);
            $scope.cmd.devicestatus();
            this.updateDeviceStatus();
        }
        $scope.start();
        $scope.deviceInit = function () {
            $scope.cmd.devicestatus();
            $scope.info1 = "初始化中，请等待";
            var thisTimer = 0;
            var deviceInterval = $interval(function () {
                thisTimer++;
                if ($scope.stop == 1) {
                    $interval.cancel(deviceInterval);
                    $scope.info1 = "初始化过程终止。";
                }
                $scope.info1 = "正在获取在位信息，等待代理响应，预计需40秒，已等待" + thisTimer * 2 + "秒";
                if (thisTimer > 100) {//停止查询
                    $interval.cancel(deviceInterval);
                    $scope.info1 = "命令执行失败，请重试";
                }
                $http({
                    url: '/index.php?m=admin&c=business&a=getCmdResult&cmd=DEVICESTATUS',
                    method: 'GET'
                }).success(function (data) {
                        if (data['errmsg']) {
                            return;
                        }
                        if (data['status'] >= 0) {
                            $interval.cancel(deviceInterval);
                            if (data['status'] > 0) {
                                $scope.info1 = "命令执行失败，请重试";
                            }
                            else {
                                //命令执行完毕
                                $scope.info1 = "命令执行成功，在位信息获取完毕，开始初始化硬盘信息...";
                                $http({

                                    url: '/index.php?m=admin&c=business&a=getDeviceInfo',
                                    method: 'GET'
                                }).success(function (data) {
                                        var i = 0;
                                        var timeLth = data.length * 50;
                                        var diskInitTimer = $interval(function () {
                                            timeLth--;
                                            $scope.info2 = " 剩余时间" + timeLth + "秒";
                                            if (timeLth == 0)
                                                $interval.cancel(diskInitTimer);
                                        }, 1000);
                                        var diskInterval = $interval(function () {
                                            var e = data[i];
                                            $scope.info1 = "正在初始化硬盘，硬盘号#" + e.level + "-" + e.zu + "-" + e.disk;

                                            $scope.diskinfo(e.level, e.zu, e.disk);
                                            i++;
                                            if (i >= data.length) {
                                                $scope.info1 = "初始化硬盘信息完毕...";
                                                $interval.cancel(diskInterval);
                                            }
                                        }, 50000);


                                    }
                                );
                            }
                        }
                    }
                );
            }, 2000);
        }

        //系统初始化
        $scope.systemInit = function () {
            $scope.info1 = "1.数据库重置中...";
            $http({
                url: '/index.php?m=admin&c=business&a=systeminit',
                data: {level: $scope.level, group: $scope.group, disk: $scope.disknum},
                method: 'POST'
            }).success(function (data) {
                if (data['errmsg']) {
                    $scope.info1 = "数据库重置失败，请重试";
                    return;
                }
                $scope.info1 = "2.数据库重置完成，开始初始化在位信息...";
                $scope.deviceInit();
                //检查是否有未完成的命令
            });
        }


    });
