<?php if (!defined('THINK_PATH')) exit();?> <!DOCTYPE html>
 <html lang="en">
 <head>
 	<meta charset="UTF-8">
 	<title>Document</title>

     <script src="/Public/js/jquery-1.11.1.js"></script>
     <script src="http://apps.bdimg.com/libs/angular.js/1.4.6/angular.min.js"></script>
     <link href="//cdn.bootcss.com/bootstrap/4.0.0-alpha.2/css/bootstrap.min.css" rel="stylesheet">

 </head>
 <body ng-app="device" ng-controller="DeviceStatus">

 	    <div ng-repeat="level in levels" style="width:90%; margin: auto; margin-bottom:5px;border:2px solid green;">
          <div ng-repeat = "group in groups" style="width:100%;display:inline-block;">
              <button ng-repeat = "disk in disks" style="width:15%;display:inline-block;">
                  disk-{{level}}-{{group}}-{{disk}}
              </div>
          </div>
        </div>
 		<input ng-model="level">
 		<span>{{level}}</span>
        <a class="btn btn-large" ng-click="bridge(1,1)">查询硬盘状态</a>

 	柜子状态获取中......
 	柜子共6层，每层6组，每组6个盘位


        <script>
            $(function() {
                //send disk_info orders

                //check the device status
            });
        </script>
        <script>
            var app = angular.module('device', []);
            app.controller('DeviceStatus', function($scope,$http) {
                $scope.level = 13;
                var proxy = "someUrl";
                $http({
                    //url:'http://localhost:10086/index.php/business/getDeviceSize',
                    url:'/Public/js/device.json',
                    method:'GET'
                }).success(function(data) {
                    $scope.levels = data.levels;
                    $scope.groups = data.groups;
                    $scope.disks  = data.disks;
                    //$scope.chats = newItems;
                });
                $scope.sendcmd = function(msg)
                {
                    $http.post(proxy,msg).
                            success(function(data) {
                                // this callback will be called asynchronously
                                // when the response is available
                            }).
                            error(function(data) {
                                // called asynchronously if an error occurs
                                // or server returns response with an error status.
                                console.log("no data sent");
                            });
                }

                $scope.devicestatus = function()
                {
                    var msg = {cmd:'DEVICESTATUS'};
                    $scope.sendcmd(msg);
                    

                }
                $scope.writeprotect = function(level)
                {
                    var msg = {cmd:"WRITEPROTECT",subcmd:'START',level:level};
                    $scope.sendcmd(msg);
                }
                $scope.bridge = function(level,group)
                {
                    var msg = {cmd:'BRIDGE',subcmd:'START',level:level,group:group,disks:[
                    {id:1,SN:'0123'}]};
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