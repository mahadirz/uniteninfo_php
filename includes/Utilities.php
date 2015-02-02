<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 * @version 23/1/2015 : 16:28
 */

function getPasswordFromCookie(){
/**** procedure to use decrypt cookie in browser ***/
$password =  Decrypt($_COOKIE['encrypted_pass'],$_SESSION['sessionToken']);
//check if password is same with hash
if(!validate_password($password,$_SESSION['passhash'])){
//password invalid
header("location:logout");
exit;
}
return $password;
}


function getUserIdFromStudentId($studentId,$mysqli){
    //retrieve user_id
    $sql = sprintf("SELECT `user_id` FROM `users` WHERE `studentId`='%s'",$studentId);
    $result = $mysqli->query($sql);
    if(!$result)
        die("error: ".$mysqli->error);
    $user_id= $result->fetch_object();
    $user_id = $user_id->user_id;
    return $user_id;
}

function debug_pre($text){
    echo "<pre>";
    print_r($text);
    echo "</pre>";
}

function echo_html($text){
    echo "$text<br>";
}



?>