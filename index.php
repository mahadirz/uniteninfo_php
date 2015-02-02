<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 */
session_start();
include_once "includes/config.php";

 
$input_url = filter_input(INPUT_GET, 'id', FILTER_SANITIZE_SPECIAL_CHARS);
$in = str_split($input_url);
if($in[strlen($input_url)-1] == "/"){
    $redirect = rtrim("https://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'],"/");
    header("Location: $redirect");
    exit;
}

if(!isset($_SERVER['HTTPS']) || $_SERVER['HTTPS'] == ""){
    $redirect = "https://".$_SERVER['HTTP_HOST'].$_SERVER['REQUEST_URI'];
    header("Location: $redirect");
    exit;
}

define("SECURITY_ACCESS",true);
require 'libs/Smarty.class.php';
include_once "includes/PasswordHasher.php";
include_once "includes/encryptions.php";
include_once "includes/NTLM_parser.php";
include_once "includes/parserEngine.php";
include_once "includes/Utilities.php";





$explode_url = explode("/",$input_url);

$smarty = new Smarty;
$smarty->debugging = false;
$smarty->caching = false;

//echo "<pre>";
//print_r($explode_url);
//echo "</pre>";



//to check the query words
//top level, without auth
if($explode_url[0] == "authenticator"){
    include_once("includes/authenticator.php");
    exit;
}
else if($explode_url[0] == "subject-updater"){
    include_once("includes/subject-updater.php");
    exit;
}
//with auth
else if($explode_url[0] == "" || !isset($_SESSION['sessionStudentId']) 
|| empty($_SESSION['sessionStudentId']) || !isset($_COOKIE['encrypted_pass']) 
|| !isset($_COOKIE['student_id']) || $_COOKIE['student_id'] != $_SESSION['sessionStudentId'] ){
    session_destroy();
    include_once("includes/login.php");
    exit;
}
else if($explode_url[0] == "home"){
    include_once("includes/students/dashboard.php");
    exit;
}
else if($explode_url[0] == "login"){
    include_once("includes/login.php");
    exit;
}
else if($explode_url[0] == ""){
        session_destroy();
        header("location: login");
        exit;
}

else if($explode_url[0] == "logout"){
        session_destroy();
        header("location: login");
        exit;
}
else if($explode_url[0] == "subject"){
    include_once("includes/students/subjects.php");
    exit;
}
else if($explode_url[0] == "scorun"){
    include_once("includes/students/scorun.php");
    exit;
}



header("HTTP/1.0 404 Not Found");
$smarty->display('error.tpl');
 


?>