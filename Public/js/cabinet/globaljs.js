
register_filters(app_device);
app_device.filter('to_trusted', function ($sce) {
    return function (text) {
        return $sce.trustAsHtml(text);
    }
}).controller('statusMonitor', function ($scope, $http, $interval, $timeout, $location, locals, Lang, TestMsg, WebSock, DTOptionsBuilder, DTDefaultOptions)
{	
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
    $scope.role = global_user.can_write == 1 ? '高级' : '只读';	
	
	// 如果已经离开，则需要重新登录
	var has_left = locals.get('user_left', 0);
	if (has_left == 1) {
		locals.set('user_left', 0);
		$scope.user_profile.go_logout_page(true);
		return;
	}
	
	$scope.user_unlock = function()
	{	
		$http({
            url: "/index.php?m=admin&c=business&a=passwordValidate",
            method: 'POST',
            data: {
                id: global_user.id,
                password: hex_md5($scope.user_unlock_pwd)
            }
        }).success(function (data) {
            //响应成功
            try {
                var rlt = JSON.parse(data);
                if (rlt.status == 'success') {
					$scope.taskPool.reset_user_operate_time();
                    $scope.user_unlock_msg = '';
                }
                else {
                    $scope.user_unlock_msg = '密码验证失败';
                }
            } catch (err) {
            }
            finally {
            }
        });
		
		$scope.user_unlock_pwd = '';
	}
	
    ($scope.init_date_picker = function () {
        $.fn.datepicker.defaults.format = 'yyyy-mm-dd';
        $("[data-plugin-datepicker]").datepicker();
    })();
        
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
        $http({method: 'GET', url: '/index.php?m=admin&c=business&a=systReset'}).success(function (data) {
            alert('系统重置成功！');
        });
    }
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
    $scope.deploy = function (cab) {
        global_modal_helper.show_modal({
            type: 'question',
            title: '当前柜磁盘信息查询',
            html: '您确定提交<span class="bk-fg-primary"> [存储柜 ' + cab + '#] </span>的<span class="bk-fg-primary"> [磁盘信息查询] </span>命令？',
            on_click_handle: function (cab_id) {
                if (!global_deployer.available()) {
                    return;
                }
                global_deployer.on_init(cab);
                global_deployer.startDeploy();
            },
            on_click_param: cab
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
            if (!data['err_msg']) {
                $scope.cab.i_load_disks_base_info(data);
            }
            else {
                console.log(data['err_msg']);
            }
        });
    }
    
    /*------------------用户日志--------------------*/
    $scope.user_log_loading = false;
    $scope.reload_user_log = function () {
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

