<?php if (!defined('THINK_PATH')) exit();?>﻿<!DOCTYPE html>
<html lang="en">

	<head>
	
		<!-- Basic -->
    	<meta charset="UTF-8" />

		<title>存储柜管理 | 中国国家图书馆</title>
	 
		<!-- Mobile Metas -->
	    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		
		<!-- Import google fonts -->

        
		<!-- Favicon and touch icons -->
		<link rel="shortcut icon" href="/Public/assets/ico/favicon.ico" type="image/x-icon" />
		<link rel="apple-touch-icon" href="/Public/assets/ico/apple-touch-icon.png" />
		<link rel="apple-touch-icon" sizes="57x57" href="/Public/assets/ico/apple-touch-icon-57x57.png" />
		<link rel="apple-touch-icon" sizes="72x72" href="/Public/assets/ico/apple-touch-icon-72x72.png" />
		<link rel="apple-touch-icon" sizes="76x76" href="/Public/assets/ico/apple-touch-icon-76x76.png" />
		<link rel="apple-touch-icon" sizes="114x114" href="/Public/assets/ico/apple-touch-icon-114x114.png" />
		<link rel="apple-touch-icon" sizes="120x120" href="/Public/assets/ico/apple-touch-icon-120x120.png" />
		<link rel="apple-touch-icon" sizes="144x144" href="/Public/assets/ico/apple-touch-icon-144x144.png" />
		<link rel="apple-touch-icon" sizes="152x152" href="/Public/assets/ico/apple-touch-icon-152x152.png" />
		
	    <!-- start: CSS file-->
		
		<!-- Vendor CSS-->
		<link href="/Public/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
		<link href="/Public/assets/vendor/skycons/css/skycons.css" rel="stylesheet" />
		<link href="/Public/assets/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
		<link href="/Public/assets/vendor/css/pace.preloader.css" rel="stylesheet" />
		
		<!-- Plugins CSS-->
		<link href="/Public/assets/plugins/jquery-ui/css/jquery-ui-1.10.4.min.css" rel="stylesheet" />	
		<link href="/Public/assets/plugins/scrollbar/css/mCustomScrollbar.css" rel="stylesheet" />
		<link href="/Public/assets/plugins/bootkit/css/bootkit.css" rel="stylesheet" />
		<link href="/Public/assets/plugins/magnific-popup/css/magnific-popup.css" rel="stylesheet" />
		<link href="/Public/assets/plugins/fullcalendar/css/fullcalendar.css" rel="stylesheet" />
		<link href="/Public/assets/plugins/jqvmap/jqvmap.css" rel="stylesheet" />
		
		<!-- Theme CSS -->
		<link href="/Public/assets/css/jquery.mmenu.css" rel="stylesheet" />
		
		<!-- Page CSS -->		
		<link href="/Public/assets/css/style.css" rel="stylesheet" />
		<link href="/Public/assets/css/add-ons.min.css" rel="stylesheet" />
		
		<!-- end: CSS file-->	
	    
		
		<!-- Head Libs -->
		<script src="/Public/assets/plugins/modernizr/js/modernizr.js"></script>
		<script src="/Public/js/angular-1.4.min.js"></script>
		
		<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
			<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
			<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->		
		
	</head>

	<body ng-app="device" ng-controller="statusMonitor  as showCase">
	
		<!-- Start: Header -->

		
		<!-- Start: Content -->
		<div class="container-fluid content">	
			<div class="row">
			
				<!-- Sidebar -->
				<div class="sidebar">
					<div class="sidebar-collapse">
						<!-- Sidebar Header Logo-->
						<div class="sidebar-header">
							<img src="/Public/assets/img/logo-text.png" class="img-responsive" alt="" />
						</div>
						<!-- Sidebar Menu-->
						<div class="sidebar-menu">						
							<nav id="menu" class="nav-main" role="navigation">
								<ul class="nav nav-sidebar">
									<div class="panel-body text-center">								
										<div class="flag">
											<img src="/Public/assets/img/logo.png" class="img-flags" alt="" />
										</div>
									</div>
									<li class="active">
										<a href="/index.php?m=Admin&c=business">
											<i class="fa fa-laptop" aria-hidden="true"></i><span>主页</span>
										</a>
									</li>

                                    <li>
                                        <a>
                                            <i class="fa  fa-hand-o-left" aria-hidden="true"></i><span>退出</span>
                                        </a>
                                    </li>

								</ul>
							</nav>
						</div>
						<!-- End Sidebar Menu-->
					</div>
					<!-- Sidebar Footer-->

					<!-- End Sidebar Footer-->
				</div>
				<!-- End Sidebar -->
						
				<!-- Main Page -->
				<div class="main ">
					<!-- Page Header -->
					<div class="page-header">
						<div class="pull-left">
							<ol class="breadcrumb visible-sm visible-md visible-lg">								
								<li><a href="index.html"><i class="icon fa fa-home"></i>存储柜管理</a></li>
								<li class="active"><i class="fa fa-laptop"></i>系统初始化</li>
							</ol>						
						</div>
						<div class="pull-right">
							<h2>系统初始化</h2>
						</div>					
					</div>
					<div class="row">
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<a href="" class="btn btn-block btn-success" ng-click="systReset();">系统重置</a>
							<p class="help-block">{{info1}}{{info2}}</p>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<a href="" class="btn btn-block btn-success" ng-click="initCab();">获取存储柜信息</a>
							<p class="help-block">{{info1}}{{info2}}</p>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<a href="" class="btn btn-block btn-success" ng-click="cmd.devicestatus();">获取在位信息</a>
							<p class="help-block">{{info1}}{{info2}}</p>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<a href="" class="btn btn-block btn-success" ng-click="deviceInit();">获取插槽详情</a>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<a href="" class="btn btn-block btn-danger" ng-click="initStop();"><i class="fa fa-stop"></i> 停止初始化</a>
						</div>
					</div>
					<div class="row">
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<a href="" class="btn btn-block btn-danger" ng-click="cmd.testPost();">POST处理测试</a>
							<p class="help-block">{{info}}</p>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<a href="" class="btn btn-block btn-danger" ng-click="cmd.localTest(to_post);">本地测试</a>
							<p class="help-block">{{info}}</p>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<input type="text" ng-model="testCmdId">{{testCmdId}}
						</div>
					</div>
					<div class="row">
						<div class="col-lg-12 col-md-12 col-sm-6 col-xs-12">
							<input type="text" ng-model="to_post">{{to_post}}
						</div>
					</div>
					<div class="container-fluid content">
						<div class="row">
							<div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
								<div class="tabs tabs-horizontal tabs-left ">
									<ul class="nav nav-tabs">
										<li class="active"><a href="#goingTasks" data-toggle="tab"><i class="fa fa-clock-o"></i>
											进行中任务 <span class="badge badge-success" ng-bind="taskPool.going.length"
														ng-show="taskPool.showGoing();"></span></a></li>
										<li><a href="#doneTasks" data-toggle="tab"><i class="fa fa-check"></i> 已完成任务 <span
												class="badge badge-danger" ng-bind="taskPool.done.length"
												ng-show="taskPool.showDone();"></span></a></li>
									</ul>
									<div class="tab-content">
										<div class="tab-pane panel panel-default bk-bg-white active" id="goingTasks">
											<div ng-include="goingTaskUrl"></div>
										</div>
										<div class="tab-pane panel panel-default bk-bg-white" id="doneTasks">
											<div ng-include="doneTaskUrl"></div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
				<!-- End Main Page -->
				
				<!-- Footer -->
				<!-- End Footer -->
			
			</div>
		</div><!--/container-->
		
		
		<div class="clearfix"></div>		
		
		
		<!-- start: JavaScript-->


		<!-- Vendor JS-->
		<script src="/Public/assets/vendor/js/jquery.min.js"></script>
		<script src="/Public/assets/vendor/js/jquery-2.1.1.min.js"></script>
		<script src="/Public/assets/vendor/js/jquery-migrate-1.2.1.min.js"></script>
		<script src="/Public/assets/vendor/bootstrap/js/bootstrap.min.js"></script>
		<script src="/Public/assets/vendor/skycons/js/skycons.js"></script>
		<script src="/Public/assets/vendor/js/pace.min.js"></script>

		<!-- Plugins JS-->
		<script src="/Public/assets/plugins/jquery-ui/js/jquery-ui-1.10.4.min.js"></script>
		<script src="/Public/assets/plugins/scrollbar/js/jquery.mCustomScrollbar.concat.min.js"></script>
		<script src="/Public/assets/plugins/bootkit/js/bootkit.js"></script>
		<script src="/Public/assets/plugins/magnific-popup/js/magnific-popup.js"></script>
		<script src="/Public/assets/plugins/moment/js/moment.min.js"></script>

		<script src="/Public/assets/plugins/select2/select2.js"></script>
		<script src="/Public/assets/plugins/jquery-datatables/media/js/jquery.dataTables.js"></script>
		<script src="/Public/assets/plugins/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
		<script src="/Public/assets/plugins/jquery-datatables-bs3/js/datatables.js"></script>
		<!-- Theme JS -->
		<script src="/Public/assets/js/jquery.mmenu.min.js"></script>
		<script src="/Public/assets/js/core.min.js"></script>

		<!-- Pages JS -->
		<script src="/Public/assets/js/pages/ui-modals.js"></script>
		<script src="/Public/assets/plugins/jquery-validation/js/jquery.validate.js"></script>
		<script src="/Public/assets/plugins/pnotify/js/pnotify.custom.js"></script>

		<!-- global variables define -->
		<script src="/Public/js/cabinet/globalvars.js"></script>

		<!-- 用于前端命令处理 -->
		<script src="/Public/js/cabinet/CabCmd.js"></script>
		<script src="/Public/js/cabinet/CabCmdHelper.js"></script>
		<script src="/Public/js/cabinet/TaskPool.js"></script>
		<script src="/Public/js/cabinet/cabinethelper.js"></script>
		<script src="/Public/js/cabinet/deployer.js"></script>
		<!-- cabinet.js 必须放到 globaljs.js之前 -->
		<script src="/Public/js/cabinet/Disk.js"></script>
		<script src="/Public/js/cabinet/cabinet.js"></script>

		<script src="/Public/js/cabinet/globaljs.js"></script>

		<!-- page_init.js 必须放到 globaljs.js之后 -->
		<script src="/Public/js/cabinet/page_init.js"></script>
		<script src="/Public/js/cabinet/services.js"></script>

		<script src="/Public/js/angular-datatables.min.js"></script>
		<!-- end: JavaScript-->


	</body>

</html>