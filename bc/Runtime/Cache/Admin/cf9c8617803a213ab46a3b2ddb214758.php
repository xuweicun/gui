<?php if (!defined('THINK_PATH')) exit();?><!DOCTYPE html>
<html lang="en">

	<head>
	
		<!-- Basic -->
    	<meta charset="UTF-8" />

		<title>Login | Fire - Admin Template</title>
	
		<!-- Mobile Metas -->
	    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" />

	    <!-- start: CSS file-->
		
		<!-- Vendor CSS-->
		<link href="/Public/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
		<link href="/Public/assets/vendor/skycons/css/skycons.css" rel="stylesheet" />
		<link href="/Public/assets/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
		
		<!-- Plugins CSS-->
		<link href="/Public/assets/plugins/bootkit/css/bootkit.css" rel="stylesheet" />
		
		<!-- Theme CSS -->
		<link href="/Public/assets/css/jquery.mmenu.css" rel="stylesheet" />
		
		<!-- Page CSS -->		
		<link href="/Public/assets/css/style.css" rel="stylesheet" />
		<link href="/Public/assets/css/add-ons.min.css" rel="stylesheet" />
		
		<style>
			footer {
				display: none;
			}
		</style>
		
		<!-- end: CSS file-->	
	    
		
		<!-- Head Libs -->
		<script src="assets/plugins/modernizr/js/modernizr.js"></script>

		
	</head>

	<body>
		<!-- Start: Content -->
		<div class="container-fluid content">
			<div class="row">
				<!-- Main Page -->
				<div id="content" class="col-sm-12 full">
					<div class="row">
						<div class="login-box">
							<div class="panel">
								<div class="panel-body">								
									<div class="header bk-margin-bottom-20 text-center">										
										<img src="/Public/assets/img/logo.png" class="img-responsive" alt="" />
										<h4>系统登录</h4>
									</div>
									<div class="bk-padding-left-20 bk-padding-right-20">
										<form action="/index.php?m=admin&c=business&a=login" method="post">
											<div class="form-group">
												<label>用户名</label>
												<div class="input-group input-group-icon">
													<input type="text" class="form-control bk-radius" name="uname" id="username" placeholder="请输入用户名"/>
													<span class="input-group-addon">
														<span class="icon">
															<i class="fa fa-user"></i>
														</span>
													</span>
												</div>
											</div>
											<div class="form-group">
												<label>密码</label>
												<div class="input-group input-group-icon">
													<input type="password" class="form-control bk-radius"  name="pwd" id="password" placeholder="请输入密码"/>
													<span class="input-group-addon">
														<span class="icon">
															<i class="fa fa-key"></i>
														</span>
													</span>
												</div>
											</div>
											<div class="row bk-margin-top-20 bk-margin-bottom-10">
												<div class="col-sm-8">
													<div class="checkbox-custom checkbox-default">
														<input id="RememberMe" name="rememberme" type="checkbox" />
														<label for="RememberMe">记住我</label>
													</div>
												</div>
												<div class="col-sm-4 text-right">
													<button type="submit" class="btn btn-primary hidden-xs">登录</button>
													<button type="submit" class="btn btn-primary btn-block btn-lg visible-xs bk-margin-top-20">Log In</button>
												</div>
											</div>
										</form>
									</div>
								</div>
							</div>
						</div>
					</div>			
				</div>
				<!-- End Main Page -->
			</div>
		</div><!--/container-->
		
		
		<!-- start: JavaScript-->
		
		<!-- Vendor JS-->				
		<script src="/Public/assets/vendor/js/jquery.min.js"></script>
		<script src="/Public/assets/vendor/js/jquery-2.1.1.min.js"></script>
		<script src="/Public/assets/vendor/js/jquery-migrate-1.2.1.min.js"></script>
		<script src="/Public/assets/vendor/bootstrap/js/bootstrap.min.js"></script>
		<script src="/Public/assets/vendor/skycons/js/skycons.js"></script>
		
		<!-- Plugins JS-->
		<script src="/Public/assets/plugins/bootkit/js/bootkit.js"></script>
		
		<!-- Theme JS -->		
		<script src="/Public/assets/js/jquery.mmenu.min.js"></script>
		<script src="/Public/assets/js/core.min.js"></script>
		
		<!-- Pages JS -->
		<script src="assets/js/pages/page-login.js"></script>
		
		<!-- end: JavaScript-->
		
	</body>
	
</html>