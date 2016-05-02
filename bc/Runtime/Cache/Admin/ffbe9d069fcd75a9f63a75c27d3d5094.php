<?php if (!defined('THINK_PATH')) exit();?>﻿<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>文件列表</title>

    <!-- Vendor CSS-->
    <link href="/Public/assets/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" />
    <link href="/Public/assets/vendor/skycons/css/skycons.css" rel="stylesheet" />
    <link href="/Public/assets/vendor/font-awesome/css/font-awesome.min.css" rel="stylesheet" />
    <link href="/Public/assets/vendor/css/pace.preloader.css" rel="stylesheet" />

    <!-- Plugins CSS-->
    <link href="/Public/assets/plugins/bootkit/css/bootkit.css" rel="stylesheet" />
    <link href="/Public/assets/plugins/select2/select2.css" rel="stylesheet" />
    <link href="/Public/assets/plugins/jquery-datatables-bs3/css/datatables.css" rel="stylesheet" />

    <!-- Theme CSS -->
    <link href="/Public/assets/css/jquery.mmenu.css" rel="stylesheet" />

    <!-- Page CSS -->
    <link href="/Public/assets/css/style.css" rel="stylesheet" />
    <link href="/Public/assets/css/add-ons.min.css" rel="stylesheet" />

    <style>
        a {
            color: #777 !important;
        }
    </style>

</head>
<body>
    <div class="panel panel-primary">
        <div class="panel-heading">
            <h6><i class="fa fa-table red"></i><span class="break"></span>文件列表</h6>
            <input style="display:none;" id="diskinfo" value="<?php echo ($disk); ?>">
        </div>
        <div class="panel-body">
            <div>
                <ol class="breadcrumb" id="navBar">
                    <li>
                        <button class="btn btn-link btn-xs" type="button" id="btnUp">
                            <i class="fa  fa-arrow-up"></i>
                        </button>
                    </li>
                </ol>
            </div>
            <table class="table table-bordered table-striped" id="datatable-my">
                <thead>
                    <tr>
                        <th>名称</th>
                        <th>修改日期</th>
                        <th>类型</th>
                        <th>大小</th>
                        <th>dir</th>
                    </tr>
                </thead>
                <tbody></tbody>
            </table>
        </div>
    </div>
</body>


<script src="/Public/assets/vendor/js/jquery-2.1.1.min.js"></script>
<script src="/Public/assets/vendor/bootstrap/js/bootstrap.min.js"></script>

<!-- Plugins JS-->
<script src="/Public/assets/plugins/select2/select2.js"></script>
<script src="/Public/assets/plugins/jquery-datatables/media/js/jquery.dataTables.js"></script>
<script src="/Public/assets/plugins/jquery-datatables/extras/TableTools/js/dataTables.tableTools.min.js"></script>
<script src="/Public/assets/plugins/jquery-datatables-bs3/js/datatables.js"></script>


