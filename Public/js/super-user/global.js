var user_app = angular.module('user_module', ['datatables', 'xeditable']);

user_app.run(function (editableOptions) {
    editableOptions.theme = 'bs3'; // bootstrap3 theme. Can be also 'bs2', 'default'
});

register_filters(user_app);

//Initializing
global_modal_helper = new ModalHelper();
global_user = new User(
    parseInt($('#userid').text()),
    $('#username').text(),
    parseInt($('#can_write').text()),
    $('#token').text()
);

user_app.filter('to_trusted', function ($sce) {
    return function (text) {
        return $sce.trustAsHtml(text);
    }
}).filter('formatnumber', function () {
    return function (input) {
        return input.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
    };
});
user_app.controller('user_controller', function ($scope, $http, $timeout, WebSock, DTOptionsBuilder, DTDefaultOptions) {

    $scope.smb_access = [
        { value: 0, text: '无权限' },
        { value: 1, text: '只读' },
        { value: 2, text: '读写' }
    ];
    
    global_http = $http;

    $scope.ws_creater = WebSock;
    $scope.ws_conn = global_web_socket = $scope.ws_creater.connect();
    $scope.checkerStatus = new CheckStatus();
    $scope.url_side_bar = '/bc/Admin/View/Business/super-user-side-bar.html';
    $scope.is_making = false;

    $scope.report_obj = {
        'cabinets': []
    };

    $scope.init_smb = function ()
    {
        if ($scope.is_init_smb) {
            return;
        }

        function SmbDisk(user_id, cab_id, cab_sn, cab_name, lvl, grp, dsk) {
            this.user_id = user_id;
            this.cab_id = cab_id;
            this.cab_sn = cab_sn;
            this.cab_name = cab_name;
            this.lvl = lvl;
            this.grp = grp;
            this.dsk = dsk;
            this.smb = 0;
        }

        SmbDisk.prototype = {
            smb_title: function () {
                switch (this.smb) {
                    case 1: return '只读';
                        break;
                    case 2: return '读写';
                        break;
                    default:
                        return '无权限';
                }
            },
            save: function (data) {
                this.user_id = $scope.users_model[$scope.curr_user_idx].id;
                $http({
                    url: '/?a=setSamba',
                    method: 'post',
                    data: this
                });
            },
            clear_smb: function ()
            {
                this.smb = 0;
            }
        };

        $scope.is_init_smb = true;

        $http({
            url: '/?a=getCabInfo',
            method: 'get'
        })
        .success(function (data) {
            if (data == null) return;

            if (Object.prototype.toString.call(data) === "[object Array]") {
                for (var i = 0; i < data.length; ++i) {
                    var _curr_cab = data[i];
                    _curr_cab.status = null;
                    _curr_cab.lvls = [];
                    for (var jl = 0; jl < _curr_cab.level_cnt; ++jl) {
                        var lvl_obj = {
                            id: jl + 1,
                            grps: []
                        };

                        for (var jg = 0; jg < _curr_cab.group_cnt; ++jg) {
                            var grp_obj = {
                                id: jg + 1,
                                dsks: []
                            };

                            for (var jd = 0; jd < _curr_cab.disk_cnt; ++jd) {
                                var dsk_obj = new SmbDisk($scope.select_user_id, _curr_cab.id, _curr_cab.sn, _curr_cab.name, jl + 1, jg + 1, jd + 1);
                                grp_obj.dsks.push(dsk_obj);
                            }

                            lvl_obj.grps.push(grp_obj);
                        }

                        _curr_cab.lvls.push(lvl_obj);
                    }  
                }

                $scope.cabinet_list = data;
                $scope.smb_ip = '';

                // for test
                //$scope.load_user_smb(0);
            }
            else {
                new PNotify({
                    title: '初始化SMB配置',
                    text: '没有找到存储柜',
                    type: 'error',
                    shadow: true,
                    icon: 'fa fa-alarm'
                });
            }
            $scope.is_init_smb = false;
        })
        .error(function (data) {
            new PNotify({
                title: '初始化SMB配置',
                text: '失败',
                type: 'error',
                shadow: true,
                icon: 'fa fa-alarm'
            });
            $scope.is_init_smb = false;
        });
    }

    $scope.save_smb_ip = function (data)
    {
        $http({
            url: '/?a=setSambaIP',
            method: 'post',
            data: {
                smb_ip: $scope.smb_ip,
            }
        });
    };

    $scope.validate_smb_ip = function (data) {
        if (data.length > 250) {
            return '最长250个字符（包括空格）';
        }

        while (data.indexOf('  ') != -1) {
            data = data.replace('  ', ' ');
        }
        
        var ips = data.split(' ');

        for (var i = 0; i < ips.length; ++i) {
            var units = ips[i].split('.');
            if (units.length > 4) {
                return '[' + ips[i] + ']不是有效的IP地址';
            }

            if (units[0] === '') {
                return '[' + ips[i] + ']不是有效的IP地址，不能以‘.’开头';
            }

            if (units.length < 4 && units[units.length - 1] != '') {
                return '[' + ips[i] + ']不是有效的IP地址，须以‘.’结尾';
            }

            for (var j = 0; j < units.length; ++j) {
                if (isNaN(units[j])) {
                    return '[' + ips[i] + ']不是有效的IP地址';
                }

                var int_val = parseInt(units[j]);
                if (int_val < 0 || int_val >= 255) {
                    return '[' + ips[i] + ']不是有效的IP地址';
                }
            }
        }
    };

    $scope.load_user_smb = function (user_id)
    {
        // clear smb info
        if (!$scope.cabinet_list || $scope.cabinet_list.length <= 0) return;
       
        $scope.is_loading_user_smb_access = true;
 
        for (var i = 0; i < $scope.cabinet_list.length; ++i) {
            var _curr_cab = $scope.cabinet_list[i];
            for (var jl = 0; jl < _curr_cab.level_cnt; ++jl) {
                var lvl_obj = _curr_cab.lvls[jl];

                for (var jg = 0; jg < _curr_cab.group_cnt; ++jg) {
                    var grp_obj = lvl_obj.grps[jg];

                    for (var jd = 0; jd < _curr_cab.disk_cnt; ++jd) {
                        var dsk_obj = grp_obj.dsks[jd];
                        dsk_obj.clear_smb();
                    }
                }
            }

            $http({
                url: '/?a=getSamba',
                method: 'post',
                data: {
                    cab_id: _curr_cab.id,
                    user_id: user_id
                }
            }).success(function (smb_data) {
                $scope.is_loading_user_smb_access = false;
                if (smb_data == null) return;

                if (Object.prototype.toString.call(smb_data) === "[object Array]") {
                    var _cab_list = $scope.cabinet_list;
                    for (var x = 0; x < smb_data.length; ++x) {
                        var _smb = smb_data[x];
                        for (var xi = 0; xi < _cab_list.length; ++xi) {
                            if (_smb.cab_id == _cab_list[xi].id) {
                                var _dsk = _cab_list[xi].lvls[_smb.lvl - 1].grps[_smb.grp - 1].dsks[_smb.dsk - 1];
                                try {
                                    _dsk.smb = parseInt(_smb.value);
                                }
                                catch (e) {
                                }
                            }
                        }
                    }
                }
                else {
                    new PNotify({
                        title: '初始化SMB配置',
                        text: '没有找到存储柜',
                        type: 'error',
                        shadow: true,
                        icon: 'fa fa-alarm'
                    });
                }
            }).error(function(){
                $scope.is_loading_user_smb_access = false;
            });
        }
    }
    
    $scope.user_samba = function (idx) {
        $scope.curr_user_idx = idx;
        var usr = $scope.users_model[idx];
        $scope.select_user_id = usr.id;

        $scope.load_user_smb(usr.id);

        $scope.curr_modal.show_modal_user('modalUserSamba');
    }
    
    $scope.set_samba_ips = function () 
    {
        $http({
            url: '/?a=getSambaIP',
            method: 'get',
        }).success(function (_data) {
            $scope.smb_ip = _data;
        })
        .error(function (_data) {
            $scope.smb_ip = '';
        });

        $scope.curr_modal.show_modal_user('modalUserSambaIps');
    }


    $scope.make_report = function () {
        $scope.is_ok = false;
        $scope.is_making = true;

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
                $scope.is_making = false;
            }
        }).error(function (data) {
            $scope.err_data = data;
            $scope.is_making = false;
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
    $scope.stopCheck = function(){
//        $scope.
    }
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
            case 'self_check_status':
                $scope.checkerStatus.init();
                $scope.page_index = name;
                break;
            case 'settings':
                $scope.user_settings.get_config();

                $scope.page_index = name;
                break;

            case 'caution':
        		$scope.caution_manage.getAllCautions();
                $scope.page_index = name;
                break;
		break;
            case 'user_log':
            case 'manul':
            case 'report':
            case 'smb_page':
                $scope.page_index = name;
                break;
            default:
                $scope.page_index = 'main';
        }
    }

	$scope.caution_manage = new CautionManage();
    $scope.change_page_index($scope.username == 'useradmin' ? 'main' : 'user_log');



    /*
        配置信息
    */
    $scope.user_settings = new UserSettings();

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
                password: hex_md5(password),
				password_text: password
            }
        }).success(function(data){
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
                password: hex_md5($scope.new_password),
				password_text: $scope.new_password
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

    $scope.reload_users = function () {
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

    $scope.log_date_selected = function(d)
    {
        $scope.user_logs = [];
        if (d == null) return;

        $scope.user_log_loading = true;
        $http({
            url: '/?a=getlog',
            method: 'get',
            params: {
                date: d.text
            }
        })
        .then(function(payload) {
            $scope.user_log_loading = false;           
            if (payload.status != 200) return;
                
            $scope.user_logs = payload.data;
        });
    }

    $http({
            url:'/?a=getlogdates',
            method:'get'
    })
    .then(function(payload){
        if (payload.status != 200) return;

        $scope.log_months = payload.data;
    });

    $scope.reload_user_log = function () {
        console.log('obsolete function reload_user_log, user log_date_selected'); return;
        if ($scope.user_log_loading) return;

        $http({
            url:'/?a=getlogdates',
            method:'get'
        })
        .success(function(data){
            $scope.log_months = data;
        });

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
    };

    ($scope.init_date_picker = function () {
        $.fn.datepicker.defaults.format = 'yyyy-mm-dd';
        $("[data-plugin-datepicker]").datepicker();
    })();


    $timeout(function () {
        if ($scope.username === 'logadmin') $scope.reload_user_log();
        else {
            $scope.reload_users();

            $scope.init_smb();
        }
    }, 500);
});
