<?php if (!defined('THINK_PATH')) exit();?>
<!DOCTYPE html>
<html lang="en">

	<head>
	
		<!-- Basic -->
    	<meta charset="UTF-8" />

		<title>存储柜管理 | 中国国家图书馆</title>
	 
		<!-- Mobile Metas -->
	    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />
		
		<!-- Import google fonts -->
        <link href='http://fonts.useso.com/css?family=Titillium+Web' rel='stylesheet' type='text/css'>
        
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
		<script src="http://apps.bdimg.com/libs/angular.js/1.4.6/angular.min.js"></script>
		
		<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
		<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
		<!--[if lt IE 9]>
			<script src="https://oss.maxcdn.com/html5shiv/3.7.2/html5shiv.min.js"></script>
			<script src="https://oss.maxcdn.com/respond/1.4.2/respond.min.js"></script>
		<![endif]-->		
		
	</head>
	
	<body ng-app="device" ng-controller="DeviceStatus"> 
	
		<!-- Start: Header -->
		<div class="navbar" role="navigation">
			<div class="container-fluid container-nav">
				<!-- Navbar Action -->
				<ul class="nav navbar-nav navbar-actions navbar-left">
					<li class="visible-md visible-lg"><a href="#" id="main-menu-toggle"><i class="fa fa-th-large"></i></a></li>
					<li class="visible-xs visible-sm"><a href="#" id="sidebar-menu"><i class="fa fa-navicon"></i></a></li>			
				</ul>
				<!-- Navbar Left -->
				<div class="navbar-left">
					<!-- Search Form -->					
					<form class="search navbar-form">
						<div class="input-group input-search">
							<input type="text" class="form-control bk-radius" name="q" id="q" placeholder="搜索...">
							<span class="input-group-btn">
								<button class="btn btn-default" type="submit"><i class="fa fa-search"></i></button>
							</span>
						</div>						
					</form>
				</div>
				<!-- Navbar Right -->
				<div class="navbar-right">					
					<!-- Notifications -->
					<ul class="notifications hidden-xs">						
						<li>
							<a href="#" class="dropdown-toggle notification-icon" data-toggle="dropdown">
								<i class="fa fa-tasks"></i>
								<span class="badge">10</span>
							</a>
							<ul class="dropdown-menu update-menu" role="menu">
								<li><a href="#"><i class="fa fa-database bk-fg-primary"></i> Database </a></li>
								<li><a href="#"><i class="fa fa-bar-chart-o bk-fg-primary"></i> Connection </a></li>
								<li><a href="#"><i class="fa fa-bell bk-fg-primary"></i> Notification </a></li>
								<li><a href="#"><i class="fa fa-envelope bk-fg-primary"></i> Message </a></li>
								<li><a href="#"><i class="fa fa-flash bk-fg-primary"></i> Traffic </a></li>
								<li><a href="#"><i class="fa fa-credit-card bk-fg-primary"></i> Invoices </a></li>
								<li><a href="#"><i class="fa fa-dollar bk-fg-primary"></i> Finances </a></li>
								<li><a href="#"><i class="fa fa-thumbs-o-up bk-fg-primary"></i> Orders </a></li>
								<li><a href="#"><i class="fa fa-folder bk-fg-primary"></i> Directories </a></li>
								<li><a href="#"><i class="fa fa-users bk-fg-primary"></i> Users </a></li>		
							</ul>
						</li>
						<li>
							<a href="#" class="dropdown-toggle notification-icon" data-toggle="dropdown">
								<i class="fa fa-envelope"></i>
								<span class="badge">5</span>
							</a>
							<ul class="dropdown-menu">
								<li class="dropdown-menu-header">
									<strong>Messages</strong>
									<div class="progress progress-xs  progress-striped active">
										<div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
											60%
										</div>
									</div>
								</li>
								<li class="avatar">
									<a href="page-inbox.html">
										<img class="avatar" src="/Public/assets/img/avatar1.jpg" alt="" />
										<div><div class="point point-primary point-lg"></div>New message</div>
										<span><small>1 minute ago</small></span>							
									</a>
								</li>
								<li class="avatar">
									<a href="page-inbox.html">
										<img class="avatar" src="/Public/assets/img/avatar2.jpg" alt="" />
										<div><div class="point point-primary point-lg"></div>New message</div>
										<span><small>3 minute ago</small></span>								
									</a>
								</li>
								<li class="avatar">
									<a href="page-inbox.html">
										<img class="avatar" src="/Public/assets/img/avatar3.jpg" alt="" />
										<div><div class="point point-primary point-lg"></div>New message</div>
										<span><small>4 minute ago</small></span>								
									</a>
								</li>
								<li class="avatar">
									<a href="page-inbox.html">
										<img class="avatar" src="/Public/assets/img/avatar4.jpg" alt="" />
										<div><div class="point point-primary point-lg"></div>New message</div>
										<span><small>30 minute ago</small></span>
									</a>
								</li>
								<li class="avatar">
									<a href="page-inbox.html">
										<img class="avatar" src="/Public/assets/img/avatar5.jpg" alt="" />
										<div><div class="point point-primary point-lg"></div>New message</div>
										<span><small>1 hours ago</small></span>
									</a>
								</li>						
								<li class="dropdown-menu-footer text-center">
									<a href="page-inbox.html">View all messages</a>
								</li>	
							</ul>
						</li>
						<li>
							<a href="#" class="dropdown-toggle notification-icon" data-toggle="dropdown">
								<i class="fa fa-bell"></i>
								<span class="badge">3</span>
							</a>
							<ul class="dropdown-menu list-group">
								<li class="dropdown-menu-header">
									<strong>Notifications</strong>
									<div class="progress progress-xs  progress-striped active">
										<div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
											60%
										</div>
									</div>
								</li>
								<li class="list-item">
									<a href="page-inbox.html">
										<div class="pull-left">
										   <i class="fa fa-envelope-o bk-fg-primary"></i>
										</div>
										<div class="media-body clearfix">
											<div>Unread Message</div>
											<h6>You have 10 unread message</h6>
										</div>								
									</a>
								</li>
								<li class="list-item">
									<a href="#">
										<div class="pull-left">
										   <i class="fa fa-cogs bk-fg-primary"></i>
										</div>
										<div class="media-body clearfix">
											<div>New Settings</div>
											<h6>There are new settings available</h6>
										</div>								
									</a>
								</li>
								<li class="list-item">
									<a href="#">
										<div class="pull-left">
										   <i class="fa fa-fire bk-fg-primary"></i>
										</div>
										<div class="media-body clearfix">
											<div>Update</div>
											<h6>There are new updates available</h6>
										</div>								
									</a>
								</li>
								<li class="list-item-last">
									<a href="#">
									  <h6>Unread notifications</h6>
									  <span class="badge">15</span>
									</a>
								</li>
							</ul>
						</li>
					</ul>
					<!-- End Notifications -->					
					<!-- Userbox -->
					<div class="userbox">
						<a href="#" class="dropdown-toggle" data-toggle="dropdown">
							<!--<figure class="profile-picture hidden-xs">
								<img src="/Public/assets/img/avatar.jpg" class="img-circle" alt="" />
							</figure>-->
							<div class="profile-info">
								<span class="name">管理员</span>
								<span class="role"><i class="fa fa-circle bk-fg-success"></i> 高级权限</span>
							</div>			
							<i class="fa custom-caret"></i>
						</a>
						<div class="dropdown-menu">
							<ul class="list-unstyled">
								<li class="dropdown-menu-header bk-bg-white bk-margin-top-15">						
									<div class="progress progress-xs  progress-striped active">
										<div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
											60%
										</div>
									</div>							
								</li>	
								<li>
									<a href="page-profile.html"><i class="fa fa-user"></i> Profile</a>
								</li>
								<li>
									<a href="#"><i class="fa fa-wrench"></i> Settings</a>
								</li>
								<li>
									<a href="page-invoice"><i class="fa fa-usd"></i> Payments</a>
								</li>
								<li>
									<a href="#"><i class="fa fa-file"></i> File</a>
								</li>
								<li>
									<a href="page-login.html"><i class="fa fa-power-off"></i> Logout</a>
								</li>
							</ul>
						</div>						
					</div>
					<!-- End Userbox -->
				</div>
				<!-- End Navbar Right -->
			</div>		
		</div>
		<!-- End: Header -->
        <div class="copyrights">汉龙思琪</div>
		
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
										<a href="index.html">
											<i class="fa fa-laptop" aria-hidden="true"></i><span>主页</span>
										</a>
									</li>
									<li>
										<a href="mailbox-inbox.html">
											<span class="pull-right label label-success">100</span>
											<i class="fa  fa-heart" aria-hidden="true"></i><span>健康</span>
										</a>
									</li>
									<li>
										<a>
											<i class="fa  fa-cogs" aria-hidden="true"></i><span>环境</span>
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
					<div class="sidebar-footer">					
						<div class="small-chart-visits">
							<!--<div class="small-chart" id="sparklineLineVisits"></div><script type="text/javascript">
								var sparklineLineVisitsData = [15, 16, 17, 19, 15, 25, 23, 35, 29, 15, 30, 45];
							</script>-->
							<div class="small-chart-info">
								<label>登录时间</label>
								<strong>14:22 2016.03.09</strong>
							</div>

						</div>
						<!--<ul class="sidebar-terms bk-margin-top-10">
							<li><a href="#">Terms</a></li>
							<li><a href="#">Privacy</a></li>
							<li><a href="#">Help</a></li>
							<li><a href="#">About</a></li>
						</ul>-->
					</div>
					<!-- End Sidebar Footer-->
				</div>
				<!-- End Sidebar -->
						
				<!-- Main Page -->
				<div class="main ">
					<!-- Page Header -->
					<div class="page-header">
						<div class="pull-left">
							<ol class="breadcrumb visible-sm visible-md visible-lg">								
								<li><a href="index.html"><i class="icon fa fa-home"></i>主页</a></li>
								<li class="active"><i class="fa fa-laptop"></i>存储柜管理</li>
							</ol>						
						</div>
						<div class="pull-right">
							<h2>存储柜管理</h2>
						</div>					
					</div>
					<!-- End Page Header -->

			<div class="row">                       
                        <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                            <div class="panel panel-default bk-bg-white">
                                <div class="panel-heading bk-bg-white">
                                    <h6><i class="fa fa-table red"></i><span class="break"></span>文件树</h6>                            
                                    <div class="panel-actions">
                                        <a href="#" class="btn-minimize"><i class="fa fa-caret-up"></i></a>
                                        <a href="#" class="btn-close"><i class="fa fa-times"></i></a>
                                    </div>
                                </div>
                                <div class="panel-body">
									<div>
										<ol class="breadcrumb visible-sm visible-md visible-lg" id="navBar">
											<li>
												<button class="btn btn-link btn-xs" type="button" id="btnUp">
													<i class="fa  fa-arrow-up"></i>
												</button>
											</li>
										</ol>
									</div>
                                    <table class="table table-bordered table-striped" id="datatable-my">
                                        <thead>
                                            <tr>
                                                <th>名称</th>
                                                <th>修改日期</th>
                                                <th>类型</th>
                                                <th>大小</th>
						<th>dir</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                        </tbody>
                                    </table>
                                </div>
                            </div>
                        </div>
			</div>

					<div class="row">
                        <!--<div class="col-lg-6 col-md-12 col-sm-12 col-xs-12">
                            <div class="panel bk-widget bk-border-off">
                                <div class="panel-body text-left bk-bg-white bk-padding-top-10 bk-padding-bott0">
                                    <div class="row">
                                        <div class="col-xs-4 bk-vcenter text-center">
                                            <div class="small-chart-wrapper">
                                                <div class="small-chart" id="sparklineBarweeklystats"></div>
                                                <script type="text/javascript">
                                                    var sparklineBarweeklystatsData = [5, 6, 7, 2, 0, 4 , 2, 4, 2, 0, 4 , 2, 4, 2, 0, 4];
                                                </script>
                                            </div>
                                            <strong>Weekly stats</strong>
                                        </div>
                                        <div class="col-xs-8 text-left bk-vcenter text-center">
                                            <small>DOWNLOAD: 60%</small>
                                            <div class="progress light progress-xs  progress-striped active bk-margin-bottom-10">
                                                <div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                                                    <span class="sr-only">60% Complete</span>
                                                </div>
                                            </div>
                                            <small>PROCESSED: 88%</small>
                                            <div class="progress light progress-xs  progress-striped active bk-margin-bottom-10">
                                                <div class="progress-bar progress-bar-warning" role="progressbar" aria-valuenow="88" aria-valuemin="0" aria-valuemax="100" style="width: 88%;">
                                                    <span class="sr-only">88% Complete</span>
                                                </div>
                                            </div>
                                            <small>SALE: 60%</small>
                                            <div class="progress light progress-xs  progress-striped active bk-margin-bottom-10">
                                                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                                                    <span class="sr-only">60% Complete</span>
                                                </div>
                                            </div>
                                        </div>
									</div>
								</div>
							</div>
						</div>	-->
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<div class="panel bk-widget bk-border-off">
								<div class="panel-body bk-bg-primary">
									<h4 class="bk-margin-off-bottom bk-docs-font-weight-300">总盘位</h4>
									<div class="clearfix  bk-padding-top-10">
										<div class="pull-right bk-margin-left-15">
											<i class="fa fa-hdd-o fa-3x"></i>
										</div>
										<h1 class="bk-margin-off-top pull-right">144</h1>
									</div>									
									<a><h6 class="text-right bk-padding-top-20 bk-margin-off">共{{level}}层，每层{{group}}组，每组{{disknum}}个盘位</h6></a>
								</div>
							</div>
						</div>
						<div class="col-lg-3 col-md-6 col-sm-6 col-xs-12">
							<div class="panel bk-widget bk-border-off">
								<div class="panel-body bk-bg-success">
									<h4 class="bk-margin-off-bottom bk-docs-font-weight-300" >在位数</h4>
                                    <div class="clearfix  bk-padding-top-10">
                                        <div class="pull-right bk-margin-left-15">
                                            <i class="fa fa-hdd-o fa-3x"></i>
                                        </div>
                                        <h1 class="bk-margin-off-top pull-right">50</h1>
                                    </div>
                                    <h4 class="text-right bk-padding-top-15 bk-margin-off">14分钟前</h4>
								</div>
							</div>
						</div>
					</div>
                    <div class="row">
                        <div class="col-lg-8 col-md-8 col-sm-8 col-xs-12">
                            <div class="tabs tabs-vertical tabs-left">
                                <ul class="nav nav-tabs col-sm-3 col-xs-5">
                                    <li class="active">
                                        <a data-toggle="tab" href="#pane-level1"><i class=" glyphicon glyphicon-align-justify"></i> 第1层</a>
                                    </li>
                                    <li ng-repeat="level in levels">
                                        <a data-toggle="tab" href="#pane-level{{level}}"><i class=" glyphicon glyphicon-align-justify"></i> 第{{level}}层</a>
                                    </li>
                                    
                                </ul>
                                <div class="tab-content">
                                    <div class="tab-pane active" id="pane-level1">
                                        <div class="row  bk-padding-10" ng-repeat="group in groups" id = "group{{group}}">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" ng-repeat = "disk in disks">
                                                <a class="btn btn-block btn-primary" href="#" id="disk-1-{{group}}-{{disk}}"><i class=" glyphicon glyphicon-hdd"></i> DISK #{{group}}-{{disk}}</a>
                                            </div>
                                        </div>
                                    </div>
                                    <div ng-repeat="level in levels" class="tab-pane" id="pane-level{{level}}">
                                        <div class="row  bk-padding-10" ng-repeat="group in groups" id = "group{{group}}">
                                            <div class="col-lg-3 col-md-3 col-sm-3 col-xs-3" ng-repeat = "disk in disks">
                                            	<a class="btn btn-block btn-primary" href="#" id="disk-{{level}}-{{group}}-{{disk}}"><i class="glyphicon glyphicon-hdd"></i> DISK #{{group}}-{{disk}}</a>
                                            </div>                                            
                                        </div>
                                    </div>
                                    
                                </div>
                            </div>
                            <div class="row"><!--硬盘信息-->
                                <div class="col-lg-12">
                                    <div class="panel panel-default bk-bg-white">
                                        <div class="panel-heading bk-bg-white">
                                            <h6><i class="fa  fa-info-circle red"></i><span class="break"></span>硬盘信息</h6>
                                            <div class="panel-actions">
                                                <a class="btn-minimize" href="#"><i class="fa fa-caret-up"></i></a>
                                            </div>
                                        </div>
                                        <div class="panel-body">
                                            <div class="table-responsive">
                                                <table class="table table-hover">

                                                    <tbody>

                                                    <tr>
                                                        <td>位号</td>
                                                        <td>{{disk.level}}-{{disk.group}}-{{disk.index}}</td>
                                                        </tr>
                                                    <tr>
                                                        <td>容量</td>
                                                        <td>{{disk.capability}}</td>
                                                    </tr>
                                                    <tr>
                                                        <td>SN号</td>
                                                        <td>{{disk.sn}}</td>
                                                        </tr>
                                                    <tr>
                                                        <td>健康状况</td>
                                                        <td>{{disk.health}}</td>
                                                    </tr>
                                                    <tr>
                                                        <td>首次校验值</td>
                                                        <td>{{disk.md5}}</td>
                                                    </tr>
                                                    <tr>
                                                        <td>检测时间</td>
                                                        <td>{{disk.first_check_time}}</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            上次校验值
                                                        </td>
                                                        <td>{{disk.last_md5}}</td>
                                                    </tr>
                                                    <tr>
                                                        <td>检测时间</td>
                                                        <td>2015-12-20 12:30</td>
                                                    </tr>
                                                    <tr>
                                                        <td>
                                                            本次校验值
                                                        </td>
                                                        <td>{{disk.md5}}</td>
                                                    </tr>
                                                    <tr>
                                                        <td>检测时间</td>
                                                        <td>2015-12-20 12:30</td>
                                                    </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-lg-4 col-md-4 col-sm-4 col-xs-12">
                            <div class="tabs tabs-vertical tabs-right tabs-primary">
                                <div class="tab-content">
                                    <div class="tab-pane active" id="home12">
                                        已选择硬盘：#1-1-1
                                        <a class="btn btn-small btn-primary" href="#">桥接</a>
                                    </div>
                                    <div class="tab-pane" id="profile12">
                                        <p>Profile</p>
                                        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitat.</p>
                                    </div>
                                </div>
                                <ul class="nav nav-tabs col-sm-3 col-xs-5">
                                    <li class="active">
                                        <a data-toggle="tab" href="#home12"><i class="fa fa-link"></i> 桥接</a>
                                    </li>
                                    <li>
                                        <a data-toggle="tab" href="#profile12"><i class="fa fa-copy"></i> 复制</a>
                                    </li>
                                    <li>
                                        <a data-toggle="tab" href="#profile12"><i class="fa fa-eye"></i> 校验</a>
                                    </li>
                                    <li>
                                        <a data-toggle="tab" href="#profile12"><i class="fa fa-refresh"></i> 刷新</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>

					

					


				</div>
				<!-- End Main Page -->
				
				<!-- Footer -->
				<div id="footer">
					<ul>
						<li>
							<div class="title">Memory</div>
							<div class="bar">
								<div class="progress light progress-sm  progress-striped active">
									<div class="progress-bar progress-squared progress-bar-success" role="progressbar" aria-valuenow="60" aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
										60%
									</div>
								</div>
							</div>			
							<div class="desc">4GB of 8GB</div>
						</li>
						<li>
							<div class="title">HDD</div>
							<div class="bar">
								<div class="progress light progress-sm  progress-striped active">
									<div class="progress-bar progress-squared progress-bar-primary" role="progressbar" aria-valuenow="40" aria-valuemin="0" aria-valuemax="100" style="width: 40%;">
										40%
									</div>
								</div>
							</div>			
							<div class="desc">250GB of 1TB</div>
						</li>
						<li>
							<div class="title">SSD</div>
							<div class="bar">
								<div class="progress light progress-sm  progress-striped active">
									<div class="progress-bar progress-squared progress-bar-warning" role="progressbar" aria-valuenow="70" aria-valuemin="0" aria-valuemax="100" style="width: 70%;">
										70%
									</div>
								</div>
							</div>			
							<div class="desc">700GB of 1TB</div>
						</li>
						<li>
							<div class="copyright">
								<p class="text-muted text-right">Fire <i class="fa fa-coffee"></i> Collect from <a href="http://www.cssmoban.com/" title="网页模板" target="_blank">网页模板</a> - More Templates <a href="http://www.cssmoban.com/" target="_blank" title="模板之家">模板之家</a></p>
							</div>
						</li>				
					</ul>	
				</div>
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
		<script src="/Public/assets/plugins/fullcalendar/js/fullcalendar.js"></script>
		<script src="/Public/assets/plugins/flot/js/jquery.flot.min.js"></script>
		<script src="/Public/assets/plugins/flot/js/jquery.flot.pie.min.js"></script>
		<script src="/Public/assets/plugins/flot/js/jquery.flot.resize.min.js"></script>
		<script src="/Public/assets/plugins/flot/js/jquery.flot.stack.min.js"></script>
		<script src="/Public/assets/plugins/flot/js/jquery.flot.time.min.js"></script>
		<script src="/Public/assets/plugins/flot-tooltip/js/jquery.flot.tooltip.js"></script>
		<script src="/Public/assets/plugins/chart-master/js/Chart.js"></script>
		<script src="/Public/assets/plugins/jqvmap/jquery.vmap.js"></script>
		<script src="/Public/assets/plugins/jqvmap/data/jquery.vmap.sampledata.js"></script>
		<script src="/Public/assets/plugins/jqvmap/maps/jquery.vmap.world.js"></script>
		<script src="/Public/assets/plugins/sparkline/js/jquery.sparkline.min.js"></script>
		<script src="/Public/assets/plugins/select2/select2.js"></script>
                <script src="/Public/assets/plugins/jquery-datatables/media/js/jquery.dataTables.js"></script>
                <script src="/Public/assets/plugins/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
                <script src="/Public/assets/plugins/jquery-datatables-bs3/js/datatables.js"></script>
		<!-- Theme JS -->		
		<script src="/Public/assets/js/jquery.mmenu.min.js"></script>
		<script src="/Public/assets/js/core.min.js"></script>
		
		<!-- Pages JS -->
		<script src="/Public/assets/js/pages/index.js"></script>
        
		<script>
            var app = angular.module('device', []);
            app.controller('DeviceStatus', function($scope,$http,$timeout) {
                $scope.level = 13;
                $scope.loaded = 0;
                var server = "http://localhost:10086/index.php/business/AddCmdLog";
                var proxy = "http://localhost:8080";
              
  				$scope.levels = [2,3,4,5,6];
                    $scope.groups = [2,3,4,5,6];
                    $scope.disks  = [1,2,3,4];
                    $scope.level = 6;
                    $scope.group = 6;
                    $scope.disknum = 4;
                $scope.disk = {'level':1,'group':1,'index':1,'capability':'查询中...','sn':'查询中...','md5':'查询中'};
                $scope.sendcmd = function(msg)
                {
                    console.log('sending command.');
                    //先发送消息告知服务器即将发送指令；
                    $http.post(server,msg).
                            success(function(data) {
                                console.log("Server have received the message.");
                                if(data['errmsg'] == 1)
                                {
                                    console.log("Server failed to update the log.");
                                    return;
                                }
                                //服务器收到通知后，联系APP，发送指令；
                                $http.post(proxy,msg).
                                        success(function(data) {

                                            return true;
                                        }).
                                        error(function(data) {
                                            console.log("no data sent");
                                            return false;
                                        });
                            }).
                            error(function(data) {
                                // called asynchronously if an error occurs
                                // or server returns response with an error status.
                                console.log("server error");
                                return false;
                            });

                }
                $http({
                    url:'http://localhost:10086/index.php/business/getDeviceInfo',
                   method:'GET'
                }).success(function(data) {
                    $scope.loaded = 0;
                    data.forEach(function(e)
                            {
                                var id = "#disk-"+ e.level + "-"+ e.group + "-"+ e.index;
                                 $(id).removeClass("primary").addClass("default");
                                $scope.loaded = $scope.loaded + 1;
                            }
                    );

                });
                var updateDeviceStatus = $timeout(function()
                {
                    $http({
                        url:'http://localhost:10086/index.php/business/checkCollision',
                        
                        method:'GET'
                    }).success(function(data) {
                        if(data['isLegal'] == 1)
                        {
                            $scope.devicestatus();
                        
                        }                 
                    });
                        
                    

                    $http({
                        url:'http://localhost:10086/index.php/business/getDeviceInfo/type/1',

                        method:'GET'
                    }).success(function(data) {
                        $scope.loaded = 0;
                        data.forEach(function(e)
                                {
                                    var id = "#disk-"+ e.level + "-"+ e.group + "-"+ e.index;
                                    $(id).removeClass("primary").addClass("default");
                                    $scope.loaded = $scope.loaded + 1;
                                }
                        );

                    });
                },5000);

                $scope.checkCollision = function()
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
		<!-- end: JavaScript-->
		
	</body>
	
</html>