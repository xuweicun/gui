function CabCaution()
{
    this.id = 0;
    this.cab_id = 0;
    this.time = 0;
    this.warning_value = 0;
    this.channel_error = 0;
    this.warning_msg = '';
	this.dismissed = '0';
	this.username = '';
}

CabCaution.prototype = {
    setWarning: function (warning)
    {
        var val_w = parseInt(warning);
        this.warning_value = val_w;
        
        var warn_msg = '';
        {
            switch (val_w & 0x00000003) {
                case 1:
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电量：<span class="bk-fg-warning">[告警]</span>';
                    break;
                case 2:
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电量：<span class="bk-fg-danger">[严重告警]</span>';

                    // 停止一键部署
                    global_deploy.stopDeploy();
                    break;
                default:
                    break;
            }

            switch ((val_w >> 2) & 0x00000003) {
                case 1:
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电流：<span class="bk-fg-warning">[告警]</span>';
                    break;
                case 2:
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电流：<span class="bk-fg-danger">[严重告警]</span>';
                    // 停止一键部署
                    global_deploy.stopDeploy();
                    break;
                default:
                    break;
            }


            switch ((val_w >> 4) & 0x00000003) {
                case 1:
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电压：<span class="bk-fg-warning">[告警]</span>';
                    break;
                case 2:
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电压：<span class="bk-fg-danger">[严重告警]</span>';
                    // 停止一键部署
                    global_deploy.stopDeploy();
                    break;
                default:
                    break;
            }

            for (var i = 1; i <= 6; i++) {
                switch ((val_w >> (4 + i * 2)) & 0x00000003) {
                    case 1:
                        if (warn_msg) warn_msg += '，';
                        warn_msg += '第' + i + '层湿度：<span class="bk-fg-warning">[告警]</span>';
                        break;
                    case 2:
                        if (warn_msg) warn_msg += '，';
                        warn_msg += '第' + i + '层湿度：<span class="bk-fg-danger">[严重告警]</span>';
                        break;
                    default:
                        break;
                }
            }

            for (var i = 1; i <= 6; i++) {
                switch ((val_w >> (16 + i * 2)) & 0x00000003) {
                    case 1:
                        if (warn_msg) warn_msg += '，';
                        warn_msg += '第' + i + '层温度：<span class="bk-fg-warning">[告警]</span>';
                        break;
                    case 2:
                        if (warn_msg) warn_msg += '，';
                        warn_msg += '第' + i + '层温度：<span class="bk-fg-danger">[严重告警]</span>';
                        break;
                    default:
                        break;
                }
            }
        }
        this.warning_msg = warn_msg;
    }
};

function CmdCaution()
{
    this.id = 0;
    this.cab_id = 0;
    this.time = 0;
    this.warning_msg = '';
	this.dismissed = '0';
	this.username = '';
}

CmdCaution.prototype = {
    setWarning: function (cmd, warning)
    {
        var warn_msg = "硬盘";

        switch(cmd.cmd){
        case 'BRIDGE':
            var disk_prev_title = cmd.device_id + '-' + cmd.level + '-'+cmd.group + '-';
            for (var i=0;i<cmd.disks.length;++i) {
                if (i>0) warn_msg += ', ';    

                warn_msg += disk_prev_title + cmd.disks[i].id;
            }
            warn_msg += ' 在执行 [<span class="bk-fg-primary">桥接</span>] ';
            break;
        case 'MD5':
            warn_msg = "MD5 @ " + cmd.device_id + '-' + cmd.level + '-'+cmd.group + '-' +cmd.disk;
            warn_msg += ' 在执行 [<span class="bk-fg-primary">MD5</span>] ';
            break;
        case 'COPY':
            warn_msg = "COPY @ " + cmd.device_id + '-' + cmd.srcLevel + '-'+cmd.srcGroup + '-' +cmd.srcDisk + ' -> ' + cmd.device_id + '-' + cmd.dstLevel + '-'+cmd.dstGroup + '-' +cmd.dstDisk;
            warn_msg += ' 在执行 [<span class="bk-fg-primary">复制</span>] ';
            break;
        default:
            throw 'unknown cmd for cmd caution';
        };

        warn_msg += '命令时发生告警，类别为 ';
        switch(warning) {
        case '1': 
            warn_msg += '[<span class="bk-fg-danger">硬件故障</span>]';
            break;
        case '2': 
            warn_msg += '[<span class="bk-fg-warning">一般</span>]';
            break;
        default: 
            warn_msg += '[<span class="bk-fg-danger">严重</span>]';
            break;
        }    

        this.warning_msg = warn_msg;
    }
};

