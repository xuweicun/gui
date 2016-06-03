function User(id, uname, write, token) {
    // 用户ID
    this.id = id;
    // 用户名
    this.username = uname;
    // 写权限
    this.can_write = write;
    this.token = token;
    this.off_line = false;
    this.new_pwd = '';
    this.new_pwd_confirm = '';
}
User.prototype = {
    loged_out: function(){
        //被异地登录
        var that = this;
        global_http({
            url: global_root+"&a=logout",
            method: 'POST',
            data:{}
        }).success(function(){
            that.off_line = true;
        });
    },
    showChangePasswordModal:function(){
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
            url: '/index.php?m=admin&c=business&a=user_passwd_reset',
            method: 'POST',
            data: {
                id: this.id,
                password: hex_md5(this.new_pwd)
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