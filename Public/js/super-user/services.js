user_app.factory('WebSock', function () {

        var ws = null;
        var user_grp = '';
        var user_id = '';
        WEB_SOCKET_SWF_LOCATION = "/swf/WebSocketMain.swf";
        WEB_SOCKET_DEBUG = true;

        var open = function () {
            var global_user;
            if (global_user) {
                // 登录
                var login_data = '{"type":"login","user_grp":"' + user_grp + '","user_id":"' + global_user.id +
                    '","client_name":"wilson","room_id":"1","token":"'+global_user.token+'"}';
                console.log("websocket握手成功，发送登录数据:" + login_data);
                ws.send(login_data);
            }
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
                case 'selfcheck':
                    //添加新
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
