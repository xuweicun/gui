app_device.controller('InitCtrl', function ($scope, DTOptionsBuilder, DTDefaultOptions) {
    var vm = this;
    vm.dtOptions = DTOptionsBuilder.newOptions().withPaginationType('full_numbers');
    DTDefaultOptions.setLanguage({
        "sProcessing": "处理中...",
        "sLengthMenu": "每页显示 _MENU_ 条命令",
        "sZeroRecords": "没有匹配的命令",
        "sInfo": "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
        "sInfoEmpty": "显示第 0 至 0 项结果，共 0 项",
        "sInfoFiltered": "(由 _MAX_ 项结果过滤)",
        "sInfoPostFix": "",
        "sUrl": "",
        "sEmptyTable": "当前没有执行中的命令",
        "sLoadingRecords": "载入中...",
        "sInfoThousands": ",",
        "oPaginate": {
            "sFirst": "首页",
            "sPrevious": "上页",
            "sNext": "下页",
            "sLast": "末页"
        },
        "oAria": {
            "sSortAscending": ": 以升序排列此列",
            "sSortDescending": ": 以降序排列此列"
        }
    });
});
