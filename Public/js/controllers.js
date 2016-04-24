angular.module('device.controllers', [])
    .controller('DeviceStatus', function ($scope, $http, $timeout, $interval) {
        $scope.test = "1";
        $scope.bridgedLvl = 0;
        $scope.bridgedGrp = 0;

        $scope.selected = {'level': 1, 'group': 1, 'index': 1};
        $scope.bridgedDisks = [];
        var businessRoot = '/index.php?m=admin&c=business';
        var msgRoot = '/index.php?m=admin&c=msg';
        $scope.bridgeUrl = '/Public/js/bridge.html';

        var server = businessRoot + '&a=addcmdlog';
        var proxy = "http://222.35.224.230:8080";
        var vm = $scope.vm = {};
        $scope.levels = [2, 3, 4, 5, 6];
        $scope.groups = [1, 2, 3, 4, 5, 6];
        $scope.disks = [1, 2, 3, 4];
        $scope.level = 6;
        $scope.group = 6;
        $scope.disknum = 4;
        $scope.loaded = 0;
        $scope.cmd = "桥接";
        $scope.levelText = "选择层";
        $scope.groupText = "选择组";
        $scope.ready = {};
        $scope.disk = {'level': 1, 'group': 1, 'index': 1, 'capability': '查询中...', 'sn': '查询中...', 'md5': '查询中'};
        var myDate = new Date();
        vm.value = 0;
        vm.style = 'progress-bar-danger';
        vm.show = false;
        vm.bridgeReady = 0;
        $scope.ready.bridgedDisk = true;
        $scope.ready.bridge = false;
        var cs = $scope.cmdStatus;
        cs = [];/*{
            ids:[],
            dstIds:[],
            cmds:[],
            subCmds:[],
            status:[],
            startTimes:[]
        };*/

        $scope.start = function () {
            $scope.updatetime = myDate.getTime();
            vm.striped = true;
            vm.cmd = null;
            vm.diskReady = false;//磁盘是否准备好操作；
            vm.bridge = "桥接";
            //登陆系统时通过数据库初始化系统
            //获取在位信息
            $http({
                url: '/index.php?m=admin&c=business&a=getDeviceInfo',
                method: 'GET'
            }).success(function (data) {
                $scope.loaddisks(data);
            }).error(function (data) {
                console.log("系统初始化失败.");
            });
            //获取所选取的磁盘的硬盘信息

        }
        $scope.start();
        $scope.selectLevel = function(level)
        {
            if(level != $scope.bridgedLvl)
            {
                $scope.bridgedDisks = [];
                if($scope.bridgedGrp > 0)
                {
                    $scope.updateBridgedDisk(level,$scope.bridgedGrp);

                }
            }
            $scope.bridgedLvl = level;
            $scope.levelText = "第"+level+"层";
            $("#lvl-optn-"+level).addClass("selected");

        }
        $scope.selectGroup = function(group)
        {
            if(group != $scope.bridgedGrp)
            {
                $scope.bridgedDisks = [];
                if($scope.bridgedLvl > 0)
                {
                    $scope.updateBridgedDisk($scope.bridgedLvl,group);
                }
            }
            $scope.bridgedGrp = group;
            $scope.groupText = "第"+group+"组";
            $("#grp-optn-"+group).addClass("selected");
        }

        $scope.updateBridgedDisk = function(level,group)
        {
            var readyNum = 0;
            $scope.ready.bridgedDisk = false;
            for(var i = 1;i <= $scope.disknum;i++)
            {
                $http({
                    url: '/index.php?m=admin&c=business&a=getDiskInfo',
                    data: {level: level, group: group, disk: i, maxtime: 0, type: 0},
                    method: 'POST'
                }).success(function (data) {

                    updateDiskView(data);
                    if(data.bridged == 1)
                    {
                        $scope.bridgedDisks.push(i);
                    }
                    readyNum++;
                    if(readyNum==$scope.disknum)
                        $scope.ready.bridgedDisk=true;
                }).error(function(data){
                    console.log("server error: post fail");
                    readyNum++;
                    if(readyNum==$scope.disknum)
                    {
                        $scope.ready.bridgedDisk=true;

                    }
                });
            }
        }

        $scope.updateBridgeSelection = function(index)
        {
            var selected = $scope.bridgedDisks;
            var idx = selected.indexOf(index);//是否已选
            if(idx == -1)
            {
                selected.push(index);
            }
            else
            {
                selected.splice(idx,1);
            }
        }
        $scope.isBridgeSelected = function(index)
        {
            var selected = $scope.bridgedDisks;
            var idx = selected.indexOf(index);//是否已选
            if(idx == -1)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
        $scope.deviceInit = function () {
            $scope.devicestatus();
            $scope.info1 = "初始化中，请等待";
            var thisTimer = 0;
            var deviceInterval = $interval(function () {
                thisTimer++;
                if ($scope.stop == 1) {
                    $interval.cancel(deviceInterval);
                    $scope.info1 = "初始化过程终止。";
                }
                $scope.info1 = "正在获取在位信息，等待代理响应，预计需40秒，已等待" + thisTimer*2+"秒";
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
                                    var diskInitTimer = $interval(function(){
                                        timeLth--;
                                        $scope.info2 = " 剩余时间"+timeLth+"秒";
                                        if(timeLth == 0)
                                        $interval.cancel(diskInitTimer);
                                    },1000);
                                    var diskInterval = $interval(function(){
                                        var e = data[i];
                                        $scope.info1 = "正在初始化硬盘，硬盘号#"+ e.level+"-"+ e.zu+"-"+ e.disk;

                                        $scope.diskinfo(e.level, e.zu, e.disk);
                                        i++;
                                        if(i >= data.length)
                                        {
                                            $scope.info1 = "初始化硬盘信息完毕...";
                                            $interval.cancel(diskInterval);
                                        }
                                    },50000);


                                    }
                                );
                            }
                        }
                    }
                );
            }, 2000);
        }

        $scope.md5check = function (level, group, disk) {
            $scope.md5(level, group, disk);
            var index = 0;
            var mdTime = 1000;
            //定時更新進度條
            var start = $interval(function () {
                vm.value = (++index) / mdTime;
                if (index > mdTime - 1) {
                    $interval.cancel(start);
                }

            }, mdTime);
            var status = $interval(function () {
                $http({
                    url: '/index.php?m=admin&c=business&a=getMd5Status',
                    method: 'GET'
                }).success(function (data) {
                    if (data['status'] >= 0) {
                        if (data['status'] == 0) {
                            vm.value = 100;
                            //查结果

                            $scope.md5ResultCheck(level, group, disk);
                            //$scope.disk.md5 = "校验完成，结果查询中";
                        }
                        else {
                            vm.errorShow = true;
                            vm.errorMsg = "命令執行失敗";
                        }
                        $interval.cancel(start);
                        $interval.cancel(status);
                    }

                });
            }, 10000);
        }
        var showProgress = function () {
            vm.value = 0;
            vm.show = true;
        }
        $scope.bridge = function (type) {
            var disk = $scope.disk;
            var msg = {
                cmd: 'BRIDGE', subcmd: 'START', level: disk.level.toString(), group: disk.group.toString(), disks: [
                    {id: disk.disk.toString(), SN: disk.sn}], filetree: $scope.test
            };
            if (undefined == type) {
                type = 1;
            }
            if (type == 2) {
                $interval.cancel(start);

                msg.subcmd = 'STOP';
                msg.filetree = '0';
                $scope.sendcmd(msg);
                disk.bridged = 0;
                updateDiskView(disk);
                return;
            }

            vm.cmd = '硬盘#' + disk.level + '-' + disk.group + '-' + disk.disk + '桥接中...';

            var msgId = 0;
            msgId = $scope.sendcmd(msg);
            var index = 0;
            var mdTime = 1000;
            var statusTimer = 0;
            //更新间隔
            showProgress();
            var start = $interval(function () {
                vm.value = parseInt(100 * (++index) / 180);
                console.log(vm.value);
                if (index >= 180) {
                    vm.value = 99;
                    $interval.cancel(start);
                }

            }, mdTime);
            var bridgeStatus = $interval(function () {
                if (msgId == 0)
                    return;
                statusTimer++;
                if (statusTimer > 600) {
                    vm.value = 0;
                    vm.show = false;
                    $interval.cancel(bridgeStatus);
                    $interval.cancel(start);
                    return;
                }
                $http({
                    url: '/index.php?m=admin&c=business&a=getBridgeStatus',
                    method: 'GET'
                }).success(function (data) {
                    if (data['errmsg']) {
                        vm.cmdFail = true;//命令执行失败
                        vm.cmd = "设备忙，请稍后再试";
                        $interval.cancel(start);
                        $interval.cancel(bridgeStatus);
                        vm.show = false;
                        return;
                    }
                    if (data['status'] >= 0) {
                        if (data['status'] == 0) {
                            var disk = $scope.disk;
                            vm.value = 100;
                            //桥接成功，改变盘状态
                            var id = "#disk-" + disk.level + "-" + disk.group + "-" + disk.index;
                            $(id).removeClass("btn-primary").addClass("btn-success");
                            vm.cmd = '硬盘#' + disk.level + '-' + disk.group + '-' + disk.index + '桥接完成';
                        }
                        else {
                            vm.cmdFail = true;//命令执行失败
                            vm.cmd = "设备忙，请稍后再试";
                        }

                        $interval.cancel(start);
                        $interval.cancel(bridgeStatus);
                        vm.show = false;
                    }

                });
            }, 10000);
        }
        $scope.md5ResultCheck = function (level, group, disk) {
            $scope.md5Result(level, group, disk);
            var result = $interval(function () {
                $http({
                    url: '/index.php?m=admin&c=business&a=getMd5Result',
                    method: 'POST',
                    data: {'level': level, 'group': group, 'disk': disk}
                }).success(function (data) {
                    if (data['status'] >= 0) {
                        $interval.cancel(result);
                        if (data['status'] == 0)
                            $scope.disk.md5 = data['result'];
                        else {//失败，应如实显示
                        }
                    }
                });
            }, 1000);
        }
        $scope.sendcmd = function (msg) {
            console.log('sending command.');
            //先发送消息告知服务器即将发送指令；
            $http.post(server, msg).
            success(function (data) {
                if (data['errmsg']) {
                    console.log(data['errmsg']);
                    return -1;
                }
                msg.CMD_ID = data['id'].toString();
                //服务器收到通知后，联系APP，发送指令；
                $http.post(proxy, msg).
                success(function (data) {
                    console.log(msg.CMD_ID);
                }).
                error(function (data) {
                    console.log("app offline");
                    return -1;
                });
            }).
            error(function (data) {
                // called asynchronously if an error occurs
                // or server returns response with an error status.
                console.log("server error");
                return false;
            });

        }
        //从数据库中查询硬盘在位信息

        $scope.selectDisk = function (level, group, index) {
            $scope.disk.level = level;
            $scope.disk.group = group;
            $scope.disk.index = index;
        }
        //查询实际在位信息
        var updateDeviceStatus = function () {

        }
        $scope.loaddisks = function (data) {

            var levels = $scope.bridgedLevels;

            var bridgedGroups = $scope.groups;
            var zeros = [0,0,0,0,0,0];
            levels = zeros;
            //初始化groups
            bridgedGroups=[];
            for(var i = 0;i < $scope.level;i++)
            {
                bridgedGroups[i] = zeros;
            }
            $scope.loaded = 0;
            if (data.length > 0) {
                var theDisk = data[0];
                $scope.getdiskinfo(theDisk.level, theDisk.zu, theDisk.disk, 0);
                $scope.disk.level = theDisk.level;
                $scope.disk.group = theDisk.zu;
                $scope.disk.disk = theDisk.disk;


            }
            data.forEach(function (e) {
                    var id = "#disk-" + e.level + "-" + e.zu + "-" + e.disk;
                e.group = e.zu;
                e.index  = e.disk;
                    if(e.bridged == 1)
                    {
                        levels[e.level - 1] = true;
                        bridgedGroups[e.level-1][e.zu-1]++;
                    }
                    updateDiskView(e);
                    $scope.loaded = $scope.loaded + 1;
                }
            );
            $scope.bridgeReady = 1;


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
        $scope.checkCollision = function () {
            $http({
                url: 'http://localhost/index.php/business/checkCollision',

                method: 'GET'
            }).success(function (data) {
                return data['isLegal'];
            });
        }
        $scope.initStop = function () {
            $scope.stop = 1;
        }
        $scope.getdiskinfo = function (level, group, disk, type) {
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
        var updateDiskInfo = function (data) {
            var disk = $scope.disk;
            disk.sn = data['sn'];
            disk.md5 = data['smart'];
            disk.capacity = data['capacity'];
            disk.bridged = data['bridged'];
            disk.loaded = data['loaded'];
            updateDiskView(disk);
            $scope.bridgeReady = 1;
        }
        var updateDiskView = function (disk) {
            var id = "#disk-" + disk.level + "-" + disk.group + "-" + disk.index;
            var infoId = "#diskinfo-"  + disk.index;
            var checkId = "#qj-chk-" + disk.index;
            $(id).removeClass("btn-default").removeClass("btn-primary").removeClass("btn-success");

            $(id + " i").removeClass("glyphicon-ban-circle").addClass("glyphicon-hdd");
            if (disk.bridged == 1) {
                $(id).addClass("btn-success");
                $(infoId).val('[已桥接]');
                $(checkId).attr("checked",true);
            }
            else {
                if (disk.loaded == 1) {
                    $(id).addClass("btn-primary");
                    $(infoId).val('[未桥接]');
                }
                else {
                    $(id).addClass("btn-default");
                    $(id + " i").removeClass("glyphicon-hdd").addClass("glyphicon-ban-circle");
                    $(infoId).val('[不在位]');
                    $(checkId).attr("disabled",true);
                }
            }
        }

        $scope.devicestatus = function () {
            var msg = {cmd: 'DEVICESTATUS'};
            return $scope.sendcmd(msg);
        }
        $scope.testPost = function () {
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
        $scope.writeprotect = function (level) {
            var msg = {cmd: "WRITEPROTECT", subcmd: 'START', level: level};
            $scope.sendcmd(msg);
        }

        $scope.md5 = function (level, group, disk) {
            var msg = {cmd: 'MD5', subcmd: 'START', level: level, group: group, disk: disk};
            $scope.sendcmd(msg);
        }
        $scope.md5Result = function (level, group, disk) {
            var msg = {cmd: 'MD5', subcmd: 'RESULT', level: level, group: group, disk: disk};
            $scope.sendcmd(msg);
        }
        $scope.copy = function (srcLvl, srcGrp, srcDisk, dstLvl, dstGrp, dstDisk) {
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
            $scope.sendcmd(msg);
        }
        $scope.diskinfo = function (level, group, disk) {
            var msg = {cmd: 'DISKINFO', level: level.toString(), group: group.toString(), disk: disk.toString()};
            $scope.sendcmd(msg);

        }
        $scope.power = function (level) {
            var msg = {cmd: 'POWER', subcmd: 'START', levels: [level]};
            $scope.sendcmd(msg);
        }
    })
    .controller('device', function ($scope) {
        $scope.level = 6;
    })
    .controller('MainCtrl', function ($scope, $ionicSlideBoxDelegate, locals) {
        // 读取是否显示welcome的标志
        var wel = locals.get("welcome", true);

        if (wel == true) {
            $scope.welcome = true;

            // 不管用户是否完整看完了Welcome界面，下一次启动均不显示
            locals.set("welcome", false);
        }

        // 用户手动关闭Welcome界面
        $scope.closeWelcome = function () {
            delete($scope.welcome);
            $ionicSlideBoxDelegate.update();
        }
    })

    .controller('DashCtrl', function ($scope) {
    })

    .controller('ChatsCtrl', function ($scope, $http, Chats) {
        // With the new view caching in Ionic, Controllers are only called
        // when they are recreated or on app start, instead of every page change.
        // To listen for when this page is active (for example, to refresh data),
        // listen for the $ionicView.enter event:
        //
        //$scope.$on('$ionicView.enter', function(e) {
        //});

        $scope.chats = Chats.all();
        $http({
            url: 'http://localhost/index.php/home/bestforbaby?way=ngview',
            method: 'GET'
        }).success(function (newItems) {
            console.log("success");
            //$scope.chats = newItems;
        }).error(function () {
            console.log("fail");
            //$scope.chats = Chats.all();
        })

        $scope.remove = function (chat) {
            Chats.remove(chat);
        };
    })

    .controller('ChatDetailCtrl', function ($scope, $stateParams, Chats) {
        $scope.chat = Chats.get($stateParams.chatId);
        $scope.chats = Chats;
        $scope.photoSlides = 0;
    })
    .controller('LoginCtrl', function ($scope, $http) {

    })

    .controller('AccountCtrl', function ($scope) {
        $scope.settings = {
            enableFriends: true
        };
    })
    .controller('PhoneListCtrl', function ($scope) {
        $scope.phones = [
            {
                "name": "Nexus S",
                "snippet": "Fast just got faster with Nexus S."
            },
            {
                "name": "Motorola XOOM™ with Wi-Fi",
                "snippet": "The Next, Next Generation tablet."
            },
            {
                "name": "MOTOROLA XOOM™",
                "snippet": "The Next, Next Generation tablet."
            }
        ];
    })
    .controller('registerCtrl', function ($scope) {
    })
    .controller('AddCardCtrl', function ($scope) {
    })
    .controller('111Ctrl', function ($scope) {
    })
    .controller('productCtrl', function ($scope) {
    })

    .controller('chanpinCtrl', function ($scope) {

    })
    .controller('homepageCtrl', function ($scope, Chats, Products) {
        $scope.items = [
            {
                "name": "爱必赚1号",
                "begin": "5000",
                "rate": 10.2,
                "month": 24,
                "status": "在售"
            },
            {
                "name": "爱必赚2号",
                "begin": "5000",
                "rate": 12.3,
                "month": 28,
                "status": "售罄"
            }
        ];
        $scope.items = Products.all();

        $scope.photoSlides = 0;
    })

    .controller('actionCtrl', function ($scope) {

    })

    .controller('nightCtrl', function ($scope) {

    })
    .controller('111Ctrl', function ($scope) {

    })

    .controller('222Ctrl', function ($scope) {

    })

    .controller('cameraTabDefaultPageCtrl', function ($scope) {

    })

    .controller('cartTabDefaultPageCtrl', function ($scope) {

    })

    .controller('cloudTabDefaultPageCtrl', function ($scope) {

    })
    .controller('mybzCtrl', function ($scope) {

    })
    .controller('CardListCtrl', function ($scope) {
        $scope.cards = [
            {
                "bank": "北京银行",
                "number": "4225 **** **** 2548",
                "logo": "img/bj_bank.png"
            },
            {
                "bank": "广发银行",
                "number": "4225 **** **** 2548",
                "logo": "img/gf_bank.png"
            },
            {
                "bank": "招商银行",
                "number": "4235 **** **** 2542",
                "logo": "img/zs_bank.jpg"
            }
        ];
    })
    .controller('ProductDetailCtrl', function ($scope) {
        $scope.intro = [
            {
                "name": "预期年化收益",
                "value": "9.6%"
            },
            {
                "name": "封闭期",
                "value": "9.6%"
            },
            {
                "name": "起息日",
                "value": "购买之日起1-3天"
            },
            {
                "name": "退出日",
                "value": "封闭期结束后1-3天"
            },
            {
                "name": "剩余可投金额",
                "value": "545,500"
            },
        ];
        $scope.limit = [
            {
                "name": "起投金额",
                "value": "100万"
            },
            {
                "name": "单笔最高可投",
                "value": "10000元"
            }
        ];
    })

    .controller('introCtrl', function ($scope) {

    })

    .controller('feedbackCtrl', function ($scope) {

    })

    .controller('beginnerCtrl', function ($scope) {

    })

    .controller('guaranteeCtrl', function ($scope) {

    })

    .controller('settingCtrl', function ($scope) {

    })

    .controller('moreCtrl', function ($scope) {

    })
    .controller("productCtrl", function ($scope) {
        var products = [
            {
                "name": "爱必赚1号",
                "begin": "5000",
                "rate": 10.2,
                "month": 24,
                "status": "在售"
            },
            {
                "name": "爱必赚2号",
                "begin": "5000",
                "rate": 12.3,
                "month": 28,
                "status": "售罄"
            }
        ]
        var toPlus = 1000;
        var minBuy = 5000;
        $scope.toBuy = 5000;
        $scope.toPlus = function () {
            $scope.toBuy = $scope.toBuy + toPlus;
        }
        $scope.toMinus = function (item) {
            $scope.toBuy = $scope.toBuy - toPlus;
            if ($scope.toBuy < minBuy) {
                $scope.toBuy = minBuy;
            }
        }
        $scope.items = products;
    })
;
