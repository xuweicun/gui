<?php if (!defined('THINK_PATH')) exit();?>﻿<!DOCTYPE html>
<html lang="en">

<head>

    <!-- Basic -->
    <meta charset="UTF-8"/>

    <title>存储柜管理 | 中国国家图书馆</title>

    <!-- Mobile Metas -->
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no"/>

    <!-- Import google fonts -->


    <!-- start: CSS file-->

    <!-- Vendor CSS-->
    <link href="/Public/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="/Public/assets/vendor/skycons/css/skycons.css" rel="stylesheet"/>
    <link href="/Public/assets/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet"/>
    <link href="/Public/assets/vendor/css/pace.preloader.css" rel="stylesheet"/>

    <!-- Plugins CSS-->
    <link href="/Public/assets/plugins/jquery-ui/css/jquery-ui-1.10.4.min.css" rel="stylesheet"/>
    <link href="/Public/assets/plugins/scrollbar/css/mCustomScrollbar.css" rel="stylesheet"/>
    <link href="/Public/assets/plugins/bootkit/css/bootkit.css" rel="stylesheet"/>
    <link href="/Public/assets/plugins/magnific-popup/css/magnific-popup.css" rel="stylesheet"/>
    <link href="/Public/assets/plugins/fullcalendar/css/fullcalendar.css" rel="stylesheet"/>
    <link href="/Public/assets/plugins/jqvmap/jqvmap.css" rel="stylesheet"/>
    <link href="/Public/assets/plugins/pnotify/css/pnotify.custom.css" rel="stylesheet"/>
    <link href="/Public/assets/plugins/select2/select2.css" rel="stylesheet" />
    <link href="/Public/assets/plugins/jquery-datatables-bs3/css/datatables.css" rel="stylesheet" />		
    <!-- Theme CSS -->
    <link href="/Public/assets/css/jquery.mmenu.css" rel="stylesheet"/>

    <!-- Page CSS -->
    <link href="/Public/assets/css/jquery.dataTables.min.css" rel="stylesheet" />
    <link href="/Public/assets/css/angular-datatables.min.css" rel="stylesheet" />
    <link href="/Public/assets/css/datatables.bootstrap.min.css" rel="stylesheet" />
    <link href="/Public/assets/css/style.css" rel="stylesheet"/>
    <link href="/Public/assets/css/add-ons.min.css" rel="stylesheet"/>

    <!-- end: CSS file-->


    <!-- Head Libs -->
    <script src="/Public/assets/plugins/modernizr/js/modernizr.js"></script>
    <style>
        li.selected a {
            background-color: green;
        }
        div.selected{
            border: 2px solid darkred !important;
        }
        .btn-selected {
            border: 2px solid darkred !important;
            color: darkred;
        }
        .btn-not-selected {
            border: 2px solid lightgray !important;
        }

        body {
            min-height: 1000px;
        }
    </style>
    <!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
    <!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
    <!--[if lt IE 9]>


    <![endif]-->

</head>


