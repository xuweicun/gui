app_device.controller('DeployCtrl', function ($scope, $http, $interval, $timeout, Lang, TestMsg, DTOptionsBuilder, DTDefaultOptions) {

    var businessRoot = '/index.php?m=admin&c=business';

    $scope.siderBarUrl = '/bc/Admin/View/Business/siderBar.html';
    $scope.cabUrl = '/bc/Admin/View/Business/cabs.html';
    //服务器错误信息池，格式[{errMsg:'err'},{errMsg:'err'}]
    $scope.user = $("#userid").val();
    $scope.testMsg = TestMsg;
    $scope.testCmdId = 0;
    var server = businessRoot + '&a=addcmdlog&userid=' + $scope.user;
    var proxy = "http://localhost:8080";
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
        global_cmd_helper.cabinfo();
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
    }
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
    $scope.start();
});
