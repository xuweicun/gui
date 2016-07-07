app_device.controller('InitCtrl', function ($scope, DTOptionsBuilder, DTDefaultOptions, DTColumnDefBuilder) {
    
    $scope.dtOptions = DTOptionsBuilder.newOptions().withPaginationType('full_numbers');
    DTDefaultOptions.setLanguage({
        "sProcessing": "加载中...",
        "sLengthMenu": "每页显示 _MENU_ 条",
        "sZeroRecords": "没有匹配的记录",
        "sInfo": "显示第 _START_ 至 _END_ 项记录，共 _TOTAL_ 项",
        "sInfoEmpty": "显示第 0 至 0 项记录，共 0 项",
        "sInfoFiltered": "(由 _MAX_ 项记录过滤)",
        "sInfoPostFix": "",
        "sUrl": "",
        "sEmptyTable": "当前没有找到记录",
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
        },
        "sSearch": '查找:'
    });
    $scope.dtColumnDefs = [
        DTColumnDefBuilder.newColumnDef(0).notSortable(),
        DTColumnDefBuilder.newColumnDef(1),
        DTColumnDefBuilder.newColumnDef(2),
        DTColumnDefBuilder.newColumnDef(3),
        DTColumnDefBuilder.newColumnDef(4),
        DTColumnDefBuilder.newColumnDef(5),
        DTColumnDefBuilder.newColumnDef(6)
    ];
});