function CautionManage()
{
    this.Cautions = [];
    this.CmdCautions=[];
    this.CabCautions = [];
    this.doing = false;
}

CautionManage.prototype = {
    showCautions: function ()
    {
	try{
		global_modal_helper.show_modal_user('modalWarningCab');
	}
	catch(e){
	}
    },
    doCautions: function ()
    {
        if (this.doing) return;

        $.magnificPopup.close();

        this.doing = true;
        var that_caution = this;
        global_http({
            url: '/?a=dismissAllCaution',
            method: 'post',
            data: {
                user_id: global_user.id
            }
        })
        .success(function (data) {
            toastr.success('处理成功', '告警处理');
            that_caution.doing = false;
        })
        .error(function (data) {
            toastr.error('处理失败', '告警处理');
            that_caution.doing = false;
        });
    },
	getAllCautions: function()
	{
		var that_caution = this;
		global_http({
		    url: '/?a=getCabCaution',
		    method: 'get'
		})
		.success(function (data) {
            if (!data) return;

		    that_caution.setCautions(data.cab_caution);
            that_caution.setCmdCautions(data.cmd_caution);

            that_caution.Cautions = that_caution.CabCautions.concat(that_caution.CmdCautions);

            that_caution.Cautions.sort(function(a,b){
                return a.time > b.time;
            });
		});

	},
    getCautions: function ()
    {
        var that_caution = this;
        global_http({
            url: '/?a=getCabCaution',
            method: 'post',
            data: {
                type: 'new'
            }
        })
        .success(function (data) {
            if (!data) return;

            that_caution.setCautions(data.cab_caution);
            that_caution.setCmdCautions(data.cmd_caution);
            that_caution.Cautions = that_caution.CabCautions.concat(that_caution.CmdCautions);

            that_caution.Cautions.sort(function(a,b){
                return a.time > b.time;
            });
        });
    },
    setCmdCautions: function (msgs)
    {
        console.log(msgs);
        if (Object.prototype.toString.call(msgs) !== "[object Array]") {
            this.CmdCautions = [];
            return;
        }

        var length = msgs.length;
        if (length <= 0) {
            this.CmdCautions = [];
            return;
        }

        var update = false;
        var new_cautions = [];
        for (var i = 0; i < length; ++i) {
            var msg = msgs[i];
            var has = false;
            {
                for (var cau in this.CmdCautions) {
                    cau = this.CmdCautions[cau];
                    if (cau.id == msg.id) {
                        has = true;
                        new_cautions.push(cau);
                        break;
                    }
                }
            }

            if (!has) {
                var status = null;
                try {
                    status = JSON.parse(msg.msg);
                }
                catch (e) {
                    console.log(e);
                    continue;
                }

                if (status == null) {
                    continue;
                }

                var cau = new CmdCaution();
                {
                    cau.id = msg.id;
                    cau.cab_id = status.device_id;
                    cau.time = parseInt(msg.time);
                    cau.setWarning(status, parseInt(status.err_code));
                    cau.dismissed = msg.dismissed;
                    cau.username = msg.username;
                }
                new_cautions.push(cau);

                update = true;
            }
        }

        if (update || new_cautions.length < this.CmdCautions.length) {
            this.CmdCautions = new_cautions;

            this.showCautions();
        }
    },
    setCautions: function (msgs)
    {
        if (Object.prototype.toString.call(msgs) !== "[object Array]") {
            this.CabCautions = [];
            return;
        }

        var length = msgs.length;
        if (length <= 0) {
            this.CabCautions = [];
            return;
        }

        var update = false;
        var new_cautions = [];
        for (var i = 0; i < length; ++i) {
            var msg = msgs[i];
            var has = false;
            {
                for (var cau in this.CabCautions) {
                    cau = this.CabCautions[cau];
                    if (cau.id == msg.id) {
                        has = true;
                        new_cautions.push(cau);
                        break;
                    }
                }
            }

            if (!has) {
                var status = null;
                try {
                    status = JSON.parse(msg.status);
                }
                catch (e) {
                    console.log(e);
                    continue;
                }

                if (status == null) {
                    continue;
                }

                var cau = new CabCaution();
                {
                    cau.id = msg.id;
                    cau.cab_id = status.device_id;
                    cau.time = parseInt(msg.time);
                    cau.setWarning(status.warning);
                    cau.channel_error = status.channel_error;
        			cau.dismissed = msg.dismissed;
		        	cau.username = msg.username;
                }
                new_cautions.push(cau);

                update = true;
            }
        }

        if (update || new_cautions.length < this.CabCautions.length) {
            this.CabCautions = new_cautions;

            this.showCautions();
        }
    }
};
