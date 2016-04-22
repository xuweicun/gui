angular.module('device.services', [])
    .factory('Errcode', function () {
            var errCodes = {
                "0": "no error",
                "1": "slot busy",
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
                "23": "write protect no resp",
                "24": "copying",
                "25": "bridging",
                "26": "copying",
                "27": "disk info is going",
                "28": "md5 is going",
                "29": "channel is busy",
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
        diskinfo: {"CMD_ID":"117","SN":"5LY3PRKJ","SmartAttrs":[{"Attribute_ID":"01","Current_value":"00","Data":"29677D22","ExtData":"0001","Threshold":"55","Worst_value":"6C"},{"Attribute_ID":"03","Current_value":"00","Data":"00000000","ExtData":"0000","Threshold":"63","Worst_value":"63"},{"Attribute_ID":"04","Current_value":"00","Data":"002A2514","ExtData":"0000","Threshold":"5A","Worst_value":"5A"},{"Attribute_ID":"05","Current_value":"00","Data":"00000024","ExtData":"0000","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"07","Current_value":"00","Data":"5A67101E","ExtData":"0002","Threshold":"3C","Worst_value":"4B"},{"Attribute_ID":"09","Current_value":"DE","Data":"0001A900","ExtData":"AF00","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"0A","Current_value":"00","Data":"00000022","ExtData":"0000","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"0C","Current_value":"00","Data":"00200A14","ExtData":"0000","Threshold":"5C","Worst_value":"5C"},{"Attribute_ID":"BB","Current_value":"00","Data":"00000000","ExtData":"0000","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"BD","Current_value":"00","Data":"00001C00","ExtData":"0000","Threshold":"48","Worst_value":"48"},{"Attribute_ID":"BE","Current_value":"00","Data":"1700172D","ExtData":"0017","Threshold":"26","Worst_value":"4D"},{"Attribute_ID":"BF","Current_value":"00","Data":"00000E00","ExtData":"0000","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"C0","Current_value":"00","Data":"0002BD00","ExtData":"0000","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"C1","Current_value":"00","Data":"00515400","ExtData":"0000","Threshold":"5A","Worst_value":"5A"},{"Attribute_ID":"C2","Current_value":"00","Data":"00001700","ExtData":"0C00","Threshold":"3E","Worst_value":"17"},{"Attribute_ID":"C3","Current_value":"00","Data":"29677D00","ExtData":"0001","Threshold":"3C","Worst_value":"6C"},{"Attribute_ID":"C4","Current_value":"23","Data":"0001B700","ExtData":"0400","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"C5","Current_value":"00","Data":"00000000","ExtData":"0000","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"C6","Current_value":"00","Data":"00000000","ExtData":"0000","Threshold":"64","Worst_value":"64"},{"Attribute_ID":"C7","Current_value":"00","Data":"00000400","ExtData":"0000","Threshold":"C8","Worst_value":"C8"},{"Attribute_ID":"C8","Current_value":"00","Data":"00000000","ExtData":"0000","Threshold":"FD","Worst_value":"64"},{"Attribute_ID":"CA","Current_value":"00","Data":"00000000","ExtData":"0000","Threshold":"FD","Worst_value":"64"}],"capacity":"74","cmd":"DISKINFO","device_id":"1","disk":"1","group":"2","level":"1","status":"0","substatus":"0"},
        devicestatus:{"CMD_ID":"116","cmd":"DEVICESTATUS","device_id":"1","levels":[{"groups":[{"disks":["1"],"id":"2"}],"id":"1"},{"groups":[{"disks":["3"],"id":"1"}],"id":"2"},{"groups":[{"disks":["3"],"id":"3"}],"id":"3"}],"status":"0","substatus":"0"}
    }
    return {
        i_getMsg: function (id) {
            msg.diskinfo['CMD_ID'] = id;
            msg.devicestatus['CMD_ID'] = id;
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
