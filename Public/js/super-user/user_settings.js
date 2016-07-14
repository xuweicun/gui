function Check_t(type) {
    this.user_id = 0;
    this.type = type;
    this.unit = 'week';
    this.cnt = '';
    this.start_date = '';
    this.start_time = '';
}

Check_t.prototype = {
    save: function () {
        if (!this.type || !this.unit || !this.cnt || !this.start_date || this.start_time < 0) {
            return;
        }

        /*
        var _data = {
            user_id: global_user.id, //xx,
            unit:this,//week, month or season,
            cnt:,//数字, 
            type: this.type,//md5 or sn,
            start_date:,//“yyyy-mm-dd”的字符串，如果为空则以安装日期为准
            start_time:0-23之间的整数
        };*/
        global_http({
            url: '/index.php?m=admin&c=business&a=AutoCheckConf',
            method: 'post',
            data: this
        }).success(function (data) {
            var rst;
            if(data) rst = JSON.parse(data);
            if (!data || rst.status=='1') {
                new PNotify({
                    title: '保存配置结果',
                    text: '程序异常',
                    type: 'error',
                    shadow: true,
                    icon: 'fa fa-alarm'
                });
            }
            else {
                new PNotify({
                    title: '保存配置结果',
                    text: '成功',
                    type: 'success',
                    shadow: true,
                    icon: 'fa fa-check-o'
                });
            }
        }).error(function (data) {
            new PNotify({
                title: '保存配置结果',
                text: data,
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