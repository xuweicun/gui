function Caution()
{
    this.id = 0;
    this.cab_id = 0;
    this.time = 0;
    this.warning_value = 0;
    this.channel_error = 0;
    this.warning_msg = '';
}

Caution.prototype = {
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

function CautionManage()
{
    this.Cautions = [];
    this.doing = false;
}

CautionManage.prototype = {
    showCautions: function ()
    {
        global_modal_helper.show_modal_user('modalWarningCab');
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
    setCautions: function (msgs)
    {
        if (Object.prototype.toString.call(msgs) !== "[object Object]") {
            this.Cautions = [];
            return;
        }

        var length = parseInt(msgs.num);
        if (length <= 0) {
            this.Cautions = [];
            return;
        }

        var update = false;
        var new_cautions = [];
        for (var i = 0; i < length; ++i) {
            var msg = msgs[i + ''];
            var has = false;
            {
                for (var cau in this.Cautions) {
                    cau = this.Cautions[cau];
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

                var cau = new Caution();
                {
                    cau.id = msg.id;
                    cau.cab_id = status.device_id;
                    cau.time = parseInt(msg.time);
                    cau.setWarning(status.warning);
                    cau.channel_error = status.channel_error;
                }
                new_cautions.push(cau);

                update = true;
            }
        }

        if (update || new_cautions.length < this.Cautions.length) {
            this.Cautions = new_cautions;

            this.showCautions();
        }
    }
};