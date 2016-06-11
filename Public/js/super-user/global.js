var user_app = angular.module('user_module', ['datatables']);

register_filters(user_app);

user_app.filter('to_trusted', function ($sce) {
    return function (text) {
        return $sce.trustAsHtml(text);
    }
});
user_app.controller('user_controller', function ($scope, $http, $timeout, DTOptionsBuilder, DTDefaultOptions) {

    $scope.url_side_bar = '/bc/Admin/View/Business/super-user-side-bar.html';

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

    // 用于主页切换，在主控、用户日志等之间，默认为main
    $scope.change_page_index = function (name) {
        switch (name) {
            case 'user_log':
                $scope.page_index = name;
                break;
            case 'manul':
                $scope.page_index = name
                break;
            default:
                $scope.page_index = 'main';
        }
    }
    $scope.change_page_index('main');
    console.log($scope.page_index);

    $scope.user_add = function(){
        $scope.new_user = {username:'', password:''};

        $('#modalUserAdd').modal('show');
    }
    $scope.user_add_commit = function(){
        var username = $scope.new_user.username.trim();
        var password = $scope.new_user.password.trim();
        if (username == '' || password == ''){
            return;
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

        $('#modalUserPasswd').modal('show');
    }
    $scope.user_password_reset_commit = function(){
        var password = $scope.new_password.trim();
        if (password == ''){
            return;
        }

        var usr = $scope.users_model[$scope.curr_user_idx];
        $http({
            url:'/index.php?m=admin&c=business&a=user_passwd_reset',
            method:'POST',
            data:{
                id: usr.id,
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

    $scope.reload_users();

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

    $scope.reload_user_log();
});