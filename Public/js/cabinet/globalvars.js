var app = angular.module('device', ['device.controllers', 'device.services']);
var app_device = angular.module('device.controllers', ['datatables']);
var global_cmd_helper;
var global_cabinet;

function link_send_cmd(json_cmd) {
    global_cmd_helper.sendcmd(json_cmd);
}
