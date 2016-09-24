<?php
$dbconfig    =    require 'db.inc.php';
$config = array(
	'TOKEN_ON' => true,
		'CMD_SUCCESS'=> 0,
		'CMD_CANCELED'=> -2,
		'CMD_GOING'=>-1,
		'CMD_TIMEOUT'=>-3,
	    'SUB_STATUS_SUCCESS'=>0,
	    'SUB_STATUS_START'=>1,
	    'SUB_STATUS_WORKING'=>2,
	    'BRG_DIR_ROOT' => "/home/share/mount/",
		'TMPL_L_DELIM'=>'<{',
		'TMPL_R_DELIM'=>'}>',
	    'AUTO_PROTECT_ON'=>1,
	'PLAN_STATUS_WAITING'=>-1,
	'PLAN_STATUS_WORKING'=>0,
	'PLAN_STATUS_SUCCESS'=>1,
	'PLAN_STATUS_SKIPPED'=>2,
	'PLAN_STATUS_CANCELED'=>3,
		'SYSTEM_USER_ID'=>0,
        'ERR_CODE_OK'=>'2',
        'URL_ROUTER_ON'=>true,
        'URL_ROUTE_RULES' => array(
            ':item_table/maxid$'        =>  array('lang/link/maxid', '', array('method'=>'get')),
            ':item_table/size$'     =>  array('lang/link/size', '', array('method'=>'get')),
            ':item_table/:id\d$'        =>  array('lang/link/item'),
            ':item_table/toid/:id\d/size/:size\d$'          =>  array('lang/link/items', '', array('method'=>'get')),
            ':item_table/list$'         =>  array('lang/link/items'),
            ':item_table/list/from/:id\d$'         =>  array('lang/link/items'),
            ':item_table/where/:where$'         =>  array('lang/link/where')
        )
);
return array_merge($dbconfig,$config);
