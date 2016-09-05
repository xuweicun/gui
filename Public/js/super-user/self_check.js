function DiskCheckStatus(){
    this.cab = 0;
    this.l = 0;
    this.g = 0;
    this.sn_status = 0;
    this.md5_status = 0;
    this.d = 0;
    this.busy = 0;
    this.busy_cmd_id = 0;
    this.busy_cmd = null;
    this.md5_skipped = 0;
    this.md5_skip_time = null;
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
        this.busy_cmd_id = e.busy_cmd_id;
        this.bridged = e.bridged;
        this.md5_skipped = e.md5_skipped;
        this.md5_skip_time = e.md5_skip_time;
        this.check_cmd_status = {'progress':e.progress,'started':e.started,'finished':e.finished,'status':e.status};
    },
    getPos: function(){
        return "#"+this.cab+"-"+this.l+"-"+this.g+"-"+this.d;
    },
    updateCmdStatus: function () {
        var that = this;
        global_http({
            url: '/?a=getCmdResult&id='+that.busy_cmd_id,
            method: 'get'
        }).success(function (data) {
            if(data['errmsg']){
                return;
            }
           that.busy_cmd = data;
        });
    }
    ,
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
        if(this.busy=='1'){
            return "用户使用中";
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
        this.progress = "已完成:"+data['finished']+";进行中: "+data['going']+";总数量:"+data['count'];
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
    },
    isWorking: function () {
        return this.status == '进行中';
    },
    isWaiting: function () {
        return this.status == '等待中';
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
                    if(dsk.busy == '1'){
                        dsk.updateCmdStatus();
                    }
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
    hdlStopCheck: function(chceker){
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
    ,
    stopCheck: function(checker){
        var that = this;
        //global_modal_helper.show_modal_user('superModalChangePassword');
       global_modal_helper.show_modal({
            type: 'question',
            title: '管理员注销',
            html: '您确定要注销，注销后需要重新登录。',
            on_click_handle: function () {
                window.location = "/index.php?m=admin&c=business&a=logout_admin";
            }
        });
        //global_modal_helper.show_modal({type:'question',title:'停止自检',html:'自检尚未完成,您确定停止吗?',
          //  on_click_target:that,on_click_handle:'hdlStopCheck',on_click_param: checker});
    }
};

