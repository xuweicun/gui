app_device.filter('to_trusted', function ($sce) {
    return function (text) {
        return $sce.trustAsHtml(text);
    }
}).controller('statusMonitor', function ($scope, $http, $interval, $timeout, $location, Lang, TestMsg, WebSock, DTOptionsBuilder, DTDefaultOptions) {

    var businessRoot = '/index.php?m=admin&c=business';
    $scope.bridgeUrl = '/Public/js/bridge.html';
    $scope.goingTaskUrl = '/bc/Admin/View/Business/goingTask.html';
    $scope.doneTaskUrl = '/bc/Admin/View/Business/doneTask.html';
    $scope.siderBarUrl = '/bc/Admin/View/Business/siderBar.html';
    $scope.cabUrl = '/bc/Admin/View/Business/cabs.html';
    $scope.modalHelperUrl = '/bc/Admin/View/Business/modalhelper.html';
    $scope.cabinetViewUrl = '/bc/Admin/View/Business/cabinetView.html';
    $scope.diskViewUrl = '/bc/Admin/View/Business/diskView.html';
    $scope.userModalsUrl = '/bc/Admin/View/Business/userModals.html';
    $scope.local_host = $location.host();
    //服务器错误信息池，格式[{errMsg:'err'},{errMsg:'err'}]
    $scope.user = $("#userid").val();
    $scope.testMsg = TestMsg;
    $scope.wsWatcher = WebSock;
    $scope.testCmdId = 0;
    $scope.to_post = null;
    var server = businessRoot + '&a=addcmdlog&userid=' + $scope.user;
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
    $scope.deploy = function(cab){
        if(!global_deployer.available()){
            return;
        }
        global_deployer.on_init(cab);
        global_deployer.startDeploy();
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
})
    
    .controller('testCtrl', function ($scope, TestMsg) {
var Test = function () {
    this.server = '/index.php?m=admin&c=msg';
}

});
