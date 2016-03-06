<?php if (!defined('THINK_PATH')) exit();?> <!DOCTYPE html>
 <html lang="en">
 <head>
 	<meta charset="UTF-8">
 	<title>Document</title>

     <script src="/Public/js/jquery-1.11.1.js"></script>
     <script src="http://apps.bdimg.com/libs/angular.js/1.4.6/angular.min.js"></script>
     <link href="//cdn.bootcss.com/bootstrap/4.0.0-alpha.2/css/bootstrap.min.css" rel="stylesheet">
     <style type="text/css">
     .disk_active {background-color:green;}
     </style>
 </head>
 <body ng-app="device" ng-controller="DeviceStatus">
        <h1>柜子共{{level}}层，每层{{group}}组，每组{{disk}}个盘位</h1>
        <h2>总盘位：{{level * group * disk}}</h2>
        <h3>在位：{{loaded}}</h3>
        <div>
            <a href="/index.php/business/bridge">桥接</a>
        </div>
 	    <div ng-repeat="level in levels" style="width:90%; margin: auto; margin-bottom:5px;border:2px solid green;">
          <div ng-repeat = "group in groups" style="width:100%;display:inline-block;">
              <button ng-repeat = "disk in disks" style="width:15%;display:inline-block;" id="disk_{{level}}_{{group}}_{{disk}}">
                  disk-{{level}}-{{group}}-{{disk}}
              </button>
          </div>
        </div>
 		<input ng-model="level">
 		<span>{{level}}</span>
        <a class="btn btn-large" ng-click="bridge('1','1')">查询硬盘状态</a>

 	柜子状态获取中......



        <script>
            $(function() {
                //send disk_info orders

                //check the device status
            });
        </script>
        <script>
            var app = angular.module('device', []);
            app.controller('DeviceStatus', function($scope,$http,$timeout) {
                $scope.level = 13;
                $scope.loaded = 0;
                var proxy = "http://222.35.224.230:8080";
                $http({
                    //url:'http://localhost:10086/index.php/business/getDeviceSize',
                    url:'/Public/js/device.json',
                    method:'GET'
                }).success(function(data) {
                    $scope.levels = data.levels;
                    $scope.groups = data.groups;
                    $scope.disks  = data.disks;
                    $scope.level = data.level;
                    $scope.group = data.group;
                    $scope.disk = data.disk;
                    $scope.queryProgress = data.querying;
                    //$scope.chats = newItems;
                });
                 
                
                

                $scope.sendcmd = function(msg)
                {
                    $http.post(proxy,msg).
                            success(function(data) {
                                // this callback will be called asynchronously
                                // when the response is available
                                return true;
                            }).
                            error(function(data) {
                                // called asynchronously if an error occurs
                                // or server returns response with an error status.
                                console.log("no data sent");
                                return false;
                            });
                }
                var updateDeviceStatus = $timeout(function()
                {
                    if($scope.checkCollision() == 0)
                    {
                        var cmdResult = $scope.devicestatus();
                        if(!cmdResult)
                        {
                            $scope.queryProgress = '通讯异常，请联系维护人员处理。';
                        }
                    } 

                    $http({
                        url:'http://localhost:10086/index.php/business/getDeviceInfo',

                        method:'GET'
                    }).success(function(data) {
                        $scope.loaded = 0;
                        data.forEach(function(e)
                                {
                                    var id = "#disk_"+ e.level + "_"+ e.group + "_"+ e.index;
                                    $(id).addClass("disk_active");
                                    $scope.loaded = $scope.loaded + 1;
                                }
                        );

                    });
                },5000);
                $scope.checkCollision = function(msg)
                {
                    
                    $http({
                        url:'http://localhost:10086/index.php/business/checkCollision',
                        
                        method:'GET'
                    }).success(function(data) {
                        return data['isLegal'];                    
                    });
                }
                $scope.devicestatus = function()
                {
                    var msg = {cmd:'DEVICESTATUS'};
                    return $scope.sendcmd(msg);
                }

                $scope.writeprotect = function(level)
                {
                    var msg = {cmd:"WRITEPROTECT",subcmd:'START',level:level};
                    $scope.sendcmd(msg);
                }
                $scope.bridge = function(level,group)
                {
                    var msg = {cmd:'BRIDGE',subcmd:'START',level:level,group:group,disks:[
                    {id:"1",SN:'0123'}]};
                    $scope.sendcmd(msg);
                }
                $scope.md5 = function(level,group,disk)
                {
                    var msg = {cmd:'MD5',subcmd:'START',level:level,group:group,disk:disk};
                    $scope.sendcmd(msg);
                }
                $scope.copy = function(srcLvl,srcGrp,srcDisk,dstLvl,dstGrp,dstDisk)
                {
                    var msg = {cmd:'COPY',subcmd:'START',srcLevel:srcLvl,srcGroup:srcGrp,srcDisk:srcDisk,dstLevel:dstLvl,dstGroup:dstGrp,dstDisk:dstDisk};
                    $scope.sendcmd(msg);
                }
                $scope.diskinfo = function(level,group,disk)
                {
                    var msg = {cmd:'DISKINFO',level:level,group:group,disk:disk};
                    $scope.sendcmd(msg);
                }
                $scope.power = function(level)
                {
                    var msg = {cmd:'POWER',subcmd:'START',levels:[level]};
                    $scope.sendcmd(msg);
                }
            });

        </script>
 </body>
 </html>