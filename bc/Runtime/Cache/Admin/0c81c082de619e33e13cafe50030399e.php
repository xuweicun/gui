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
 	    <div ng-repeat="item in level"></div>
 		<input ng-model="level">
 		<span>{{level}}</span>
        <a class="btn btn-large" ng-click="diskinfo(1,1,1)">查询硬盘状态</a>

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

                $http({
                    //url:'http://localhost:10086/index.php/business/getDeviceSize',
                    url:'/Public/js/device.json',
                    method:'GET'
                }).success(function(data) {
                    $scope.level = data.device_level;
                    //$scope.chats = newItems;
                });
                $scope.diskInfo = function(level,group,index)
                {

                    alert("I'm working");

                }
            });

        </script>
 </body>
 </html>