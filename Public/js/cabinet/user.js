function User(id, uname, write, token) {
    // 用户ID
    this.id = id;
    // 用户名
    this.username = uname;
    // 写权限
    this.can_write = write;
    this.token = token;
    this.off_line = false;
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
    }
}