
// Data Tables - Config
(function ($) {

    'use strict';

    // we overwrite initialize of all datatables here
    // because we want to use select2, give search input a bootstrap look
    // keep in mind if you overwrite this fnInitComplete somewhere,
    // you should run the code inside this function to keep functionality.
    //
    // there's no better way to do this at this time :(
    if ($.isFunction($.fn['dataTable'])) {

        $.extend(true, $.fn.dataTable.defaults, {
            sDom: "<'row datatables-header form-inline'<'col-sm-12 col-md-6'l><'col-sm-12 col-md-6'f>r><'table-responsive't><'row datatables-footer'<'col-sm-12 col-md-6'i><'col-sm-12 col-md-6'p>>",
            oLanguage: {
                sLengthMenu: '_MENU_ records per page',
                sProcessing: '<i class="fa fa-spinner fa-spin"></i> Loading'
            },
            fnInitComplete: function (settings, json) {
                // select 2
                if ($.isFunction($.fn['select2'])) {
                    $('.dataTables_length select', settings.nTableWrapper).select2({
                        minimumResultsForSearch: -1
                    });
                }

                var options = $('table', settings.nTableWrapper).data('plugin-options') || {};

                // search
                var $search = $('.dataTables_filter input', settings.nTableWrapper);

                $search
					.attr({
					    placeholder: typeof options.searchPlaceholder !== 'undefined' ? options.searchPlaceholder : '搜索'
					})
					.addClass('form-control');

                if ($.isFunction($.fn.placeholder)) {
                    $search.placeholder();
                }
            }
        });

    }

}).apply(this, [jQuery]);


/*Datatable - default*/
(function ($) {

    'use strict';

    var datatableInit = function () {

        $('#datatable-default').dataTable({
            language: {
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
            }
        });

        $('#table-done-tasks').dataTable({
            language: {
                "sProcessing": "处理中...",
                "sLengthMenu": "每页显示 _MENU_ 条命令",
                "sZeroRecords": "没有匹配的命令",
                "sInfo": "显示第 _START_ 至 _END_ 项结果，共 _TOTAL_ 项",
                "sInfoEmpty": "显示第 0 至 0 项结果，共 0 项",
                "sInfoFiltered": "(由 _MAX_ 项结果过滤)",
                "sInfoPostFix": "",
                "sUrl": "",
                "sEmptyTable": "当前没有已完成的命令",
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
            }
        });
    };

    $(function () {
        datatableInit();
    });

}).apply(this, [jQuery]);