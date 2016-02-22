<?php if (!defined('THINK_PATH')) exit();?> <!DOCTYPE html>
 <html lang="en">
 <head>
 	<meta charset="UTF-8">
 	<title>Document</title>
 	<script src="//cdn.bootcss.com/jquery/3.0.0-beta1/jquery.min.js"></script>
 	<script src="//cdn.bootcss.com/ionic/1.2.4/js/angular/angular.min.js"></script>

 
 	<script>
 	 $(function() {
         //send disk_info orders

         //check the device status   
        });
 	</script>
 </head>
 <body ng-app="device" ng-controller="DeviceStatus">
 	
 		<input ng-model="level">
 		<span>{{level}}</span>

 	柜子状态获取中......
 	柜子共6层，每层6组，每组6个盘位
	 <script>
		var app = angular.module('device', []);
		app.controller('DeviceStatus', function($scope,$http) {
		    $scope.level = 13;
		     $http({
		      url:'http://localhost:10086/index.php/business/getDeviceSize',
		      method:'GET'
		      }).success(function(data) {
		       $scope.level = data.level;
		       //$scope.chats = newItems;
		     });
		  });
	</script>
 </body>
 </html>