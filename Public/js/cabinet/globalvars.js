var app = angular.module('device', ['device.controllers', 'device.services']);
var app_device = angular.module('device.controllers', ['datatables']);

// 以下全局变量在globaljs.js中初始化
var global_scope;
var global_user;
var global_cmd_helper;
var global_cabinet;
var global_cabinet_helper;
var global_err_pool;
var global_task_pool;
var global_http;
var global_interval;
var global_timeout;
var global_lang;
var global_server;
var global_app;
var global_root;
var global_deployer;
var global_ws_watcher;
var global_modal_helper;