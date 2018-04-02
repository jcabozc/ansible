<?php
    return array(
        'db_write' => array(
            'class' => 'CDbConnection',
            'connectionString' => 'mysql:host=10.80.7.120; dbname=meshare;port=3306',
            'username' => 'root',
            'password' => '123456',
            'charset' => 'utf8',
            'persistent' => true,
	    'tablePrefix' => '',
            'schemaCachingDuration' => 0,
        ),
        'db_read' => array(
            'class' => 'CDbConnection',
            'connectionString' => 'mysql:host=10.80.7.120; dbname=meshare;port=3306',
            'username' => 'root',
            'password' => '123456',
            'charset' => 'utf8',
            'persistent' => true,
	    'tablePrefix' => '',
            'schemaCachingDuration' => 0,
        ),
        
    	// 本idc的mongodb地址
	'mongodb' => array (
		'class' => 'CDbMongo',
		'connectionString' => 'mongodb://10.80.7.142:27017',
		'dbName' => 'meshare' 
		),
    	// 云存储专用mongodb地址
    	'mongodb_rcd' => array (
    		'class' => 'CDbMongo',
    		'connectionString' => 'mongodb://10.80.7.145:27017',
    		'dbName' => 'meshare'
    	)
    );
?>

