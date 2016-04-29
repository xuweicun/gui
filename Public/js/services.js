angular.module('device.services', [])
    .factory('Errcode', function () {
            var errCodes = {
                "0": "no error",
                "1": "bridge not started",
                "10": "md5 not complete",
                "10001": "proxy error",
                "10002": "proxy disconnect",
                "10003": "field not find",
                "10004": "field not number",
                "10005": "field not string",
                "10006": "cmd not find",
                "10007": "cmd not string",
                "10008": "cmd unknown",
                "10009": "subcmd not find",
                "10010": "subcmd not string",
                "10011": "subcmd unknown",
                "10012": "level not find",
                "10013": "level not number",
                "10014": "group not find",
                "10015": "group not number",
                "10016": "disk not find",
                "10017": "disk not number",
                "10018": "srclevel not find",
                "10019": "srclevel not number",
                "10020": "srcgroup not find",
                "10021": "srcgroup not bumber",
                "10022": "srcdisk not find",
                "10023": "srcdisk not number",
                "10024": "dstlevel not find",
                "10025": "dstlevel not number",
                "10026": "dstgroup not find",
                "10027": "dstgroup not number",
                "10028": "dstdisk not find",
                "10029": "dstdisk not number",
                "10030": "levels not find",
                "10031": "levels not array",
                "10032": "levels array empty",
                "10033": "levels item not number",
                "10034": "levels item out of range",
                "10035": "disks not find",
                "10036": "disks not array",
                "10037": "disks array empty",
                "10038": "disks item not object",
                "10039": "disks item id invalid",
                "10040": "disks item SN invalid",
                "10041": "json field not find",
                "10042": "json file format error",
                "10043": "json field is not number",
                "10044": "json field is zero size",
                "10045": "json field out of range",
                "10046": "json field is not array",
                "10047": "json field is not object",
                "10048": "Copy diffrent src level and dst level",
                "10049": "Copy unexpect dst group",
                "10050": "Power levels is not selected",
                "10051": "FileTree is runing",
                "10052": "FileTree dismatch",
                "10053": "FileTree mount path is too long",
                "10054": "FileTree mountpath is invalid",
                "10055": "FileTree make path failure",
                "10056": "Json format error",
                "10057": "Json is not object",
                "10058": "Json unknown cmd",
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
                "30": "unknown error",
                "31": "level not match",
                "32": "group not match",
                "33": "md5 stop is going",
                "35": "unknown device id",
                "36": "bridge is going",
                "4": "start md5 fail",
                "40": "device status is going",
                "42": "copy not started",
                "43": "write protect is going",
                "46": "power is going",
                "49": "md5 received by device",
                "5": "stop md5 fail",
                "6": "busy",
                "7": "get md5 result fail",
                "8": "start copy fail",
                "9": "stop copy fail"
            }
            return {
                getErrName: function (code) {
                    if (code in errCodes) {
                        return errCodes[code];
                    }
                    return "Error code not defined!";
                }
            }

        }
    ).factory('TestMsg',function(){

    var msg = {
        diskinfo: {"CMD_ID":"144","cmd":"DISKINFO","device_id":"1","disk":"3","group":"1","level":"2","status":"0","substatus":"1"},
        devicestatus:{"CMD_ID":"121","cmd":"DEVICESTATUS","device_id":"1","levels":[{"groups":[{"disks":["1"],"id":"2"}],"id":"1"},{"groups":[{"disks":["3"],"id":"1"}],"id":"2"},{"groups":[{"disks":["3"],"id":"3"}],"id":"3"}],"status":"0","substatus":"0"},
        bridge:{"CMD_ID":"124","cmd":"BRIDGE","device_id":"1","disks":[{"SN":"5LY3PRKJ","id":"1"}],"group":"2","level":"1","paths":[{"id":"1","status":"0","value":""}],"progress":"75","subcmd":"START","substatus":"2","workingstatus":"59"},
        bridge_done:{"CMD_ID":"1","cmd":"BRIDGE","device_id":"1","disks":[{"SN":"5LY3PRKJ","id":"1"}],"group":"2","level":"1","paths":[{"id":"1","status":"0","value":"sdb"}],"subcmd":"START","substatus":"0"},
        bridge_stop:{"CMD_ID":"134","cmd":"BRIDGE","device_id":"1","disks":[{"SN":"5LY3PRKJ","id":"1"}],"group":"2","level":"1","paths":[{"id":"1","status":"0","value":""}],"subcmd":"STOP","substatus":"0"},
        md5:{"CMD_ID":"504","cmd":"MD5","device_id":"1","disk":"1","group":"1","level":"1","progress":"86.58","status":"0","subcmd":"PROGRESS","substatus":"0"}
    }
    return {
        i_getMsg: function (id) {
          //  if(parseInt(id) == 0)
           // return msg;

            msg.diskinfo['CMD_ID'] = id;
            msg.devicestatus['CMD_ID'] = id;
            msg.bridge['CMD_ID'] = id;
            msg.bridge_done['CMD_ID'] = id;
            msg.bridge_stop['CMD_ID'] = id;
            msg.md5['CMD_ID'] = id;
            return msg;
        }
    };
}) .factory('Lang', function () {
    var param = {
        'success': 0,
        'timeout': -3,
        'going': -1,
        'canceled': -2
    }
    var lang = [
        {
            code: 'DEVICESTATUS',
            cn: '存储柜插槽状态查询'
        },
        {
            code: 'DEVICEINFO',
            cn: '存储柜查询'
        },
        {
            code: 'BRIDGE',
            cn: '桥接'
        },
        {
            code: 'MD5',
            cn: '磁盘校验'
        },
        {
            code: 'COPY',
            cn: '磁盘备份'
        },
        {
            code: 'DISKINFO',
            cn: '磁盘信息查询'
        },
        {
            code: 'WRITEPROTECT',
            cn: '磁盘写保护'
        },
        {
            code: 'START',
            cn: '开始执行'
        },
        {
            code: 'STOP',
            cn: '停止'
        },
        {
            code: 'RESULT',
            cn: '结果查询'
        },
        {
            code: null,
            cn: '开始执行'
        },
        {
            code: "0",
            cn: '成功'
        },
        {
            code: "-2",
            cn: '撤销'
        },
        {
            code: "-3",
            cn: '超时'
        },
        {
            code:"52",
            cn:'BRIDGE_EIGHTOPTICS_RECEIVED_START_COMMAND'
        },
        {
            code:"53",
            cn:'光口FPGA通道开启，硬盘通道准备完毕',
        },
        {
            code:"54",
            cn:'八光口输出通道准备完毕',
        },
        {
            code:"55",
            cn:'八光口输入通道与输出通道连接完毕',
        },
        {
            code:"56",
            cn:'命令已收到',
        },
        {
            code:"57",
            cn:'控制器已加电，硬盘可见',
        },
        {
            code:"58",
            cn:'存储柜信号输出中',
        },
        {
            code:"59",
            cn:'收到光口到串口命令',
        },
        {
            code:"60",
            cn:'光口到串口控制器启动完毕',
        },
        {
            code:"61",
            cn:'光口到串口信号输出中',
        },
        {
            code:"62",
            cn:'光口到串口信号输出成功',
        }
    ];
    return {
        getLang: function (code) {

            if (typeof (code) == 'number') {
                if(code > param.success)
                {
                    return '失败';
                }
                code = code.toString();
            }
            for (var idx = 0; idx < lang.length; idx++) {

                if (lang[idx].code === code) {
                    return lang[idx].cn;

                }
            }
            console.log(code);
            return '未知状态' + code + ':' + typeof(code);
        },
        param_success: param.success,
        param_timeout: param.timeout,
        param_canceled: param.canceled,
        param_going: param.going
    };
});
