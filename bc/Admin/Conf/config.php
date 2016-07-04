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
        'URL_MODEL'=>0,
	    'AUTO_PROTECT_ON'=>1,
	'PLAN_STATUS_WAITING'=>-1,
	'PLAN_STATUS_WORKING'=>0,
	'PLAN_STATUS_SUCCESS'=>1,
	'PLAN_STATUS_SKIPPED'=>2
);
return array_merge($dbconfig,$config);