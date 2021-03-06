
register_filters(app_device);

app_device.config([
    '$compileProvider',
    function( $compileProvider )
    {   
        $compileProvider.aHrefSanitizationWhitelist(/^\s*(https?|ftp|mailto|liexplorer):/);
         // Angular v1.2 之前使用 $compileProvider.urlSanitizationWhitelist(...)
     }
]);

app_device.filter('to_trusted', function ($sce) {
    return function (text) {
        return $sce.trustAsHtml(text);
    }
}).controller('statusMonitor', function ($scope, $http, $interval, $timeout, $location, locals, Lang, TestMsg, WebSock, DTOptionsBuilder, DTDefaultOptions)
{
    //locals.setObject('test_cmds', []);
	
    $scope.warning_test = function () {
        $scope.cabs.set_warning(1, '', 0x5a5a5a5a, 0x000000aa);
    }

    $scope.warning_test_clear = function () {
        $scope.cabs.set_warning(1, '', 0x00000000, 0x00000000);
    }

    $scope.test = {
        cmds: [],
        remove: function (index) {
            this.cmds.splice(index, 1);
            locals.setObject('test_cmds', this.cmds);
        }
    };
    $scope.locals = locals;
    $scope.test.cmds = locals.getObject('test_cmds');
    if ($scope.test.cmds == undefined) {
        $scope.test.cmds = [];
        locals.setObject('test_cmds', []);
    }

    $scope.caution_manage = new CautionManage();
    $scope.on_caution_msgs = function (msgs)
    {
        //$scope.caution_manage.setCautions(msgs);
    }

    // 防止按钮连续多次点击
    $scope.btn_guard = false;

    $("[data-toggle='popover']").popover();

    global_scope = $scope;
    var businessRoot = '/index.php?m=admin&c=business';
    $scope.bridgeUrl = '/Public/js/bridge.html';

    var url_dir = '/bc/Admin/View/Business/'
    $scope.pageViewUrls = {
        siderBarUrl: url_dir + 'siderBar.html',
        cabUrl: url_dir + 'cabs.html',
        modalHelperUrl: url_dir + 'modalhelper.html',
        cabinetViewUrl: url_dir + 'cabinetView.html',
        diskViewUrl: url_dir + 'diskView.html',
        userModalsUrl: url_dir + 'userModals.html',
        taskViewUrl: url_dir + 'taskView.html',
        notifyViewUrl: url_dir + 'taskView.html',
        logOutViewUrl: url_dir + 'logedOutNotify.html',
        userLogViewUrl: url_dir + 'userLogView.html',
        manulViewUrl: url_dir + 'manul.html'
    };

    // 用于主页切换，在主控、用户日志等之间，默认为main
    $scope.change_page_index = function (name) {
        switch (name) {
            case 'user_log':
            case 'manul':
                $scope.page_index = name
                break;
            default:
                $scope.page_index = 'main';
        }
    }
    $scope.change_page_index('main');

    // 用户对象
    global_user = new User(
        parseInt($('#userid').text()),
        $('#username').text(),
        parseInt($('#can_write').text()),
        $('#token').text()
        );
    $scope.user_profile = global_user;
    switch(global_user.can_write){
        case 1:
            $scope.role ='只读';
            break;
        case 2:
            $scope.role ='高级';
            break;
        default:
            $scope.role ='最低';
            break;
    }
	
	// 如果已经离开，则需要重新登录
	if (locals.get('user_left', 0) == 1) {
	    console.log('user_left');
		locals.set('user_left', 0);
		$scope.user_profile.go_logout_page(true);
		return;
	}
	
	$scope.user_unlock = function ()
	{
	    if (!$scope.user_unlock_pwd) {
	        return;
	    }

	    $scope.btn_guard = true;

		$http({
            url: "/index.php?m=admin&c=business&a=passwordValidate",
            method: 'POST',
            data: {
                id: global_user.id,
                password: hex_md5($scope.user_unlock_pwd)
            }
		}).success(function (data) {

		    $scope.btn_guard = false;
            //响应成功
            try {
                var rlt = JSON.parse(data);
                if (rlt.status == 'success') {
					$scope.taskPool.reset_user_operate_time();
					$scope.user_unlock_msg = '';
					locals.set('user_left', 0);
                }
                else {
                    $scope.user_unlock_msg = '密码验证失败';
                }
            } catch (err) {
                $scope.user_unlock_msg = err.toString();
            }
            finally {
            }
		}).error(function () {
		    $scope.btn_guard = false;
		});
		
		$scope.user_unlock_pwd = '';
	}
	        
    $scope.local_host = $location.host();
    //服务器错误信息池，格式[{errMsg:'err'},{errMsg:'err'}]
    $scope.user = global_user;
    $scope.testMsg = TestMsg;
    $scope.wsWatcher = WebSock;
    $scope.testCmdId = 0;
    $scope.to_post = null;
    var server = businessRoot + '&a=addcmdlog&userid=' + $scope.user.id;
    var proxy = "http://"+ $scope.local_host +":8080";
    global_server = server;
    global_root = businessRoot;
    global_app = proxy;
    $scope.systReset = function () {
        $scope.curr_modal.show_modal_user('modalResetInput');
    };
    $scope.super = {
        err_msg: '',
        user: '',
        pwd: '',
        is_posting: false,
        post: function(){
            this.err_msg = '';

            if (!this.user) {
                this.err_msg = '用户名不能为空！';
                $('#text-input-user').focus();
                return;
            }

            if (!this.pwd) {
                this.err_msg = '密码不能为空！';
                $('#text-input-pwd').focus();                
                return;
            }

            $.magnificPopup.close();

            if (this.is_posting) {
                return;
            }
            else {
                this.is_posting = true;
            }

            $http({
                method: 'POST', 
                url: '/?a=systReset',
                data: {
                    username: this.user,
                    password: hex_md5(this.pwd)
                }
            })
            .success(function (data) {
                if (data === 'success') {
                    toastr.success('系统重置成功！', '系统重置');
                }
                else {
                    toastr.error('系统重置失败！', '系统重置');
                }
                
                $scope.super.is_posting = false;
            })
            .error(function(){
                toastr.error('系统重置失败！');
                $scope.super.is_posting = false;
            });

            this.pwd = '';
            this.err_msg = '';
        }
    };

    global_cmd_helper = new CabCmdHelper($scope);
    global_deployer = new Deployer($scope);

    $scope.cmd = global_cmd_helper;

    global_lang = Lang;
    $scope.lang = Lang;

    global_http = $http;
    global_interval = $interval;
    global_timeout = $timeout;
    global_modal_helper = new ModalHelper();
    $scope.curr_modal = global_modal_helper;

    global_err_pool = {
        pool: [],
        svrDown: false,
        maxPoolSize: 10,
        add: function (data) {
            if (data == undefined) {
                data = { errMsg: '与服务器通信失败。' };
            }
            this.pool.push(data);
            if (this.pool.length > this.maxPoolSize) {
                //global_task_pool.stopWatch();
                this.svrDown = true;
            }
        }
    };
    $scope.svrErrPool = global_err_pool;
    global_task_pool = new TaskPool();
    $scope.taskPool = global_task_pool;	
		
	// 当用户鼠标经过时，刷新用户空闲状态
	$scope.on_mouse_move = function()
	{
		if ($scope.taskPool.user_left) return;
		
		$scope.taskPool.reset_user_operate_time();
	}
	$scope.on_user_left = function ()
	{
		$scope.user_unlock_msg = '';
		
		locals.set('user_left', 1);
	}

    $scope.updateDeviceStatus = global_cmd_helper.updateDeviceStatus;
    //！！服务器出错标志，慎重使用！！

    $scope.errCodes = {
        ready: false,
        init: function () {
            var that = this;
            $http({
                url: '/Public/js/errcode.json',
                method: 'GET'
            }).success(function (data) {
                that.codes = data;
                that.ready = true;
            }).error(function () {
                global_err_pool.add();
            });
        }
    };

    $scope.initCab = function () {
        global_modal_helper.show_modal({
            type: 'question',
            title: '存储柜在位信息查询',
            html: '您确定提交<span class="bk-fg-primary"> [存储柜在位信息查询] </span>操作？以重新获取在位存储柜的数量和基本信息。',
            on_click_target: global_cmd_helper,
            on_click_handle: "cabinfo"
        });
    }

    function on_cab_select(cab) {
        $scope.cab = cab;
    }
    
    global_cabinet_helper = new CabinetHelper(on_cab_select);
    $scope.cabs = global_cabinet_helper;
	
    $scope.deployer = global_deployer;
    $scope.start = function () {
        $scope.errCodes.init();
        //read cab information
        $scope.cabs.on_init();
        global_ws_watcher = $scope.wsWatcher.connect(1,1);
    }
    $scope.start();
    $scope.getCabInfo = function () {
        //read cab info from database
        $http({
            url: '/index.php?m=admin&c=business&a=getCabInfo',
            method: 'GET'
        }).success(function (data) {
            if (!data['err_msg']) {
                $scope.cabs.i_on_init(data);
            }
        });
    }
    $scope.deploy = function (cab,type,cab_name) {
        var title='一键部署';
        switch (type){
            case 'diskinfo':
                title = '当前柜磁盘信息查询';
                break;
            case 'filetree':
                title = '当前柜磁盘文件目录查询';
                break;
        }
        global_modal_helper.show_modal({
            type: 'question',
            title: title,
            html: '您确定提交<span class="bk-fg-primary"> [存储柜 ' + cab + '#] </span>的<span class="bk-fg-primary"> ['+title+'] </span>命令？',
            on_click_handle: function (cab_id) {
                if (!global_deployer.available()) {
                    return;
                }
                global_deployer.on_init(cab,cab_name);
                global_deployer.startDeploy(type);
            },
            on_click_param: cab
        });
    }
    $scope.stopDeploy = function (cab) {
        var title='一键部署';
        switch (global_deployer.type){
            case 'diskinfo':
                title = '当前柜磁盘信息查询';
                break;
            case 'filetree':
                title = '当前柜磁盘文件目录查询';
                break;

        }
        global_modal_helper.show_modal({
            type: 'question',
            title: title,
            html: '您确定停止<span class="bk-fg-primary"> [存储柜 ' + cab + '#] </span>的<span class="bk-fg-primary"> ['+title+'] </span>命令？',
            on_click_handle: function () {
              
                global_deployer.stopDeploy();
            },
            on_click_param:cab
        });
    }
    $scope.testWs = function () {
        var msg = this.testMsg.i_getMsg(this.testCmdId);
        global_ws_watcher.sendcmd("1",msg.md5);
    }
    $scope.getDiskInfo = function (cab, lvl, grp, dsk) {
        //read cab info from database
        $http({
            url: '/index.php?m=admin&c=business&a=getDiskInfo',
            data: {cab: cab, level: lvl, group: grp, disk: dsk},
            method: 'POST'
        }).success(function (data) {
            if (!data['err_msg'] && data.length > 0) {
                $scope.cab.i_load_disk(data[0]);
            }
            else {
                console.log(data['err_msg']);
            }
        });
    }
    
    /*------------------用户日志--------------------*/
    $scope.user_log_loading = false;
    $scope.log_date_selected = function(d)
    {
        $scope.user_logs = [];
        if (d == null) return;

        $scope.user_log_loading = true;
        $http({
            url: '/?a=getlog',
            method: 'get',
            params: {
                date: d.text,
                userid: global_user.id
            }
        })
        .then(function(payload) {
            $scope.user_log_loading = false;           
            if (payload.status != 200) return;
                
            $scope.user_logs = payload.data;
        });
    }
    $scope.show_disk_detail = function(id)
    {
        var prom = $http({
            url: '/',
            method: 'get',
            params: {
                a: 'getdisksmartbyid',
                id: id
            }
        });
        prom.then(function(payload){
            if (payload.status != 200) return;

            $scope.cab.curr.smarts = payload.data;
        });

        $scope.curr_modal.show_modal_user('modalDiskDetailView');
    };
    $http({
            url:'/?a=getlogdates',
            method:'get'
    })
    .then(function(payload){
        if (payload.status != 200) return;

        $scope.log_months = payload.data;
    });

    $scope.reload_user_log = function () {
        console.log('obsolete function reload_user_log, user log_date_selected'); return;
        if ($scope.user_log_loading) return;

        $scope.user_log_loading = true;
        $http({
            url: '/index.php',
            method: 'get',
            params: {
                m: 'admin',
                c: 'business',
                a: 'getLogByUserId',
                userid: global_user.id
            }
        }).success(function (data) {
            if (!data) {
                $scope.user_log_loading = false;
                return;
            }

            try {
                $scope.user_logs = data;
            }
            catch (e) {

            }
            finally {
                $timeout(function () {
                    $scope.user_log_loading = false;
                }, 100);
            }
        }).error(function () {
            $scope.user_log_loading = false;
        });
    }

    $scope.reload_user_log();
	
})  
.filter('DISK_HEALTH', function(){
    return function(health) {
        switch(health) {
        case '0' : return '未知';
        case '1' : return '健康';
        case '2' : return '告警';
        case '3' : return '损坏';
        default: return '未知';
        }
    };
})
.filter('SMART_NAME', function(){
    return function(id) {        
        var ID = parseInt(id, 16);
        var str =  "未知属性" ;
    
        switch (ID)
        {
        case 0x01:
            str =  "(底层)数据读取错误率" ;
            break;
        case 0x02:
            str =  "吞吐性能(读写通量性能)" ;
            break;
        case 0x03:
            str =  "马达旋转到标准转速所需时间" ;
            break;
        case 0x04:
            str =  "马达启动/停止转速" ;
            break;
        case 0x05:
            str =  "重映射扇区计数" ;
            break;
        case 0x06:
            str =  "读取通道边界" ;
            break;
        case 0x07:
            str =  "寻道错误率" ;
            break;
        case 0x08:
            str =  "寻道时间性能" ;
            break;
        case 0x09:
            str =  "累计通电时间计数" ;
            break;
        case 0x0a:
            str =  "马达重试计数" ;
            break;
        case 0x0b:
            str =  "校准重试计数" ;
            break;
        case 0x0c:
            str =  "通电周期计数" ;
            break;
        case 0x0d:
            str =  "软件读出误码率" ;
            break;
        case 0xb7:
            str =  "SATA降档错误计数" ;
            break;
        case 0xb8:
            str =  "端到端错误" ;
            break;
        case 0xb9:
            str =  "头稳定性" ;
            break;
        case 0xba:
            str =  "感应运算振动检测" ;
            break;
        case 0xbb:
            str =  "反馈无法校正的错误" ;
            break;
        case 0xbc:
            str =  "指令超时" ;
            break;
        case 0xbd:
            str =  "高飞写入" ;
            break;
        case 0xbe:
            str =  "气流温度" ;
            break;
        case 0xbf:
            str =  "震动侦测错误率" ;
            break;
        case 0xc0:
            str =  "断电磁头缩回计数" ;
            break; 
        case 0xc1:
            str =  "磁头伸出周期计数" ;
            break;
        case 0xc2:
            str =  "温度" ;
            break;
        case 0xc3:
            str =  "硬件ECC校正" ;
            break;
        case 0xc4:
            str =  "重新分配事件计数" ;
            break;
        case 0xc5:
            str =  "目前待映射扇区数" ;
            break;
        case 0xc6:
            str =  "无法校正扇区数" ;
            break;
        case 0xc7:
            str =  "Ultra DMA CRC 错误计数" ;
            break;
        case 0xc8:
            str =  "多区域错误率" ;
            break;
        case 0xc9:
            str =  "软读出误码率" ;
            break;
        case 0xca:
            str =  "数据地址标记错误" ;
            break;
        case 0xcb:
            str =  "ECC错误发生率" ;
            break;
        case 0xcc:
            str =  "软件ECC校正" ;
            break;
        case 0xcd:
            str =  "过温率" ;
            break;
        case 0xce:
            str =  "飞行高度" ;
            break;
        case 0xcf:
            str =  "旋上高电流" ;
            break;
        case 0xd0:
            str =  "电力不足马达重试计数" ;
            break;
        case 0xd1:
            str =  "离线寻轨性能" ;
            break;
        case 0xd3:
            str =  "写入时震动" ;
            break;
        case 0xd4:
            str =  "写入时受冲击" ;
            break;
        case 0xdc:
            str =  "磁盘移位" ;
            break;
        case 0xdd:
            str =  "震动侦测错误率" ;
            break;
        case 0xde:
            str =  "作业时间" ;
            break;
        case 0xdf:
            str =  "磁头升降重试次数" ;
            break;
        case 0xe0:
            str =  "加载摩擦" ;
            break;
        case 0xe1:
            str =  "磁头升降周期计数" ;
            break;
        case 0xe2:
            str =  "载入时间" ;
            break;
        case 0xe3:
            str =  "扭矩放大计数" ;
            break;
        case 0xe4:
            str =  "断电磁头缩回周期" ;
            break;
        case 0xe6:
            str =  "巨磁电阻头振幅" ;
            break;
        case 0xe7:
          str =  "温度" ;
            break;
        case 0xf0:
            str =  "磁头飞行小时" ;
            break;
        case 0xf1:
            str =  "总 LBAs 写入" ;
            break;
        case 0xf2:
            str =  "总LBAs 读取" ;
            break;
        case 0xfa:
            str =  "读取错误重试率" ;
            break;
        case 0xfe:
            str =  "自由落体保护" ;
            break;
        default:
            break;
        }

        return str;
    };    
})
.factory('locals', ['$window', function($window){
	return {        //存储单个属性
		set : function(key,value){
			$window.localStorage[key]=value;
		},        //读取单个属性
		get : function(key,defaultValue){
			return  $window.localStorage[key] || defaultValue;
		},        //存储对象，以JSON格式存储
		setObject : function(key,value){
			$window.localStorage[key]=JSON.stringify(value);
		},        //读取对象
		getObject : function (key) {
			return JSON.parse($window.localStorage[key] || '{}');
		}

	}
}])
    .controller('testCtrl', function ($scope, TestMsg) {
var Test = function () {
    this.server = '/index.php?m=admin&c=msg';
}

});

