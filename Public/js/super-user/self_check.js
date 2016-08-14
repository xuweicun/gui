function DiskCheckStatus(){
    this.cab = 0;
    this.l = 0;
    this.g = 0;
    this.sn_status = 0;
    this.md5_status = 0;
    this.d = 0;
    this.busy = 0;
    this.busy_cmd = 0;
}
DiskCheckStatus.prototype = {
    init: function(e){
        this.cab = e.cab_id;
        this.l = e.level;
        this.g = e.zu;
        this.d = e.disk;
        this.busy = e.busy;
        this.md5_status = e.md5_status;
        this.sn_status  = e.sn_status;
        this.busy_cmd = e.busy_cmd_id;
        this.bridged = e.bridged;

    },
    getPos: function(){
        return "#"+this.cab+"-"+this.l+"-"+this.g+"-"+this.d;
    },
    transStatus:function(status){

        switch (parseInt(status)){
            case -1:
                return "等待中";
            case 0:
                return "进行中";
            case 1:
                return "已完成";
            case 2:
                return "已取消或失败";
        }
    }
    ,
    getSnStatus: function(){
        return "磁盘信息自检："+this.transStatus(this.sn_status)+";磁盘校验："+this.transStatus(this.md5_status);
    },
    isBusy: function(){
        if(this.busy==1){
            return "忙碌";
        }
        return "空闲";
    }
}
function Checker() {
    this.type = null;
    this.start_time = null;
    this.progress = null;
    this.status = null;
    this.id = null;
    this.disks=[];
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
            that.disks = [];
            if(data){
                //概览
                data['status'].forEach(function(e){
                    var checker = new Checker();
                    checker.init(e);
                    that.checkers.push(checker);
                });
                //磁盘
                data['disks'].forEach(function(e){
                    var dsk = new DiskCheckStatus();
                    dsk.init(e);
                    that.disks.push(dsk);
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