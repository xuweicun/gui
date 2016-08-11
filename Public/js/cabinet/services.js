angular.module('device.services', [])
    .factory('Errcode', function () {

            return {
                getErrName: function (code) {
                    if (code in errCodes) {
                        return errCodes[code];
                    }
                    return "Error code not defined!";
                }
            }

        }
    ).factory('TestMsg', function () {

        var msg = {
            diskinfo: {
                "CMD_ID": "144",
                "cmd": "DISKINFO",
                "device_id": "1",
                "disk": "3",
                "group": "1",
                "level": "2",
                "status": "0",
                "substatus": "1",
                'SN':'43JFEI',
                'capacity':'3030'
            },
            devicestatus: {
                "CMD_ID": "121",
                "cmd": "DEVICESTATUS",
                "device_id": "1",
                "levels": [{"groups": [{"disks": ["1"], "id": "2"}], "id": "1"}, {
                    "groups": [{"disks": ["3"], "id": "1"}],
                    "id": "2"
                }, {"groups": [{"disks": ["3"], "id": "3"}], "id": "3"}],
                "status": "0",
                "substatus": "0"
            },
            bridge: {
                "CMD_ID": "124",
                "cmd": "BRIDGE",
                "device_id": "1",
                "disks": [{"SN": "5LY3PRKJ", "id": "1"}],
                "group": "2",
                "level": "1",
                "paths": [{"id": "1", "status": "0", "value": ""}],
                "progress": "75",
                "subcmd": "START",
                "substatus": "2",
                "workingstatus": "59"
            },
            bridge_done: {
                "CMD_ID": "1",
                "cmd": "BRIDGE",
                "device_id": "1",
                "disks": [{"SN": "5LY3PRKJ", "id": "1"}],
                "group": "2",
                "level": "1",
                "paths": [{"id": "1", "status": "0", "value": "sdb"}],
                "subcmd": "START",
                "substatus": "0"
            },

            md5: {
                "CMD_ID": "703",
                "cmd": "MD5",
                "device_id": "1",
                "disk": "1",
                "group": "1",
                "level": "1",
                "status": "0",
                "subcmd": "STOP",
                "substatus": "0"
            },
            bridge_stop: {
                "CMD_ID": "134",
                "cmd": "BRIDGE",
                "device_id": "1",
                "disks": [{"SN": "5LY3PRKJ", "id": "1"}],
                "group": "2",
                "level": "1",
                "paths": [{"id": "1", "status": "0", "value": ""}],
                "subcmd": "STOP",
                "substatus": "0"
            }
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
    })
    .factory('Lang', function () {
        var param = {
            'success': 0,
            'timeout': -3,
            'going': -1,
            'canceled': -2
        }
        var errCodes = {
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
            "2000":"命令启动超时,请重试",
            "2001":"命令长时间未执行,已取消",
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
        }
        var lang = [
            {
                code: 'FILETREE',
                cn: '重建离线索引'
            },
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
                code: "52",
                cn: '（1/12）BRIDGE_EIGHTOPTICS_RECEIVED_START_COMMAND'
            },
            {
                code: "53",
                cn: '（2/12）光口FPGA通道开启，硬盘通道准备完毕',
            },
            {
                code: "54",
                cn: '（3/12）八光口输出通道准备完毕',
            },
            {
                code: "55",
                cn: '（4/12）八光口输入通道与输出通道连接完毕',
            },
            {
                code: "56",
                cn: '（5/12）命令已收到',
            },
            {
                code: "57",
                cn: '（6/12）控制器已加电，硬盘可见',
            },
            {
                code: "58",
                cn: '（7/12）存储柜信号输出中',
            },
            {
                code: "59",
                cn: '（8/12）收到光口到串口命令',
            },
            {
                code: "60",
                cn: '（9/12）光口到串口控制器启动完毕',
            },
            {
                code: "61",
                cn: '（10/12）光口到串口信号输出中',
            },
            {
                code: "62",
                cn: '（11/12）光口到串口信号输出成功',
            }
        ];
        return {
            getErrorMsg: function(errno){
				switch(errno){
				case '0':
					return '成功';
				case '-2': 
					return '撤销';
				default:
                    return errCodes[errno] + '[' + errno + ']';					
				}
            },
            getLang: function (code) {
                if (typeof (code) == 'number') {
                    if (code > param.success) {
                        return errCodes[code] + '[' + code + ']';
                    }
                    code = code.toString();
                }
                for (var idx = 0; idx < lang.length; idx++) {

                    if (lang[idx].code === code) {
                        return lang[idx].cn;

                    }
                }
                //console.log(code);
                return '未知状态' + code + ':' + typeof(code);
            },
            param_success: param.success,
            param_timeout: param.timeout,
            param_canceled: param.canceled,
            param_going: param.going,
            /*****
             * 将秒数转化为分钟小时数
             * @param _time
             */
            getTime: function (_time) {
                var theTime = parseInt(_time);// 秒
                var theTime1 = 0;// 分
                var theTime2 = 0;// 小时
                if (theTime > 60) {
                    theTime1 = parseInt(theTime / 60);
                    theTime = parseInt(theTime % 60);
                    if (theTime1 > 60) {
                        theTime2 = parseInt(theTime1 / 60);
                        theTime1 = parseInt(theTime1 % 60);
                    }
                }
                var result = "" + parseInt(theTime) + "秒";
                if (theTime1 > 0) {
                    result = "" + parseInt(theTime1) + "分" + result;
                }
                if (theTime2 > 0) {
                    result = "" + parseInt(theTime2) + "小时" + result;
                }
                return result;
            }
        };
    })
    .factory('WebSock', function () {

        var ws = null;
        var user_grp = '';
        var user_id = '';
        WEB_SOCKET_SWF_LOCATION = "/swf/WebSocketMain.swf";
        WEB_SOCKET_DEBUG = true;

        var open = function () {
            // 登录
            var login_data = '{"type":"login","user_grp":"' + user_grp + '","user_id":"' + global_user.id +
                '","client_name":"wilson","room_id":"1","token":"'+global_user.token+'"}';
            console.log("websocket握手成功，发送登录数据:" + login_data);
            ws.send(login_data);
        }

        var onmessage = function (e) {
            console.log(e.data);
            var data = eval("(" + e.data + ")");

            switch (data['type']) {
                // 服务端ping客户端
                case 'ping':
                    console.log(ws);
                    try {
                        ws.send('{"type":"pong"}');
                        //throw new Error("发送消息失败");
                    } catch (e) {
                        console.log("解析出错", e.message);
                    }finally {
                        console.log("right");
                    }
                    break;
                // 登录 更新用户列表
                case 'login':
                    //{"type":"login","client_id":xxx,"client_name":"xxx","client_list":"[...]","time":"xxx"}
                    //token检查是否冲突
                    if(data['token'] == global_user.token)
                    {
                        console.log("自己发出的消息,忽略",data['token'],global_user.token);
                        break;
                    }
                    else{
                        console.log(data['user_id'],global_user.id);
                        if(data['user_id'].toString() == global_user.id.toString()){
                            //异地登录,需要退出
                            console.log("new User:", data['user_name']);
                            global_user.loged_out();
                        }

                    }

                    break;
                case 'say':

                   // console.log("new cmd:", data['user_id']);
                   // console.log(data['0']);
                    //增加新消息
                    var cmd_log = data['0'];
                    cmd_log.user_name = data['user_name'];
                    if(cmd_log.msg == ''){
                        cmd_log.msg = cmd_log.return_msg;
                    }
                    global_cmd_helper.onWsMsg(cmd_log);
                    break;
                case 'logout':
                    //{"type":"logout","client_id":xxx,"time":"xxx"}
                    console.log("其他用户退出登录");
                    break;
                case 'status':
                    console.log('收到推送的状态信息');
                    var num = data['num'];
                    for(var i = 0;i <num;i++) {
                        global_cabinet_helper.i_on_msg_push_status(data[i.toString()]);
                    }
                    break;
                case 'partition':
                    console.log('收到推送的分区容量信息');
                    var num = data['num'];
                    for(var i = 0;i <num;i++) {
                        global_cabinet_helper.i_on_msg_push_partition(data[i.toString()]);
                    }
                    break;
                case 'check_status':
                    console.log('自检消息',data['msg']);
                    break;
                case 'cab_caution':
                    global_scope.on_caution_msgs(data);
                    break;
                case 'selfcheck':
                    //添加新
                    break;
                case 'cmd_caution':
                    var num = data['num'];
                    var err_msg = '命令执行异常';
                    for(var i = 0;i <num;i++) {
                        $caution = data[i.toString()];
                        if($caution['cmd']=='BRIDGE'){
                            //桥接
                            $cab_id = $caution['cab'];
                            if($cab_id == global_cabinet.curr.id){
                                global_cmd_helper.updateDeviceStatus();
                            }
                        }
                    }
                    global_scope.caution_manage.getCautions();

                    toastr.error(err_msg);
                    break;

            }


        }
        var domain = document.domain;
        var port   = '8383';
        if(domain == 'localhost')
            domain = '222.35.224.230';
        var wm_server = "ws://"+domain+":"+port;
        var sendcmd = function (cmd) {
            cmd.to_client_id = "all";
            cmd.to_client_name = 1;
            //cmd_str = "test string";
            cmd.type = "say";
            cmd.content = "test string";
            cmd.user_id = global_user.id;
            var cmd_str = JSON.stringify(cmd);
            ws.send(cmd_str);

        }
        var close = function () {
            console.log("连接关闭,正在重新连接中");
            ws = new WebSocket(wm_server);
            ws.onmessage = onmessage;
            ws.onclose = close;
            ws.onopen = open;
            ws.sendcmd = sendcmd;
        }
        return {
            connect: function (id, grp) {
                user_id = id;
                user_grp = grp;
                ws = new WebSocket(wm_server);
                ws.onmessage = onmessage;
                ws.onclose = close;
                ws.onopen = open;
                ws.sendcmd = sendcmd;
                return ws;
            },
            wm_server: wm_server
        }
    });
