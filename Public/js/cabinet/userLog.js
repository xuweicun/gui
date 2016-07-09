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
                default: return cmd;
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
    }).factory('ErrCode', function () {
        return {
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
			"10015": "subcmd unknown",
			"10016": "mount path not find",
			"10017": "mount path not string",
			"10018": "mount path unknown",
			"10019": "level not find",
			"10020": "level not number",
			"10021": "level out of range",
			"10022": "group not find",
			"10023": "group not number",
			"10024": "disk not find",
			"10025": "disk not number",
			"10026": "status not find",
			"10027": "status not number",
			"10028": "srclevel not find",
			"10029": "srclevel not number",
			"10030": "srcgroup not find",
			"10031": "srcgroup not bumber",
			"10032": "srcdisk not find",
			"10033": "srcdisk not number",
			"10034": "dstlevel not find",
			"10035": "dstlevel not number",
			"10036": "dstgroup not find",
			"10037": "dstgroup not number",
			"10038": "dstdisk not find",
			"10039": "dstdisk not number",
			"10040": "levels not find",
			"10041": "levels not array",
			"10042": "levels array empty",
			"10043": "levels item not number",
			"10044": "levels item out of range",
			"10045": "disks not find",
			"10046": "disks not array",
			"10047": "disks array empty",
			"10048": "disks item not object",
			"10049": "disks item id invalid",
			"10050": "disks item SN invalid",
			"10051": "json field not find",
			"10052": "json file format error",
			"10053": "json field is not number",
			"10054": "json field is zero size",
			"10055": "json field out of range",
			"10056": "json field is not array",
			"10057": "json field is not object",
			"10058": "Copy diffrent src level and dst level",
			"10059": "Copy unexpect dst group",
			"10060": "Power levels is not selected",
			"10061": "FileTree is runing",
			"10062": "FileTree dismatch",
			"10063": "FileTree mount path is too long",
			"10064": "FileTree mount path not find",
			"10065": "FileTree mountpath is invalid",
			"10066": "FileTree make path failure",
			"10067": "FileTree remove dir failure",
			"10068": "FileTree cancel",
			"10069": "FileTree not going",
			"10070": "Json format error",
			"10071": "Json is not object",
			"10072": "Json unknown cmd",
			"11": "disk info fail",
			"12": "get md5 result fail",
			"13": "get md5 progress fail",
			"14": "get copy progress fail",
			"15": "copy size dismatch",
			"16": "copy no disk",
			"2": "bad param",
			"20": "power no resp",
			"21": "device status timeout",
			"22": "device status timeout",
			"23": "md5 not started",
			"24": "copying",
			"25": "bridging",
			"26": "copying",
			"27": "disk info is going",
			"28": "md5 is going",
			"29": "optics channel is busy",
			"3": "no disk",
			"30": "physical error",
			"31": "level not match",
			"32": "group not match",
			"33": "md5 stop is going",
			"35": "unknown device id",
			"36": "bridge is going",
			"4": "no bridge",
			"40": "device status is going",
			"42": "copy not started",
			"43": "write protect is going",
			"45": "failed to see disk on windows",
			"46": "power is going",
			"47": "failed to see disk signal on optics to usb",
			"48": "failed to see disk signal on cabinet",
			"49": "failed to see disk signal on eight optics interface",
			"5": "no device id",
			"50": "network failure",
			"51": "failed to see disk on linux",
			"6": "no response from device",
			"7": "bridge visible timeout windows",
			"8": "data loss",
			"9": "device invalid"
        };
    });
}