function Checker() {
    this.type = null;
    this.start_time = null;
    this.progress = null;
    this.status = null;
    this.id = null;
}
Checker.prototype = {
    init: function (data) {
        this.type = data['type'] == 'md5'? 'MD5校验':'健康状况校验';
        this.start_time = data['start_time'];
        this.progress = "Finished:"+data['finished']+"/Going: "+data['going'];
        this.id = data['id'];
        switch (parseInt(data['status'])){
            case -1:
                this.status = '等待中';
                break;
            case 0:
                this.status = '进行中';
                break;
            case 1:
                this.status  = '已完成';
                break;
            default:
                this.status = '已取消或终止';
        }
    }
}
function CheckStatus(){
    this.checkers = [];
}
CheckStatus.prototype = {
    init: function () {
        var that = this;
        global_http({
            url: '/index.php?m=admin&c=business&a=getCheckStatus',
            method: 'get'
        }).success(function (data) {
            that.checkers = [];
            if(data){
                data.forEach(function(e){
                    var checker = new Checker();
                    checker.init(e);
                    that.checkers.push(checker);
                });
            }
        }).error(function (data) {
            new PNotify({
                title: '获取自检状态',
                text: "获取自检状态失败",
                type: 'error',
                shadow: true,
                icon: 'fa fa-alarm'
            });
        });
    },
    stopCheck: function(checker){
        var that = this;
        global_http({
            url: '/index.php?m=admin&c=business&a=stopCheck',
            method: 'post',
            data:{'id':checker.id}
        }).success(function (data) {
            if(data){
                if(data['status'] == '0'){
                    new PNotify({
                        title: '操作结果',
                        text: "终止["+checker.type+"]自检计划成功",
                        type: 'success',
                        shadow: true,
                        icon: 'fa fa-check'
                    });
                    that.init();
                }
                else{
                    new PNotify({
                        title: '操作结果',
                        text: "终止["+checker.type+"]自检计划失败",
                        type: 'error',
                        shadow: true,
                        icon: 'fa fa-alarm'
                    });
                }
            }
        }).error(function (data) {
            new PNotify({
                title: '获取自检状态',
                text: "与服务器的通信失败，请重试",
                type: 'error',
                shadow: true,
                icon: 'fa fa-alarm'
            });
        });
    }
};

function UserSettings(settings) {
    if (this.time_options.length <= 0) {
        for (var i = 0; i < 24; ++i) {
            this.time_options[i] = {
                val: i,
                text: (i<10?'0'+i:i) + ':00:00'
            };
        }
    }

    this.inited = false;

    this.md5_old = new Check_t('md5');
    this.smart_old = new Check_t('sn');

    this.md5 = angular.copy(this.md5_old);
    this.smart = angular.copy(this.smart_old);
}

UserSettings.prototype = {
    time_options: []
}