<script>
    // Data Tables - Config
    (function($) {

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
                fnInitComplete: function( settings, json ) {
                    // select 2
                    if ( $.isFunction( $.fn[ 'select2' ] ) ) {
                        $('.dataTables_length select', settings.nTableWrapper).select2({
                            minimumResultsForSearch: -1
                        });
                    }

                    var options = $( 'table', settings.nTableWrapper ).data( 'plugin-options' ) || {};

                    // search
                    var $search = $('.dataTables_filter input', settings.nTableWrapper);

                    $search
                            .attr({
                                placeholder: typeof options.searchPlaceholder !== 'undefined' ? options.searchPlaceholder : '查找'
                            })
                            .addClass('form-control');

                    if ( $.isFunction( $.fn.placeholder ) ) {
                        $search.placeholder();
                    }
                }
            });

        }

    }).apply( this, [ jQuery ]);

    /*Datatable - my*/
    (function( $ ) {

        'use strict';

        function getFileTree(xmlDirPath){
            $.get(xmlDirPath + '/items.xml', function(result){
                $('#datatable-my').DataTable().clear();

                $(result).find('items').find('i').each(function(index, ele){
                    //console.log($(ele).attr('text'));
                    var isDir = $(ele).attr('type') == 'd';
                    var col = '<td></td>';
                    var tr = $('<tr></tr>');
                    if(isDir){
                        var dir = xmlDirPath + '/' + $(ele).attr('dir');
                        var a = $('<a></a>')
                                .attr('data-dir', dir)
                                .attr('href', '#')
                                .text($(ele).attr('text'));
                        tr.append($(col).append(a));
                    }
                    else{
                        tr.append($(col).text($(ele).attr('text')));
                    }

                    tr
                        .append($(col).text($(ele).attr('time')))
                        .append($(col).text(isDir?'文件夹':'文件'))
                        .append($(col).text(isDir?'-': ($(ele).attr('size') + ' kb')));

                    $('#datatable-my').append(tr);
                });
                $(datatableInit());
            });
        }

        var datatableInit = function() {
            $('#datatable-my').dataTable();
        };

        var disk = $("#diskinfo").val();//'1_1_1';//初始化一下
        var table;

        $(function() {
            $("#datatable-my")
                    .on("click", "a", function(e){
                        e.preventDefault();

                        var text = $(this).attr('data-text');
                        var dir = $(this).attr('data-dir');
                        var path = table.path + '/' + dir;

                        var a = $("<a><i class='fa fa-folder'></i> </a>")
                                .attr('href', '#')
                                .attr('data-path', path)
                                .append(text);
                        $('#navBar').append($('<li></li>').append(a));

                        table.ajax.url(path + "/items.json").load().order();
                        table.path = path;
                    });

            $('#navBar')
                    .on("click", "a", function(e){
                        e.preventDefault();

                        table.path =  $(this).attr('data-path');
                        table.ajax.url(table.path + '/items.json').load().order();

                        $(this).parent('li').nextAll().remove();
                    });

            $('#btnUp').click(function(){
                var items = $('#navBar > li > a');
                if(items.length <= 1){
                    return;
                }

                items[items.length-2].click();
            });
            
            var url = "xml/" + disk;

            function loadTable() {
                table = $('#datatable-my').DataTable({
                    "jQueryUI": true,
                    "searching": true,//关闭搜索框
                    responsive: true,
                    "processing": true,//是否显示处理状态(排序的时候，数据很多耗费时间长的话，也会显示这个)
                    //多语言配置
                    ajax: url + "/" + "items.json",
                    "order": [[3, "asc"], [0, 'asc']],
                    columns: [
                        { "data": "text" },
                        { "data": "time" },
                        { "data": "type" },
                        { "data": "size" },
                        { "data": "dir" }
                    ],
                    "columnDefs": [
                        {
                            "render": function (data, type, row) {
                                if (row['type'] == 'd') {
                                    return "<a href='#' data-dir='" + row['dir'] + "' data-text='" + row['text'] + "'><i class='fa fa-folder'></i> " + data + '</a>';
                                }
                                else {
                                    return "<i class='fa fa-file'></i> " + data;
                                }
                            },
                            "targets": 0
                        },
                        {
                            "render": function (data, type, row) {
                                if (data == 'd') {
                                    return "文件夹";
                                }
                                else {
                                    return '文件';
                                }
                            },
                            "orderData": [3, 0],
                            "targets": 2
                        },
                        {
                            "render": function (data, type, row) {
                                if (data.length == 0) {
                                    return "";
                                }
                                else {
                                    return data + ' kb';
                                }
                            },
                            "targets": 3
                        },
                        {
                            "visible": false,
                            "targets": 4
                        }
                    ],
                    "oLanguage": {
                        "sLengthMenu": "_MENU_ 条/页",
                        "sZeroRecords": "数据为空",
                        "sInfo": "[_START_ - _END_] in _TOTAL_",
                        "sInfoEmpty": "[0-0] in 0",
                        "sInfoFiltered": "(从 _MAX_ 条数据中检索)"
                    }
                });
                table.path = url;

                var a = $("<a><i class='fa fa-folder'></i> </a>")
                        .attr('href', '#')
                        .attr('data-path', table.path)
                        .append(disk);
                $('#navBar').append($('<li></li>').append(a));
            }

            $.get(url + '/items.json', function (result, status) {
                if (status == 'success') {
                    loadTable();
                }
            });
            
            //getFileTree('xml/1_1_1');
            
        });

    }).apply( this, [ jQuery ]);
</script>
</html>