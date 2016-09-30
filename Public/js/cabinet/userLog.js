function register_filters(ctrl)
{
    ctrl.filter('CMD', function () {
        return function (cmd) {
            switch (cmd) {
                case 'BRIDGE': return '桥接';
                case 'COPY': return '复制';
                case 'DEVICEINFO': return '存储柜查询';
                case 'DEVICESTATUS': return '在位查询';
                case 'DISKINFO': return '查询';
                case 'FILETREE': return '构建索引';
                case 'MD5': return 'MD5';
                case 'WRITEPROTECT': return '写保护';
                case 'SYSTEM_RESET': return '系统重置';
                default: return cmd;
            }
        }
    }).filter('SUBCMD', function () {
        return function (subcmd) {
            switch (subcmd) {
                case 'START': return '启动';
                case 'STOP': return '停止';
                case 'PROGRESS': return '进度查询';
                case 'RESULT': return '取结果';
                default: return subcmd;
            }
        }
    }).filter('CABINET_ID', function () {
        return function (msg) {
            if (!msg) return '-';

            try {
                var msg_obj = JSON.parse(msg);
                return msg_obj.device_id ? msg_obj.device_id + '#' : '-';
            }
            catch (e) {
                console.log(msg);
                return '-';
            }
        }
    }).filter('DISK_INFO', function () {
        return function (msg) {
            if (!msg) return '-';

            try {
                var msg_obj = JSON.parse(msg);
                var ret_str = '';
                switch (msg_obj.cmd) {
                    case 'BRIDGE': {
                        for (var i = 0; i < msg_obj.disks.length; ++i) {
                            if (ret_str) ret_str += ', ';
                            ret_str += msg_obj.level + '-' + msg_obj.group + '-' + msg_obj.disks[i].id + '#';
                        }
                        break;
                    }
                    case 'COPY': {
                        ret_str = '源盘' + msg_obj.srcLevel + '-' + msg_obj.srcGroup + '-' + msg_obj.srcDisk
                                + '# --> 目标盘'
                                + msg_obj.dstLevel + '-' + msg_obj.dstGroup + '-' + msg_obj.dstDisk
                                + '#';
                        break;
                    }
                    case 'DEVICEINFO':
                    case 'DEVICESTATUS': {
                        ret_str = '-';
                        break;
                    }
                    case 'DISKINFO':
                    case 'FILETREE':
                    case 'MD5': {
                        ret_str = msg_obj.level + '-' + msg_obj.group + '-' + msg_obj.disk + '#';
                        break;
                    }
                    case 'WRITEPROTECT': {
                        ret_str = '第' + msg_obj.level + '层';
                        break;
                    }
                    default: ret_str = '-';
                }
                return ret_str;
            }
            catch (e) {
                console.log(msg);
                return '-';
            }
        }
    }).filter('ERRCODE', function (ErrCode) {
        return function (err) {
            if (err == -1) {
                return '启动中';
            }
            else if (err == -2) {
                return '被停止';
            }
            else if (err == 0) {
                return '正常';
            }
            return '异常: ' + (ErrCode[err] ? ErrCode[err] + '(' + err + ')' : err);
        }
    }).filter('FINISHED', function () {
        return function (f) {
            switch (f) {
                case '0': return '进行中';
                case '1': return '已完成';
                default: return f;
            }
        }
    }).filter('BRIDGED', function () {
				return function (f) {
					switch (f) {
						case '0': return '未桥接';
						case '1': return '已桥接';
						default: return f;
					}
				}
			})
			.factory('ErrCode', function () {
        var err_code = {
            "0": "no error",
            "1": "bridge not started",
            "10": "md5 not complete",
            "10001": "proxy error",
            "10002": "proxy disconnect",
            "10003": "field not find",
            "10004": "field not number",
            "10005": "field not string",
            "10006": "cmdid not find",
            "10007": "cmdid not number",
            "10008": "deviceid not find",
            "10009": "device not number",
            "10010": "cmd not find",
            "10011": "cmd not string",
            "10012": "cmd unknown",
            "10013": "subcmd not find",
            "10014": "subcmd not string",
            "10016": "subcmd unknown",
            "10017": "mount path not find",
            "10018": "mount path not string",
            "10019": "mount path unknown",
            "10020": "level not find",
            "10021": "level not number",
            "10022": "level out of range",
            "10023": "group not find",
            "10024": "group not number",
            "10025": "disk not find",
            "10026": "disk not number",
            "10027": "samba uname not find",
            "10028": "samba uname not string",
            "10030": "samba pwd not find",
            "10031": "samba pwd not string",
            "10033": "samba ips not find",
            "10034": "samba ips not string",
            "10035": "samba access not find",
            "10036": "samba access not number",
            "10037": "samba subcmd not find",
            "10038": "samba subcmd not number",
            "10039": "status not find",
            "10040": "status not number",
            "10041": "srclevel not find",
            "10042": "srclevel not number",
            "10043": "srcgroup not find",
            "10044": "srcgroup not bumber",
            "10045": "srcdisk not find",
            "10046": "srcdisk not number",
            "10047": "dstlevel not find",
            "10048": "dstlevel not number",
            "10049": "dstgroup not find",
            "10050": "dstgroup not number",
            "10051": "dstdisk not find",
            "10052": "dstdisk not number",
            "10053": "levels not find",
            "10054": "levels not array",
            "10055": "levels array empty",
            "10056": "levels item not number",
            "10057": "levels item out of range",
            "10058": "disks not find",
            "10059": "disks not array",
            "10060": "disks array empty",
            "10061": "disks item not object",
            "10062": "disks item id invalid",
            "10063": "disks item SN invalid",
            "10064": "json field not find",
            "10065": "json file format error",
            "10066": "json field is not number",
            "10067": "json field is zero size",
            "10068": "json field out of range",
            "10069": "json field is not array",
            "10070": "json field is not object",
            "10071": "copy diffrent src level and dst level",
            "10072": "copy unexpect dst group",
            "10073": "power levels is not selected",
            "10074": "fileTree is runing",
            "10075": "fileTree dismatch",
            "10076": "fileTree mount path is too long",
            "10077": "fileTree mount path not find",
            "10078": "fileTree mountpath is invalid",
            "10079": "fileTree make path failure",
            "10080": "fileTree remove dir failure",
            "10081": "fileTree cancel",
            "10082": "fileTree not going",
            "10083": "json format error",
            "10084": "json is not object",
            "10085": "json unknown cmd",
            "11": "fail to see fpgaid on gui",
            "12": "fail to see fapgaid on eight optics",
            "13": "fail to see fpgaid on optics to usb",
            "14": "md5 fail for no progress",
            "15": "copy size dismatch",
            "16": "copy fail for no progress",
            "2": "bad param",
            "20": "power no resp",
            "21": "device status timeout",
            "22": "device status timeout",
            "23": "md5 not started",
            "24": "copy start in progress",
            "25": "resource bridge in progress",
            "26": "resource copy in progress",
            "27": "resource disk info in progress",
            "28": "resource md5 in progress",
            "29": "resource optics in progress",
            "3": "no disk",
            "30": "physical error",
            "31": "fail to power on optics to usb fpga",
            "32": "fail to power on eight optics interface to fpga",
            "33": "fail to power on cabinet fpga",
            "35": "unknown device id",
            "36": "pre-bridge in progress",
            "4": "no bridge",
            "40": "pre-device status in progress",
            "42": "copy not started",
            "43": "pre-write protected in progress",
            "45": "failed to see disk on windows",
            "46": "pre-power in progress",
            "47": "failed to see disk signal on optics to usb",
            "48": "failed to see disk signal on cabinet",
            "49": "failed to see disk signal on eight optics interface",
            "5": "no device id",
            "50": "network failure",
            "51": "failed to see disk on linux",
            "6": "no response from device",
            "63": "runtime caution on bridge",
            "64": "runtime caution on copy",
            "65": "runtime caution on md5",
            "7": "bridge visible timeout windows",
            "8": "data loss",
            "9": "device invalid"
        };

        err_code['-3'] = 'tiemout';

        return err_code;
    });
}
