function User(id, uname, write, token) {
    // 用户ID
    this.id = id;
    // 用户名
    this.username = uname;
    // 写权限
    this.can_write = write;
    this.token = token;
    console.log("token:",token);
    this.off_line = false;
    this.new_pwd = '';
    this.new_pwd_confirm = '';
    this.err_msg = "";

    // 二次密码是否验证通过
    this.second_pwd = '';
    this.modal_id_after_second_pwd = '';
}
User.prototype = {
    show_logout_modal: function(){
        global_modal_helper.show_modal({
            type: 'question',
            title: '用户注销',
            html: '您确定要注销用户[<span class="bk-fg-primary">' + this.username + '</span>]，注销后需要重新登录。',
            on_click_target: this,
            on_click_handle: 'go_logout_page'
        });
    },
    loged_out: function () {
        global_http({
            url: global_root + "&a=logout",
            method: 'POST',
            data: {}
        }).success(function () {
            that.off_line = true;
        });

        //被异地登录
        global_modal_helper.show_modal({
            type: 'warning',
            title: '服务器连接断开',
            html: '您的账号[<span class="bk-fg-primary">'+ this.username +'</span>]在其他设备上登录, 与服务器的连接已中断，请重新登录。',
            on_click_target: this,
            on_click_handle: 'go_login_page'
        });
    },
    go_login_page: function(){
        window.location = "/index.php?m=admin&c=business&a=login";
    },
    go_logout_page: function (now) {
        window.location = '/index.php?m=admin&c=business&a=logout' + (now?'_immediate':'');
    }
    ,
    show_second_pwd_modal: function (modal_id) {
        this.modal_id_after_second_pwd = modal_id;
        this.second_pwd = '';

        global_modal_helper.show_modal_user('userModalSecondPassword');
    },
    second_pwd_validate: function () {
        this.err_msg = "";

        if (this.second_pwd == undefined || this.second_pwd == '') {
            this.err_msg = "密码不能为空!";
            return;
        }
        
        global_http({
            url: global_root + "&a=passwordValidate",
            method: 'POST',
            data: {
                id: this.id,
                password: hex_md5(this.second_pwd)
            }
        }).success(function (data) {
            //响应成功
            try {
                var rlt = JSON.parse(data);
                if (rlt.status == 'success') {
                    global_modal_helper.show_modal_user(global_user.modal_id_after_second_pwd);
                }
                else {
                    new PNotify({
                        title: '二次密码',
                        text: '密码验证失败，无法继续后续操作！',
                        type: 'error',
                        shadow: true
                    });
                    $.magnificPopup.close();
                }
            } catch (err) {
            }
            finally {
            }
        }).error(function () {
            new PNotify({
                title: '二次密码',
                text: '密码验证失败',
                type: 'error',
                shadow: true
            });
        });
    },
    show_second_pwd_modal_with_action: function (action, param) {
        this.err_msg = "";
        this.second_pwd = '';
        this.second_pwd_action = action;
        this.second_pwd_param = param;
        
        global_modal_helper.show_modal_user('userModalSecondPassword');
    },
    second_pwd_validate_with_action: function () {
        console.log('link' + global_scope.btn_guard);

        if (global_scope.btn_guard) return;
        global_scope.btn_guard = true;

        this.err_msg = "";

        if (this.second_pwd == undefined || this.second_pwd == '') {
            this.err_msg = "密码不能为空!";
            global_scope.btn_guard = false;
            return;
        }

        $.magnificPopup.close();

        global_http({
            url: global_root + "&a=passwordValidate",
            method: 'POST',
            data: {
                id: this.id,
                password: hex_md5(this.second_pwd)
            }
        }).success(function (data) {
            //响应成功
            try {
                var rlt = JSON.parse(data);
                if (rlt.status == 'success') {
                    global_user.second_pwd_action(global_user.second_pwd_param);
                }
                else {
                    new PNotify({
                        title: '二次密码',
                        text: '密码验证失败，无法继续后续操作！',
                        type: 'error',
                        shadow: true
                    });
                }
            } catch (err) {
            }
            finally {
                global_scope.btn_guard = false;
            }
        }).error(function () {
            global_scope.btn_guard = false;
            new PNotify({
                title: '二次密码',
                text: '密码验证失败',
                type: 'error',
                shadow: true
            });
        });
    },
    showChangePasswordModal: function () {
        this.err_msg = '';
        this.new_pwd = '';
        this.new_pwd_confirm = '';
        global_modal_helper.show_modal_user('userModalChangePassword');
    },
    changePassword: function () {
        this.err_msg = "";

        if (this.new_pwd == undefined || this.new_pwd == '') {
            this.err_msg = "密码为空!";
            return;
        }

        if (this.new_pwd_confirm == undefined || this.new_pwd_confirm == '') {
            this.err_msg = "确认密码为空!";
            return;
        }

        if (this.new_pwd != this.new_pwd_confirm) {
            this.err_msg = "密码不一致!";
            return;
        }

        global_http({
            url: '/?a=user_passwd_reset',
            method: 'POST',
            data: {
                id: this.id,
                password: hex_md5(this.new_pwd),
				password_text: this.new_pwd
            }
        }).success(function (data) {
            //响应成功
            try {
                var rlt = JSON.parse(data);
                if (rlt.status == 'success') {
                    new PNotify({
                        title: '重置密码',
                        text: '成功重置用户密码',
                        type: 'success',
                        shadow: true
                    });
                }
                else {
                    new PNotify({
                        title: '重置密码',
                        text: '重置用户密码失败',
                        type: 'error',
                        shadow: true
                    });
                }
            } catch (err) {
                new PNotify({
                    title: '重置密码',
                    text: '重置用户密码失败',
                    type: 'error',
                    shadow: true
                });
            }
            finally {
            }
        }).error(function (data) {
            new PNotify({
                title: '重置密码',
                text: '重置用户密码失败',
                type: 'error',
                shadow: true
            });
        });

        $.magnificPopup.close();
    }
}