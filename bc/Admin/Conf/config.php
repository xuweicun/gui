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
	    'SUB_STATUS_WORK'=>2,
		'TMPL_L_DELIM'=>'<{',
		'TMPL_R_DELIM'=>'}>'
);
return array_merge($dbconfig,$config);