function CabCmd(log) {

    this.msg = JSON.parse(log.msg);
    this._stime = log.start_time;
    this._ctime = log.current_time;
    this.username = log.username;

    this.device_id = this.msg.device_id;
    this.cab_id = this.msg.device_id;
    this.id = log.id;//log.id和CMD_ID有时不同
    this.dst_id = log.dst_id;//STOP命令需要dst_id;
    this.cmd = this.msg.cmd;
    this.subcmd = this.msg.subcmd;
    this.start_time = null;
    //正在进行命令的status取值
    this.going = -1;
    //已经取消命令的status取值
    this.canceled = -2;
    //超时命令的status值
    this.timeout = -3;
    this.success = 0;
    this.cab_id = 0;
    this.finished = 0;
    //level和group是通用值，多数命令都用到
    this.level = this.msg.level;
    this.group = this.msg.group;
    //disks对于桥接命令有意义，其内部为[{id:1,sn:2},{id:2,sn:3}]的格式，具体可参考通讯协议
    this.disks = null;
    //src和dst仅对拷贝命令有意义
    this.srcDisk = this.msg.srcDisk;
    this.srcLevel = this.msg.srcLevel;
    this.srcGroup = this.msg.srcGroup;
    this.dstDisk = this.msg.dstDisk;
    this.dstLevel = this.msg.dstLevel;
    this.dstGroup = this.msg.dstGroup;
    this.msgStr = log.msg;
    //MD5、diskinfo等命令中，disk值有效
    this.disk = null;
    //命令状态，初始值为-1
    this.status = -1;
    this.substatus = -1;
    //剩余时间，为0时表示时间用完
    this.usedTime = (this._ctime == undefined?0:parseInt(this._ctime) - parseInt(this._stime));
    this.progress = -1;
    this.stage = 0;
    //最长等待，20小时
    this.maxTime = 72000;
    //中等等待时间，300秒
    this.midTime = 3600;
    //最小等待时间，60秒
    this.minTime = 600;
    this.timeLimit = 0;
    //错误信息
    this.errMsg = '';
    this.return_msg = '';
    // 附加信息
    this.extra_info = null;

}

CabCmd.prototype = {    
    init: function () {
		if (!this.msg) return;
		
        this.disk = this.msg.disk;
        this.disks = this.msg.disks;
        this.cab_id = this.msg.device_id;
        this.status = this.going;
        this.finished = this.msg.finished;
        this.timeLimit = this.minTime;
        //根据命令名称判断
        switch (this.cmd) {
            case 'BRIDGE':
                if (this.subcmd != 'START') {
                    this.timeLimit = this.minTime;
                }
                else {
                    this.timeLimit = this.midTime;
                }
                break;
            case 'MD5':
                this.timeLimit = this.maxTime;
                break;
            case 'COPY':
                this.timeLimit = this.maxTime;
                break;
            case 'FILETREE':
                this.timeLimit = this.maxTime;
                break;
            default:
                this.timeLimit = this.minTime;
                break;
        }

        if (this.subcmd === undefined) {
            this.subcmd = null;
        }
        var time = new Date();
        this._stime *= 1000;
        //this.usedTime = parseInt((time.getTime() - parseInt(this._stime)) / 1000);
        if (this.getLeftTime() <= 0) {
            //超时
            this.status = this.timeout;
            this.finished = 1;
            this.setTimeOut();
        }
        //console.log(this.usedTime);
        this.start_time = this._stime;
    },
    setTimeOut: function () {
        global_http({
            url: '/index.php?m=admin&c=business&a=setTimeOut&id=' + this.id,
            method: 'GET'
        }).error(function (data) {
            global_err_pool.add(data);
        });
    },
    isDone: function () {
        return this.finished == 1;
    },
    isSuccess: function () {
        return this.status == this.success;
    },
    killTask: function (_status) {
        this.status = _status;
        this.finished = 1;
        if (_status == this.timeout) {
            this.setTimeOut();
        }
    }
           ,
    getLeftTime: function () {
        return (this.timeLimit - this.usedTime);
    },
    getProgress: function () {
        if (this.subcmd != 'START' || (this.cmd != 'BRIDGE' && this.cmd != 'MD5' && this.cmd != 'COPY')) {
            //  this.progress = parseInt(100 * this.usedTime / this.timeLimit);
        }
        //取进度返回值和估计值的最大值，防止出现进度后退的情况
        if (!this.progress)
            this.progress = 0;
        if (this.progress < parseInt(100 * this.usedTime / this.timeLimit))
            this.progress = parseInt(100 * this.usedTime / this.timeLimit);
        return this.progress;
    },
    getStage: function () {
        if (this.stage == 0) {
            return null;
        }
        return global_lang.getLang(this.stage.toString());
    },
    getStatus: function () {
        if (this.substatus < 0) {
            return '已发出';
        }
        switch (this.substatus) {
            case 0:
                return '成功';
            case 1:
                return '进行中';
            case 2:
                return '进行中';

        }
    },
    updateStatus: function (respData) {
        //利用返回的值更新命令状态
        var task = this;
        task.status = respData['status'];
        task.finished = respData['finished'];
        if (respData['progress']) {
            task.progress = respData['progress'];
        }
        if (respData['stage']) {
            task.stage = respData['stage'];
        }
        //返回的原始数据
        task.return_msg = respData['return_msg'];
        if (respData['extra_info']) {
            try {
                task.extra_info = JSON.parse(respData['extra_info']);
            }
            catch (e) {
            }
        }
    }
};