<body ng-app="device" ng-controller="statusMonitor  as showCase">
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
            <ul class="notifications hidden-xs" style="display:none;">
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
                                <div class="progress-bar progress-bar-success" role="progressbar" aria-valuenow="60"
                                     aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                                    60%
                                </div>
                            </div>
                        </li>
                        <li class="avatar">
                            <a href="page-inbox.html">
                                <img class="avatar" src="/Public/assets/img/avatar1.jpg" alt=""/>

                                <div>
                                    <div class="point point-primary point-lg"></div>
                                    New message
                                </div>
                                <span><small>1 minute ago</small></span>
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
                                <div class="progress-bar progress-bar-danger" role="progressbar" aria-valuenow="60"
                                     aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
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
                        <span class="name" id="username">您好,<?php echo ($username); ?></span>
                        <span class="role"><i class="fa fa-circle bk-fg-success"></i> 高级权限</span>
                        <input type="text" value="<?php echo ($userid); ?>" style="display: none;" id="userid">
                    </div>
                    <i class="fa custom-caret"></i>
                </a>

                <div class="dropdown-menu">
                    <ul class="list-unstyled">
                        <li class="dropdown-menu-header bk-bg-white bk-margin-top-15">
                            <div class="progress progress-xs  progress-striped active">
                                <div class="progress-bar progress-bar-primary" role="progressbar" aria-valuenow="60"
                                     aria-valuemin="0" aria-valuemax="100" style="width: 60%;">
                                    60%
                                </div>
                            </div>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-user"></i> 管理员信息</a>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-wrench"></i> 参数配置</a>
                        </li>
                        <li>
                            <a href="#"><i class="fa fa-usd"></i> 事件处理</a>
                        </li>

                        <li>
                            <a href="#modalAnimLogout" class="modal-with-move-anim"><i class="fa fa-power-off"></i> 注销</a>

                            <div id="modalAnimLogout" class="zoom-anim-dialog modal-block modal-block-warning mfp-hide">
                                <div class="panel panel-default">
                                    <div class="panel-heading">
                                        <h4 class="panel-title">用户注销</h4>
                                    </div>
                                    <div class="panel-body bk-noradius">
                                        <div class="modal-wrapper">
                                            <div class="modal-icon">
                                                <i class="fa fa-warning"></i>
                                            </div>
                                            <div class="modal-text">
                                                <p>
                                                    您确定注销用户登录？
                                                </p>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="panel-footer">
                                        <div class="row">
                                            <div class="col-md-12 text-right">
                                                <a href="/index.php?m=Admin&c=business&a=logout" class="btn btn-warning modal-dismiss">确定</a>
                                                <a class="btn btn-warning modal-dismiss">取消</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
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
<div class="container-fluid content">
    <div class="row">
        <div class="sidebar">
            <div ng-include="siderBarUrl"></div>
        </div>
        <div class="main">
            <!-- Start: Content -->
            <div ng-include="cabUrl"></div>
            <div class="container-fluid content">
                <div class="row">
                    <div class="panel panel-default col-lg-9">
                        <div class="panel-heading">
                            <i class="fa fa-building-o"></i>离线存储柜
                            <a href="" class="btn btn-danger pull-right btn-xs bk-margin-5" ng-click="updateDeviceStatus();" title="刷新柜子信息">刷新</a>
                            <a href="#modalAnimDeviceStatusCmd" 
                               class="btn btn-xs pull-right bk-margin-5 modal-with-move-anim" 
                               ng-class="{ true:'btn-warning', false:'btn-primary' }[cab.is_device_status_cmd_going()]"
                               title="查询柜子在位信息">
                                {{cab.get_device_status_btn_text()}}
                            </a> 
                        </div>
                        <div class="panel-body">
                            <div class="tabs tabs-primary bk-margin-bottom-5">
                                <ul class="nav nav-tabs">
                                    <li ng-repeat="_lvl in cab.levels" ng-class="{'true': 'active'}[$first]">
                                        <a data-toggle="tab" href="#pane-cab-level{{$index}}">
                                            <i class="glyphicon glyphicon-align-justify"></i>
                                            <span ng-bind="'第'+{{$index+1}}+'层'"></span>
                                        </a>
                                    </li>
                                </ul>
                                <div class="tab-content">
                                    <div ng-repeat="_lvl in cab.levels" ng-init="idx_lvl=$index"
                                         id="pane-cab-level{{$index}}"
                                         class="tab-pane bk-margin-bottom-off"
                                         ng-class="{'true': 'active'}[$first]">
                                        <div ng-repeat="_grp in _lvl.groups" ng-init="idx_grp = $index" class="row">
                                            <div ng-repeat="_dsk in _grp.disks" class="col-lg-3 col-md-6 col-sm-12"
                                                 ng-init="idx_dsk = $index">
                                                <div class="btn btn-block btn-sm bk-margin-bottom-15"
                                                     ng-class="{
													 'btn-success':_dsk.is_bridged(),
													 'btn-primary':_dsk.is_loaded() && !_dsk.is_bridged(),
													 'btn-default':!_dsk.is_loaded(),
													 'btn-warning' : _dsk.get_cmd_name() != '',
													 'btn-selected':_dsk === cab.curr,
                                                     'btn-not-selected':_dsk !== cab.curr
												 }"
                                                     ng-click="cab.select_disk(idx_lvl, idx_grp, idx_dsk)">
                                                    <div class="bk-vcenter row">
                                                        <i class="fa fa-check-circle" style="position:absolute;right:20px"
                                                           ng-show="_dsk == cab.curr"></i>
                                                        <div class="bk-vcenter col-lg-12" ng-class="{
													   		true:'text-left',
													   		false:'text-center'
														}[_dsk.base_info.loaded]"
                                                             style="min-height:38px">
                                                            <i class="glyphicon bk-margin-left-5"
                                                               ng-class="{
													   		true:'glyphicon-hdd',
													   		false:'glyphicon-ban-circle'
														}[_dsk.base_info.loaded]"></i>
                                                            {{_dsk.get_title()}} {{_dsk.get_curr_cmd_title()}}<br>{{_dsk.get_extent_title()}}
                                                        </div>
                                                    </div>                                                    
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="panel panel-default col-lg-3">
                        <div class="panel-heading">
                            <i class="glyphicon glyphicon-hdd bk-margin-left-5"></i>插槽信息
                        </div>
                        <div class="panel-body">
                            <div class="row">
                                <div class="col-lg-12 panel bk-margin-10">
                                    <h4>当前硬盘：{{cab.curr.get_title()}}</h4>
                                </div>
                            </div>
                            <div class="row panel bk-margin-10 bk-margin-bottom-20">
                                <!--   <div class="row">
                                       <div class="col-lg-6 bk-margin-bottom-5">
                                           <p title="在位情况">
                                               <i class="glyphicon"
                                                  ng-class="{
                                                       true:'glyphicon-hdd',
                                                       false:'glyphicon-ban-circle'
                                                   }[cab.curr.is_loaded()]"></i>
                                               {{cab.curr.is_loaded()?'在位':'无盘'}}
                                           </p>
                                       </div>
                                       <div class="col-lg-6">
                                           <p title="桥接">
                                               <i class="fa "
                                                  ng-class="{
                                                       true:'fa-link',
                                                       false:'fa-unlink'
                                                   }[cab.curr.is_bridged()]"></i>
                                               {{cab.curr.is_bridged()?'已桥接':(cab.curr.is_loaded()?'未桥接':'-')}}
                                           </p>
                                       </div>
                                   </div>-->
                                <div class="row">
                                    <div class="col-lg-12">
                                        <p title="桥接">
                                            <i class="fa "
                                               ng-class="{
                                                       true:'fa-link',
                                                       false:'fa-unlink'
                                                   }[cab.curr.is_bridged()]"></i>
                                            {{cab.curr.is_bridged()?'已桥接':(cab.curr.is_loaded()?'未桥接':'-')}}
                                            <a class="btn btn-primary btn-xs" href="/index.php?m=Admin&c=business&a=filetree&f={{cab.id}}_{{cab.curr.l+1}}_{{cab.curr.g+1}}_{{cab.curr.d+1}}"
                                               ng-if="cab.curr.is_loaded()" target="_blank">离线</a>
                                            <a ng-href="file://///222.35.224.230/public/{{cab.curr.base_info.bridge_path}}" 
                                               ng-if="cab.curr.is_bridged()"
                                               class="btn btn-primary btn-xs">在线</a>
                                            <a href="#modalAnimFileTreeCmd" class="btn btn-danger btn-xs modal-with-move-anim" 
                                               ng-show="cab.curr.is_bridged()">重建索引</a>
                                        </p>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-lg-6">
                                        <p title="硬盘容量">
                                            <i class="fa fa-tachometer"></i>
                                            {{cab.curr.is_loaded()?cab.curr.get_capacity() : '-'}} GB
                                        </p>
                                    </div>
                                    <div class="col-lg-6">
                                        <p title="get_SN">
                                            <i class="fa fa-list-ul"></i>
                                            {{cab.curr.is_loaded()?cab.curr.get_SN() : '-'}}
                                        </p>
                                    </div>
                                </div>
                            </div>
                            <div class="panel bk-margin-10">
                                <div class="row bk-margin-top-10">
                                    <div class="col-lg-12">

                                        <a href="#modalAnim{{cab.curr.get_modal_type('DISKINFO')}}"
                                           title="查询硬盘详细信息"
                                           class="btn btn-xs modal-with-move-anim"
                                           ng-class="{true:'btn-warning', false:'btn-primary'}[cab.curr.get_cmd_name() == 'DISKINFO']"
                                           ng-disabled="!cab.curr.is_loaded()" ng-click="cab.curr.cmd_commit('DISKINFO')">
                                            <i class="fa fa-info-circle"></i>
                                            {{cab.curr.get_btn_title('DISKINFO')}}
                                        </a>

                                        <!-- Bridge -->
                                        <a href="#modalAnim{{cab.curr.get_modal_type('BRIDGE')}}"
                                           class="btn btn-primary btn-xs modal-with-move-anim"
                                           ng-class="{'btn-danger':cab.curr.is_bridged(), 'btn-warning':cab.curr.get_cmd_name() == 'BRIDGE'}"
                                           ng-disabled="!cab.curr.is_loaded()"
                                           ng-click="cab.curr.cmd_commit('BRIDGE')">
                                            <i class="fa"
                                               ng-class="{true:'fa-unlink', false:'fa-link'}[cab.curr.is_bridged()]"></i>
                                            {{cab.curr.get_btn_title('BRIDGE')}}
                                        </a>

                                        <!-- MD5 -->
                                        <a href="#modalAnim{{cab.curr.get_modal_type('MD5')}}"
                                           class="btn btn-xs modal-with-move-anim"
                                           ng-class="{true:'btn-danger', false:'btn-primary'}[cab.curr.is_loaded() && cab.curr.get_cmd_name() == 'MD5']"
                                           ng-disabled="!cab.curr.is_loaded()"
                                           ng-click="cab.curr.cmd_commit('MD5')">
                                            <i class="fa fa-check-circle"></i>
                                            {{cab.curr.get_btn_title('MD5')}}
                                        </a>

                                        <!-- Copy -->
                                        <a href="#modalAnim{{cab.curr.get_modal_type('COPY')}}"
                                           class="btn btn-xs modal-with-move-anim"
                                           ng-class="{true:'btn-danger', false:'btn-primary'}[cab.curr.is_loaded() && cab.curr.get_cmd_name() == 'COPY']"
                                           ng-disabled="!cab.curr.is_loaded()"
                                           ng-click="cab.curr.cmd_commit('COPY')">
                                            <i class="fa fa-copy"></i>
                                            {{cab.curr.get_btn_title('COPY')}}
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <!--/container-->
            <div id="modalAnimDeviceStatusCmd" class="zoom-anim-dialog modal-block  mfp-hide"
                 ng-class="{true:'modal-block-primary',false:'modal-block-warning'}[!cab.is_device_status_cmd_going()]" >
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">存储柜命令[在位查询]</h4>
                    </div>
                    <div class="panel-body bk-noradius">
                        <div class="modal-wrapper">
                            <div class="modal-icon">
                                <i class="fa"
                                   ng-class="{true:'fa-warning',false:'fa-question-circle'}[cab.is_device_status_cmd_going()]"
                                   ></i>
                            </div>
                            <div class="modal-text">
                                <p ng-if="!cab.is_device_status_cmd_going()">
                                    您确定要提交对存储柜 {{cab.id}}#的“在位查询”命令吗？
                                </p>

                                <p ng-if="cab.is_device_status_cmd_going()">
                                    存储柜 {{cab.id}}#正在进行的“在位查询”命令，请稍候。
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer">
                        <div class="row">
                            <div class="col-md-12 text-right" ng-if="!cab.is_device_status_cmd_going()">
                                <button class="btn btn-primary"
                                        ng-click="cab.start_cmd_device_status()">
                                    确认
                                </button>
                                <button class="btn btn-default modal-dismiss">取消</button>
                            </div>
                            <div class="col-md-12 text-right" ng-if="cab.is_device_status_cmd_going()">
                                <button class="btn btn-warning modal-dismiss">确认</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="modalAnimFileTreeCmd" class="zoom-anim-dialog modal-block modal-block-primary mfp-hide">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">硬盘命令[重建离线索引] -- 开始</h4>
                    </div>
                    <div class="panel-body bk-noradius">
                        <div class="modal-wrapper">
                            <div class="modal-icon">
                                <i class="fa fa-question-circle"></i>
                            </div>
                            <div class="modal-text">
                                <p>
                                    您确定要提交对硬盘（<span class="bk-fg-primary">
                                        <i class="glyphicon glyphicon-hdd"></i>
                                        {{cab.curr.get_title()}}
                                    </span>）的“重建离线索引”命令吗？
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer">
                        <div class="row">
                            <div class="col-md-12 text-right">
                                <button class="btn btn-primary"
                                        ng-click="cab.curr.cmd_start('FILETREE')">
                                    确认
                                </button>
                                <button class="btn btn-default modal-dismiss">取消</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="modalAnimBusy" class="zoom-anim-dialog modal-block modal-block-warning mfp-hide">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">硬盘命令[{{cab.curr.get_commit_cmd_title()}}] -- 硬盘忙</h4>
                    </div>
                    <div class="panel-body bk-noradius">
                        <div class="modal-wrapper">
                            <div class="modal-icon">
                                <i class="fa fa-warning"></i>
                            </div>
                            <div class="modal-text">
                                <p>
                                    {{cab.curr.cmd_name_to_commit ==
                                    'COPY'?(cab.curr.busy_disk.g%2==0?'源':'目的'):''}}硬盘组（{{cab.curr.busy_disk.g+1}}#）中硬盘（<span
                                        ng-class="{true:'bk-fg-success', false:'bk-fg-primary'}[cab.curr.busy_disk.is_bridged()]"><i
                                        class="glyphicon glyphicon-hdd"></i>
                                {{cab.curr.busy_disk.get_title()}}</span>）{{cab.curr.to_modal_busy_msg()}}<a href="#">获得帮助?</a>
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer">
                        <div class="row">
                            <div class="col-md-12 text-right">
                                <button class="btn btn-warning modal-dismiss">确定</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="modalAnimStop" class="zoom-anim-dialog modal-block modal-block-primary mfp-hide">
                <div class="panel panel-default">
                    <div class="panel-heading">
                        <h4 class="panel-title">硬盘命令[{{cab.curr.get_commit_cmd_title()}}]停止</h4>
                    </div>
                    <div class="panel-body bk-noradius">
                        <div class="modal-wrapper">
                            <div class="modal-icon">
                                <i class="fa fa-question-circle"></i>
                            </div>
                            <div class="modal-text">
                                <p ng-if="cab.curr.is_bridged()">
                                    您确定断开硬盘（<span
                                        ng-class="{true:'bk-fg-success', false:'bk-fg-primary'}[cab.curr.is_bridged()]"><i
                                        class="glyphicon glyphicon-hdd"></i>
                                {{cab.curr.get_title()}}</span>）桥接状态？
                                </p>

                                <p ng-if="!cab.curr.is_bridged()">
                                    您确定停止硬盘（<span
                                        ng-class="{true:'bk-fg-success', false:'bk-fg-primary'}[cab.curr.is_bridged()]"><i
                                        class="glyphicon glyphicon-hdd"></i>
                                {{cab.curr.get_title()}}</span>）正在执行的[{{cab.curr.get_extent_title()}}]命令？
                                </p>
                            </div>
                        </div>
                    </div>
                    <div class="panel-footer">
                        <div class="row">
                            <div class="col-md-12 text-right">
                                <button class="btn btn-primary" ng-click="cab.curr.cmd_stop()">确认</button>
                                <button class="btn btn-default modal-dismiss">取消</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div id="modalAnimStart" class="zoom-anim-dialog modal-block modal-block-primary mfp-hide">
                <form class="chk-radios-form">
                    <div class="panel panel-default">
                        <div class="panel-heading">
                            <h4 class="panel-title">硬盘命令[{{cab.curr.get_commit_cmd_title()}}]开始</h4>
                        </div>
                        <div class="panel-body bk-noradius">
                            <div class="modal-wrapper" ng-if="cab.curr.cmd_name_to_commit == 'DISKINFO'">
                                <div class="modal-icon">
                                    <i class="fa fa-question-circle"></i>
                                </div>
                                <div class="modal-text">
                                    <p>
                                        您确定要提交对硬盘（<span class="bk-fg-primary">
                                        <i class="glyphicon glyphicon-hdd"></i>
                                        {{cab.curr.get_title()}}
                                    </span>）的“查询”命令吗？
                                    </p>
                                </div>
                            </div>
                            <div class="modal-text form-group" ng-if="cab.curr.cmd_name_to_commit == 'BRIDGE'">
                                <label class="col-md-2 control-label">请选择<span class="required">*</span><br><label
                                        class="error"
                                        for="to_bridged_disks[]"></label>
                                <label class="error">{{cab.curr.get_cmd_error()}}</label>
                                </label>

                                <div class="col-md-10">
                                    <div class="checkbox-custom" ng-repeat="_dsk in cab.curr.get_siblings()">
                                        <input id="selected-disk{{$index}}" type="checkbox" name="to_bridged_disks[]"
                                               ng-model="_dsk.isto_bridge" ng-disabled="!_dsk.is_loaded()"
                                               value="{{_dsk.get_title()}}" ng-model="_dsk.isto_bridge" required>
                                        <label for="selected-disk{{$index}}"
                                               ng-class="{'bk-fg-primary':_dsk.is_loaded() && !_dsk.is_bridged(), 'bk-fg-success': _dsk.is_bridged()}">
                                            <i class="glyphicon bk-margin-left-5"
                                               ng-class="{true:'glyphicon-hdd', false:'glyphicon-ban-circle'}[_dsk.is_loaded()]"></i>
                                            {{_dsk.get_title()}}{{_dsk === cab.curr?'(当前)':''}}
                                        </label>
                                    </div>
                                </div>
                            </div>
                            <div class="modal-wrapper" ng-if="cab.curr.cmd_name_to_commit == 'MD5'">
                                <div class="modal-icon">
                                    <i class="fa fa-question-circle"></i>
                                </div>
                                <div class="modal-text">
                                    <p>
                                        您确定要提交对硬盘（<span class="bk-fg-primary"><i class="glyphicon glyphicon-hdd"></i>
                                    {{cab.curr.get_title()}}</span>）的“MD5”命令吗？
                                    </p>
                                </div>
                            </div>
                            <div class="modal-text form-group" ng-if="cab.curr.cmd_name_to_commit == 'COPY'">
                                <div ng-if="cab.curr.g%2==0">
                                    <div class="row">
                                        <label class="control-label col-md-2">源硬盘</label>

                                        <div class="col-md-10">
                                            <label class="bk-fg-primary bk-margin-off control-label"><i
                                                    class="glyphicon glyphicon-hdd bk-margin-left-5"></i>
                                                {{cab.curr.get_title()}}(当前)</label>
                                        </div>
                                    </div>
                                    <div class="row form-group">
                                        <label class="control-label col-md-2">目的硬盘<span
                                                class="required">*</span><br><label
                                                class="error" for="dstDisks"></label>

                                            <label class="error">{{cab.curr.get_cmd_error()}}</label>
                                        </label>

                                        <div class="col-md-10 bk-margin-bottom-10">
                                            <div class="radio-custom" ng-repeat="_disk in cab.curr.get_copy_disks()">
                                                <input id="radioBoxCopyDst{{$index}}" type="radio"
                                                       ng-model="cab.curr.copy_disk"
                                                       name="dstDisks" ng-disabled="!_disk.is_loaded()"
                                                       value="{{_disk.d}}"
                                                       required>
                                                <label for="radioBoxCopyDst{{$index}}"
                                                       ng-class="{'bk-fg-primary':(_disk.is_loaded() && !_disk.is_bridged()), 'bk-fg-success':(_disk.is_bridged())}">
                                                    <i class="glyphicon bk-margin-left-5"
                                                       ng-class="{true:'glyphicon-hdd',false:'glyphicon-ban-circle'}[_disk.is_loaded()]"></i>
                                                    {{_disk.get_title()}}
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div ng-if="cab.curr.g%2==1">
                                    <div class="row form-group">
                                        <label class="control-label col-md-2">源硬盘<span
                                                class="required">*</span><br><label
                                                class="error" for="srcDisks"></label>

                                            <label class="error">{{cab.curr.get_cmd_error()}}</label>
                                        </label>

                                        <div class="col-md-10">
                                            <div class="radio-custom" ng-repeat="_disk in cab.curr.get_copy_disks()">
                                                <input id="radioBoxCopySrc{{$index}}" type="radio"
                                                       ng-model="cab.curr.copy_disk"
                                                       name="srcDisks" ng-disabled="!_disk.is_loaded()"
                                                       value="{{_disk.d}}"
                                                       required>
                                                <label for="radioBoxCopySrc{{$index}}" ng-class="{'bk-fg-primary':(_disk.is_loaded() && !_disk.is_bridged()),
																			'bk-fg-success':(_disk.is_bridged())}">
                                                    <i class="glyphicon bk-margin-left-5"
                                                       ng-class="{true:'glyphicon-hdd',false:'glyphicon-ban-circle'}[_disk.is_loaded()]"></i>{{_disk.get_title()}}
                                                </label>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="row">
                                        <label class="control-label col-md-2">目的硬盘</label>

                                        <div class="col-md-10">
                                            <label class="bk-fg-primary bk-margin-off control-label"><i
                                                    class="glyphicon glyphicon-hdd bk-margin-left-5"></i>
                                                {{cab.curr.get_title()}}（当前）</label>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="panel-footer">
                            <div class="row">
                                <div class="col-md-12 text-right">
                                    <button class="btn btn-primary"
                                            ng-click="cab.curr.cmd_start(cab.curr.cmd_name_to_commit)">确认
                                    </button>
                                    <button class="btn btn-default modal-dismiss">取消</button>
                                </div>
                            </div>
                        </div>
                    </div>
                </form>
            </div>
            <div class="container-fluid content" ng-show="taskPool.ready==true" ng-controller="InitCtrl">
                <div class="row">
                    <div class="col-lg-12 col-md-12 col-sm-12 col-xs-12">
                        <div class="tabs tabs-primary bk-margin-bottom-5">
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
                                    <div class="panel-heading bk-bg-white">
                                        <h6><i class="fa fa-table red"></i><span class="break"></span>任务列表</h6>

                                        <div class="panel-actions">
                                            <a class="btn-minimize" href="#"><i class="fa fa-caret-up"></i></a>
                                        </div>
                                    </div>
                                    <div class="panel-body">
                                        <div class="table-responsive">
                                            <table class="table table-bordered table-striped dataTable no-footer"
                                                    datatable="ng" dt-options="showCase.dtOptions"
                                                   >
                                                <thead>
                                                    <tr role="row">
                                                        <th class="sorting_asc" tabindex="0" aria-controls="datatable-default" rowspan="1"
                                                            colspan="1" style="width: 172px;" aria-sort="ascending"
                                                            aria-label="Rendering engine: activate to sort column ascending">
                                                            任务
                                                        </th>
                                                        <th class="sorting_asc" tabindex="0" aria-controls="datatable-default" rowspan="1"
                                                            colspan="1" style="width: 172px;" aria-sort="ascending"
                                                            aria-label="Rendering engine: activate to sort column ascending">
                                                            类型
                                                        </th>
                                                        <th class="sorting" tabindex="0" aria-controls="datatable-default" rowspan="1"
                                                            colspan="1" style="width: 222px;"
                                                            aria-label="Browser: activate to sort column ascending">
                                                            开始时间
                                                        </th>
                                                        <th class="sorting" tabindex="0" aria-controls="datatable-default" rowspan="1"
                                                            colspan="1" style="width: 208px;"
                                                            aria-label="Platform(s): activate to sort column ascending">
                                                            进度
                                                        </th>
                                                        <th class="hidden-phone sorting" tabindex="0" aria-controls="datatable-default"
                                                            rowspan="1" colspan="1" style="width: 144px;"
                                                            aria-label="Engine version: activate to sort column ascending">
                                                            盘号
                                                        </th>
                                                        <th class="hidden-phone sorting" tabindex="0" aria-controls="datatable-default"
                                                            rowspan="1" colspan="1" style="width: 107px;"
                                                            aria-label="CSS grade: activate to sort column ascending">
                                                            状态
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr class="gradeA odd" role="row" ng-repeat="task in taskPool.going" ng-class-odd="odd"
                                                        ng-class-even="even">
                                                        <td class="sorting_1" ng-bind="lang.getLang(task.cmd)"></td>
                                                        <td ng-bind="lang.getLang(task.subcmd)"><span ng-show="task.isBridge();">开始</span></td>
                                                        <td ng-bind="task.start_time|date:'yyyy-MM-dd hh:mm:ss'"></td>
                                                        <td>
                                                            <div class="panel bk-widget bk-border-off bk-margin-off" >
                                                                <div class="progress progress-striped light progress-xl active" style="margin-top:10;">
                                                                    <div ng-style="{width: task.getProgress()+'%'}" aria-valuemax="100"
                                                                         aria-valuemin="0" aria-valuenow="{{task.getProgress()}}" role="progressbar"
                                                                         class="progress-bar progress-bar-warning">
                                                                        <span ng-bind="task.getProgress()+'%'" style="color:cadetblue;" ></span>
                                                                    </div>
                                                                </div>
                                                                <p class="help-block" ng-show="task.getLeftTime() > -1" style="color:cadetblue;font-weight: bold;">已经用时: <span ng-bind="lang.getTime(task.usedTime)"></span><br><span ng-bind="' 当前操作:'+task.getStage()" ng-show="task.getStage() != null"></span></p>
                                                            </div>
                                                        </td>
                                                        <td class="center hidden-phone">
                                                            <p ng-bind="'柜子号：#'+task.cab_id" ng-show="task.cab_id"></p>
                                                            <p ng-repeat="disk in task.disks" ng-show="task.disks != null">
                                                                <span><i class="fa fa-hdd-o"></i> {{task.level+'-'+task.group+'-'+disk.id}}</span>
                                                            </p>
                                                            <p ng-show="task.disk != null">
                                                                <span><i class="fa fa-hdd-o"></i>{{task.level+'-'+task.group+'-'+task.disk}}</span>
                                                            </p>
                                                            <p ng-show="task.cmd == 'COPY'">
                                                                <span>拷贝源盘：<i class="fa fa-hdd-o"></i>{{task.srcLevel+'-'+task.srcGroup+'-'+task.srcDisk}}</span>
                                                                <br />
                                                                <span>目标盘：<i class="fa fa-hdd-o"></i>{{task.dstLevel+'-'+task.dstGroup+'-'+task.dstDisk}}</span>
                                                            </p>
                                                            <p ng-show="task.cmd == 'DEVICESTATUS'">
                                                                <span>所有盘</span>
                                                            </p>
                                                        </td>
                                                        <td class="center hidden-phone">
                                                            <span ng-bind="task.getStatus()" ng-show="task.getStatus()"></span>
                                                        </td>
                                                    </tr>

                                                </tbody>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="tab-pane panel panel-default bk-bg-white" id="doneTasks">
                                    <div class="panel-heading bk-bg-white">
                                        <h6><i class="fa fa-table red"></i><span class="break"></span>任务列表</h6>
                                        <div class="panel-actions">
                                            <a class="btn-minimize" href="#"><i class="fa fa-caret-up"></i></a>
                                        </div>
                                    </div>
                                    <div class="panel-body">

                                        <div class="table-responsive">
                                            <table  class="table table-bordered table-striped dataTable no-footer"
                                                    datatable="ng" dt-options="showCase.dtOptions" >
                                                <thead>
                                                    <tr role="row">
                                                        <th class="sorting_asc" tabindex="0" aria-controls="datatable-default" rowspan="1"
                                                            colspan="1" style="width: 172px;" aria-sort="ascending"
                                                            aria-label="Rendering engine: activate to sort column ascending">
                                                            任务
                                                        </th>
                                                        <th class="sorting_asc" tabindex="0" aria-controls="datatable-default" rowspan="1"
                                                            colspan="1" style="width: 172px;" aria-sort="ascending"
                                                            aria-label="Rendering engine: activate to sort column ascending">
                                                            类型
                                                        </th>
                                                        <th class="sorting" tabindex="0" aria-controls="datatable-default" rowspan="1"
                                                            colspan="1" style="width: 430px;"
                                                            aria-label="Browser: activate to sort column ascending">
                                                            开始时间
                                                        </th>

                                                        <th class="hidden-phone sorting" tabindex="0" aria-controls="datatable-default"
                                                            rowspan="1" colspan="1" style="width: 144px;"
                                                            aria-label="Engine version: activate to sort column ascending">
                                                            盘号
                                                        </th>
                                                        <th class="hidden-phone sorting" tabindex="0" aria-controls="datatable-default"
                                                            rowspan="1" colspan="1" style="width: 107px;"
                                                            aria-label="CSS grade: activate to sort column ascending">
                                                            状态
                                                        </th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <tr class="gradeA odd" role="row" ng-repeat="task in taskPool.done" ng-class-odd="odd"
                                                        ng-class-even="even">
                                                        <td class="sorting_1" ng-bind="lang.getLang(task.cmd)"></td>
                                                        <td ng-bind="lang.getLang(task.subcmd)"><span ng-show="task.isBridge();">开始</span></td>
                                                        <td ng-bind="task.start_time|date:'yyyy-MM-dd hh:mm:ss'"></td>
                                                        <td class="center hidden-phone">
                                                            <p ng-repeat="disk in task.disks" ng-show="task.disks != null">
                                                                <span><i class="fa fa-hdd-o"></i> {{task.level+'-'+task.group+'-'+disk.id}}</span>
                                                            </p>
                                                            <p ng-show="task.disk != null">
                                                                <span><i class="fa fa-hdd-o"></i>{{task.level+'-'+task.group+'-'+task.disk}}</span>
                                                            </p>
                                                            <p ng-show="task.cmd == 'COPY'">
                                                                <span>拷贝源盘：<i class="fa fa-hdd-o"></i>{{task.srcLevel+'-'+task.srcGroup+'-'+task.srcDisk}}</span>
                                                                <br />
                                                                <span>目标盘：<i class="fa fa-hdd-o"></i>{{task.dstLevel+'-'+task.dstGroup+'-'+task.dstDisk}}</span>
                                                            </p>
                                                            <p ng-show="task.cmd == 'DEVICESTATUS'">
                                                                <span>所有盘</span>
                                                            </p>
                                                        </td>
                                                        <td class="center hidden-phone" ng-bind="lang.getLang(task.status)"></td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </div>
                                    </div>

                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </div>
</div>
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
    <script src="/Public/js/angular-1.4.min.js"></script>
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