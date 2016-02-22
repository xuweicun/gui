<?php
$dbconfig    =    require 'db.inc.php';
$config = array(
	'TOKEN_ON' => true
);
return array_merge($dbconfig,$config);