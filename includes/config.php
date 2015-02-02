<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2014
 */

date_default_timezone_set('Asia/Kuala_lumpur');
error_reporting(E_ALL ^ E_NOTICE);
 
 
define("HOST","localhost");
define("USER","root");
define("PASSWORD","");
define("DATABASE","uniteninfo");
 
//normal
//$link = mysqli_connect(HOST)
$mysqli = new mysqli(HOST, USER, PASSWORD, DATABASE);

/* check connection */
if (mysqli_connect_errno()) {
    printf("Connect failed: %s\n", mysqli_connect_error());
    exit();
}


 
 ?>