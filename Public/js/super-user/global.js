var user_app = angular.module('user_module', ['datatables']);

register_filters(user_app);

var global_http;

user_app.filter('to_trusted', function ($sce) {
    return function (text) {
        return $sce.trustAsHtml(text);
    }
}).filter('formatnumber', function () {
    return function (input) {
        return input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    };
});
user_app.controller('user_controller', function ($scope, $http, $timeout, DTOptionsBuilder, DTDefaultOptions) {
    global_http = $http;
    $scope.url_side_bar = '/bc/Admin/View/Business/super-user-side-bar.html';

    $scope.report_obj = {
        'cabinets': []
    };

    $scope.make_report = function () {
        $scope.is_ok = false;

        $scope.today = new Date();

        $http({
            url: '/index.php?m=admin&c=business&a=generate_report_data',
            method: 'get'
        }).success(function (data) {
            if (!data) {
                $scope.report_data = 'empty data';
            }
            else {
                $scope.report_data = JSON.stringify(data);
                $scope.report_obj['cabinets'] = data;

                $scope.is_ok = true;
            }
        }).error(function (data) {
            $scope.err_data = data;
        });
    }    
	
	//校验密码,校验成功返回0，若长度小于8字，返回-1；若包含非数字或字母，返回-2；或只包含数字或字母，返回-3,；
	$scope.checkPassword = function(password){
		function isNumber(charCode){
			//48为字符'0'的unicode码,57为字符'9'的unicode码
			return charCode >= 48 && charCode <= 57
		}
		function isLetter(charCode){
			//65为字符'A'的unicode码,90为字符'Z'的unicode码
			//90为字符'a'的unicode码,122为字符'z'的unicode码
			return (charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122);
		}
		var numberCount,//数字字符数目
			letterCount,//字母字符数目
			length = (password = password || '').length;
			
		if(length < 8){
			return -1;
		}
		
		numberCount = letterCount = 0;
		for(var i = 0, charCode; i < length; i++){
			charCode= password.charCodeAt(i);//取得每个字符
			if(isNumber(charCode)){
				numberCount += 1;//数字字符数目加1 
			}else if(isLetter(charCode)){
				letterCount += 1;//字母字符数目加1 
			}else{
				return -2;//即不是字母又不数字,直接返回-2
			}       
		}

		if (numberCount == 0 || letterCount == 0) {
			return -3;
		}

		if (numberCount + letterCount == length) {
			return 0;
		}
	   
	   return -4;
	}

    var vm = this;
    vm.dtOptions = DTOptionsBuilder.newOptions().withPaginationType('full_numbers');
    DTDefaultOptions.setLanguage({
        "sProcessing": "处理中...",
        "sLengthMenu": "每页显示 _MENU_ 条",
        "sZeroRecords": "没有匹配的命令",
        "sInfo": "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
        "sInfoEmpty": "显示第 0 至 0 项结果，共 0 项",
        "sInfoFiltered": "(由 _MAX_ 项结果过滤)",
        "sInfoPostFix": "",
        "sUrl": "",
        "sEmptyTable": "没有账户",
        "sLoadingRecords": "载入中...",
        "sInfoThousands": ",",
        "oPaginate": {
            "sFirst": "首页",
            "sPrevious": "上页",
            "sNext": "下页",
            "sLast": "末页"
        },
        "oAria": {
            "sSortAscending": ": 以升序排列此列",
            "sSortDescending": ": 以降序排列此列"
        },
        "sSearch":'查找:'
    });
    
    $scope.curr_modal = new ModalHelper();

    $scope.showLogoutModal = function () {
        $scope.curr_modal.show_modal({
            type: 'question',
            title: '管理员注销',
            html: '您确定要注销<span class="bk-fg-primary">['+$scope.username+']</span>，注销后需要重新登录。',
            on_click_handle: function () {
                window.location = "/index.php?m=admin&c=business&a=logout_admin";
            }
        });
    }

    $scope.show_password_change_modal = function () {
        $scope.user_profile.err_msg = '';
        $scope.user_profile.curr_pwd = '';
        $scope.user_profile.new_pwd = '';
        $scope.user_profile.new_pwd_confirm = '';

        $scope.curr_modal.show_modal_user('superModalChangePassword');        
    }

    $scope.user_profile = {
        username: $scope.username,
        curr_pwd: '',
        new_pwd: '',
        new_pwd_confirm: '',
        err_msg: '',
        changePassword: function ()
        {
            this.curr_pwd = this.curr_pwd.trim();
            if (this.curr_pwd == '') {
                $('#text-input-pwd-curr').focus();
                this.err_msg = '当前密码不能为空';
                return;
            }
            this.new_pwd = this.new_pwd.trim()
            if (this.new_pwd == '') {
                $('#text-input-pwd').focus();
                this.err_msg = '新密码不能为空';
                return;
            }
            this.new_pwd_confirm = this.new_pwd_confirm.trim();
            if (this.new_pwd_confirm == '') {
                $('#text-input-pwd-confirm').focus();
                this.err_msg = '新密码确认不能为空';
                return;
            }

            if (this.new_pwd != this.new_pwd_confirm) {
                $('#text-input-pwd-confirm').focus();
                this.err_msg = '新密码确认不一致';
                return;
            }
			
			switch($scope.checkPassword(this.new_pwd)){
			case -1:
				this.err_msg = '新密码长度至少8个字符';
				return;
			case -2:
				this.err_msg = '新密码必须只包含数字和字母';
				return;
			case -3:
				this.err_msg = '新密码必须包含数字和字母';
				return;
			default:
				break;
			}

            $http({
                url: '/index.php?m=admin&c=business&a=super_change_pwd',
                method: 'post',
                data: {
                    username: this.username,
                    oldpwd: hex_md5(this.curr_pwd),
                    newpwd: hex_md5(this.new_pwd)
                }
            }).success(function (data)
            {
                if(!data) return;

                if (data.status == 1) {
                    new PNotify({
                        title: '密码修改',
                        text: '成功修改!',
                        type: 'success',
                        shadow: true,
                        icon: 'fa fa-check-o'
                    });

                    $.magnificPopup.close();
                }
                else {
                    $scope.user_profile.err_msg = '修改密码失败，当前密码不正确！';
                }
                
            }).error(function (data)
            {
                $scope.user_profile.err_msg = '修改密码失败';
            });

        }
    };


    // 用于主页切换，在主控、用户日志等之间，默认为main
    $scope.change_page_index = function (name) {
        switch (name) {
            case 'user_log':
            case 'manul':
            case 'settings':
            case 'report':
                $scope.page_index = name
                break;
            default:
                $scope.page_index = 'main';
        }
    }
    $scope.change_page_index($scope.username == 'useradmin' ? 'main' : 'user_log');


    /*
        配置信息
    */
    $scope.user_settings = new UserSettings();
    $http({
        url: '/index.php?m=admin&c=business&a=getUserSettings',
        method: 'GET'
    }).success(function (data) {
        console.log(data);
        if (!data) {
            global_modal_helper.show_modal({
                type: 'error',
                title: 'Fatal Error',
                html: 'empty data'
            });
            return;
        }

    }).error(function (data) {
        console.log("获取用户配置信息失败.");
        return;
        global_modal_helper.show_modal({
            type: 'error',
            title: 'Fatal Error',
            html: data
        });
    });

	
	$scope.user_unlock = function(idx){		
        $scope.curr_user_idx = idx;
        $('#modalUserUnlock').modal('toggle');
	}
	$scope.user_unlock_commit = function(){	
		var usr = $scope.users_model[$scope.curr_user_idx];
        $http({
            url:'/index.php?m=admin&c=business&a=user_unlock',
            method:'POST',
            data:{
                id: usr.id
            }
        }).success(function(data){
            $('#modalUserUnlock').modal('hide');
            //响应成功
            var rlt = data;
			if (rlt.status == 'success'){
				$scope.reload_users();
				new PNotify({
					title: '解锁用户',
					text: '成功解锁用户',
					type: 'success',
					shadow: true,
					icon: 'fa fa-check-o'
				});
			}
			else{
				$('#modalUserEditFail').modal('toggle');
			}
        }).error(function(data){
            console.log(data);
        });
	}
    $scope.user_add = function(){
        $scope.new_user = {username:'', password:'', err_msg: ''};

        $('#modalUserAdd').modal('show');
    }
    $scope.user_add_commit = function(){
		$scope.err_msg = '';
		
        var username = $scope.new_user.username.trim();
        var password = $scope.new_user.password.trim();
        if (username == '' || password == ''){
            return;
        }
		
		if (username == 'useradmin' || username == 'logadmin') {
			return;
		}
		
		switch($scope.checkPassword(password)){
		case -1:
			$scope.new_user.err_msg = '密码长度至少8个字符';
			return;
		case -2:
			$scope.new_user.err_msg = '密码必须只包含数字和字母';
			return;
		case -3:
			$scope.new_user.err_msg = '密码必须包含数字和字母';
			return;
		default:
			break;
		}

        $http({
            url:'/index.php?m=admin&c=business&a=user_add',
            method:'POST',
            data:{
                username: username,
                password: hex_md5(password)
            }
        }).success(function(data){
            console.log(data);
            $('#modalUserAdd').modal('hide');
            //响应成功
            try{
                var rlt = JSON.parse(data);
                if (rlt.status == 'success'){
                    $scope.reload_users();

                    new PNotify({
                        title: '新增用户',
                        text: '成功新增用户‘'+rlt.username+'’!',
                        type: 'success',
                        shadow: true,
                        icon: 'fa fa-check-o'
                    });
                }
                else{
                    new PNotify({
                        title: '新增用户',
                        text: '新增用户‘'+rlt.username+'’失败，曾经已使用过的用户名!',
                        type: 'error',
                        shadow: true,
                        icon: 'glyphicon glyphicon-remove-circle'
                    });
                }
            }catch(err) {
                console.log(222);
            }
            finally {
            }
        }).error(function(data){
            console.log(data);
            //处理响应失败
            $scope.users_model = undefined;
        });
    }
    $scope.user_edit = function(idx){
        $scope.curr_user_idx = idx;
        // 写权限复位
        $scope.can_write = $scope.users_model[idx].write;

        $('#modalUserEdit').modal('toggle');
    }
    $scope.user_edit_commit = function(){
        if ($scope.curr_user_idx == undefined) return;

        var usr = $scope.users_model[$scope.curr_user_idx];
        $http({
            url:'/index.php?m=admin&c=business&a=user_set_write',
            method:'POST',
            data:{
                id: usr.id,
                write: $scope.can_write
            }
        }).success(function(data){
            console.log(data);
            $('#modalUserEdit').modal('hide');
            //响应成功
            try{
                var rlt = JSON.parse(data);
                if (rlt.status == 'success'){
                    $scope.users_model[$scope.curr_user_idx].write = rlt.write;
                    new PNotify({
                        title: '修改权限',
                        text: '成功修改权限',
                        type: 'success',
                        shadow: true,
                        icon: 'fa fa-check-o'
                    });
                }
                else{
                    $('#modalUserEditFail').modal('toggle');
                }
            }catch(err) {
                console.log(222);
            }
            finally {
                console.log(333);
            }
        }).error(function(data){
            console.log(data);
            //处理响应失败
            $scope.users_model = undefined;
        });
    }
    $scope.user_remove = function(idx){
        $scope.curr_user_idx = idx;
        $('#modalUserRemove').modal('toggle');
    }
    $scope.user_remove_commit = function(){
        var usr = $scope.users_model[$scope.curr_user_idx];
        $http({
            url:'/index.php?m=admin&c=business&a=user_remove',
            method:'POST',
            data:{
                id: usr.id
            }
        }).success(function(data){
            console.log(data);
            $('#modalUserRemove').modal('hide');
            //响应成功
            try{
                var rlt = JSON.parse(data);
                if (rlt.status == 'success'){
                    $scope.reload_users();
                    new PNotify({
                        title: '删除用户',
                        text: '成功删除用户',
                        type: 'success',
                        shadow: true,
                        icon: 'fa fa-check-o'
                    });
                }
                else{
                    $('#modalUserEditFail').modal('toggle');
                }
            }catch(err) {
                console.log(222);
            }
            finally {
            }
        }).error(function(data){
            console.log(data);
        });
    }

    $scope.user_revive = function (idx)
    {
        var usr = $scope.users_model_removed[idx];
        $scope.curr_modal.show_modal({
            type: 'question',
            title: '用户恢复',
            html: '您确定恢复用户[<span class="bk-fg-primary">' + usr.username + '</span>]的正常使用？',
            on_click_target: this,
            on_click_handle: 'user_revive_commit',
            on_click_param: {
                id: usr.id,
                uname: usr.username
            }
        });
    }
    $scope.user_revive_commit = function (user)
    {
        $http({
            url: '/index.php?m=admin&c=business&a=user_revive',
            method: 'POST',
            data: {
                id: user.id,
                uname: user.uname
            }
        }).success(function (data) {
            if (!data) return;
            if (data.status == 'success') {
                new PNotify({
                    title: '用户恢复',
                    text: '成功恢复用户['+data.uname+']的使用',
                    type: 'success',
                    shadow: true,
                    icon: 'fa fa-check-o'
                });

                $scope.reload_users();
            }
            else {
                new PNotify({
                    title: '用户恢复',
                    text: '恢复用户[' + data.uname + ']的失败',
                    type: 'error',
                    shadow: true,
                    icon: 'glyphicon glyphicon-remove-circle'
                });
            }            
        }).error(function (data) {
            console.log(data);
        });
    }

    $scope.user_passwd_reset = function(idx){
        $scope.new_password = '';
        $scope.curr_user_idx = idx;
		$scope.err_msg = '';

        $('#modalUserPasswd').modal('show');
    }
    $scope.user_password_reset_commit = function(){
        var password = $scope.new_password.trim();
        if (password == ''){
			$scope.err_msg = '新密码不能为空';
            return;
        }
		
		switch($scope.checkPassword(password)){
		case -1:
			$scope.err_msg = '新密码长度至少8个字符';
			return;
		case -2:
			$scope.err_msg = '新密码必须只包含数字和字母';
			return;
		case -3:
			$scope.err_msg = '新密码必须包含数字和字母';
			return;
		default:
			break;
		}


        var usr = $scope.users_model[$scope.curr_user_idx];
        $http({
            url:'/index.php?m=admin&c=business&a=user_passwd_reset',
            method:'POST',
            data:{
                id: $scope.users_model[$scope.curr_user_idx].id,
                password: hex_md5($scope.new_password)
            }
        }).success(function(data){
            console.log(data);
            $('#modalUserPasswd').modal('hide');
            //响应成功
            try{
                var rlt = JSON.parse(data);
                if (rlt.status == 'success'){
                    new PNotify({
                        title: '重置密码',
                        text: '成功重置用户密码',
                        type: 'success',
                        shadow: true,
                        icon: 'fa fa-check-o'
                    });
                }
                else{
                    $('#modalUserEditFail').modal('toggle');
                }
            }catch(err) {
                console.log(222);
            }
            finally {
            }
        }).error(function(data){
            console.log(data);
        });
    }

    $scope.reload_users = function(){
        $http({
            url:'/index.php?m=admin&c=business&a=get_users',
            method:'GET'
        }).success(function(data,header,config,status){
            //响应成功
            $scope.users_model = data;
        }).error(function(data,header,config,status){
            //处理响应失败
            $scope.users_model = undefined;
        });

        $http({
            url: '/index.php?m=admin&c=business&a=get_users_removed',
            method: 'GET'
        }).success(function (data, header, config, status) {
            //响应成功
            $scope.users_model_removed = data;
        }).error(function (data, header, config, status) {
            //处理响应失败
            $scope.users_model_removed = undefined;
        });
    }

    /*------------------用户日志--------------------*/
    $scope.url_user_log_view = '/bc/Admin/View/Business/userLogView.html';
    $scope.user_log_loading = false;
    $scope.reload_user_log = function () {
        if ($scope.user_log_loading) return;

        $scope.user_log_loading = true;
        $http({
            url: '/index.php',
            method: 'get',
            params: {
                m: 'admin',
                c: 'business',
                a: 'getLogByUserId'
            }
        }).success(function (data) {
            if (!data) {
                $scope.user_log_loading = false;
                return;
            }

            try {
                $scope.user_logs = data;
            }
            catch (e) {

            }
            finally {
                $timeout(function () {
                    $scope.user_log_loading = false;
                }, 100);
            }
        }).error(function () {
            $scope.user_log_loading = false;
        });
    }

    if ($scope.username == 'logadmin') {
        $scope.reload_user_log();
    }
    if ($scope.username == 'useradmin') {
        $scope.reload_users();
    }

    ($scope.init_date_picker = function () {
        $.fn.datepicker.defaults.format = 'yyyy-mm-dd';
        $("[data-plugin-datepicker]").datepicker();
        console.log($("[data-plugin-datepicker]").length);
    })();
});