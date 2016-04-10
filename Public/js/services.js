angular.module('device.services', [])
    .factory('Cmd', function($http,$interval,$timeout){
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
        return Cmd;
    }
)
.factory('Chats', function() {
  // Might use a resource here that returns a JSON array

  // Some fake testing data
  var chats = [{
    id: 0,
    name: 'Ben Sparrow',
    lastText: 'You on your way?',
    face: 'img/ben.png'
  }, {
    id: 1,
    name: 'Max Lynx',
    lastText: 'Hey, it\'s me',
    face: 'img/max.png'
  }, {
    id: 2,
    name: 'Adam Bradleyson',
    lastText: 'I should buy a boat',
    face: 'img/adam.jpg'
  }, {
    id: 3,
    name: 'Perry Governor',
    lastText: 'Look at my mukluks!',
    face: 'img/perry.png'
  }, {
    id: 4,
    name: 'Mike Harrington',
    lastText: 'This is wicked good ice cream.',
    face: 'img/mike.png'
  }];

  return {
    all: function() {
      return chats;
    },
    remove: function(chat) {
      chats.splice(chats.indexOf(chat), 1);
    },
    get: function(chatId) {
      for (var i = 0; i < chats.length; i++) {
        if (chats[i].id === parseInt(chatId)) {
          return chats[i];
        }
      }
      return null;
    }
  };
});
