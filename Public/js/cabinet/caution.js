function Caution()
{
    this.id = 0;
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
                    this.warning.type = this.warning.type < 1 ? 1 : this.warning.type;
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电量：<span class="bk-fg-warning">[告警]</span>';
                    break;
                case 2:
                    this.warning.type = 2;
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电量：<span class="bk-fg-danger">[严重告警]</span>';
                    break;
                default:
                    break;
            }

            switch ((val_w >> 2) & 0x00000003) {
                case 1:
                    this.warning.type = this.warning.type < 1 ? 1 : this.warning.type;
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电流：<span class="bk-fg-warning">[告警]</span>';
                    break;
                case 2:
                    this.warning.type = 2;
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电流：<span class="bk-fg-danger">[严重告警]</span>';
                    break;
                default:
                    break;
            }


            switch ((val_w >> 4) & 0x00000003) {
                case 1:
                    this.warning.type = this.warning.type < 1 ? 1 : this.warning.type;
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电压：<span class="bk-fg-warning">[告警]</span>';
                    break;
                case 2:
                    this.warning.type = 2;
                    if (warn_msg) warn_msg += '，';
                    warn_msg += '电压：<span class="bk-fg-danger">[严重告警]</span>';
                    break;
                default:
                    break;
            }

            for (var i = 1; i <= 6; i++) {
                switch ((val_w >> (4 + i * 2)) & 0x00000003) {
                    case 1:
                        this.warning.type = this.warning.type < 1 ? 1 : this.warning.type;
                        if (warn_msg) warn_msg += '，';
                        warn_msg += '第' + i + '层湿度：<span class="bk-fg-warning">[告警]</span>';
                        break;
                    case 2:
                        this.warning.type = 2;
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
                        this.warning.type = this.warning.type < 1 ? 1 : this.warning.type;
                        if (warn_msg) warn_msg += '，';
                        warn_msg += '第' + i + '层温度：<span class="bk-fg-warning">[告警]</span>';
                        break;
                    case 2:
                        this.warning.type = 2;
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
}

CautionManage.prototype = {
    setCautions: function (msgs)
    {
        if (Object.prototype.toString.call(msgs) === "[object]") {
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
                    cau.setWarning(status.warning);
                    cau.channel_error = status.channel_error;
                }
                new_cautions.push(cau);

                update = true;

                break;
            }
        }

        if (update || new_cautions.length < this.Cautions.length) {
            this.Cautions = new_cautions;
        }
    }
};