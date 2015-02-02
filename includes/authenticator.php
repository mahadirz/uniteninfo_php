<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 * @version 18/1/2015 : 21:37
 */


include_once "config.php";
include_once "PasswordHasher.php";
include_once "NTLM_parser.php";
include_once "parserEngine.php";
include_once "encryptions.php";



//Authenticator AJAX handler


//only method is allowed
if($_SERVER['REQUEST_METHOD'] != 'POST' || empty($_POST['studentId']) || empty($_POST['password'])){
    $json = array("authenticated"=>false,"sessionId"=>null,"debug"=>"method or data error");
    header('Content-type: application/json');
    die(json_encode($json));
}

$id = $mysqli->real_escape_string($_POST['studentId']);
$password = $mysqli->real_escape_string($_POST['password']);


//first check inside local database if password is same
$query = sprintf("SELECT * FROM `users` WHERE `studentId` ='%s' ",$id);
$result = $mysqli->query($query);

if(!$result){
    $json = array("authenticated"=>false,"sessionId"=>null,"debug"=>$mysqli->error);
    header('Content-type: application/json');
    die(json_encode($json));
}

$ObjectFromDB = $result->fetch_object();

if($result->num_rows > 0){
    $is_user_exist_local = true;
}
else{
    $is_user_exist_local = false;
}
 


//check with password
if(validate_password($password,$ObjectFromDB->passhash)==true){
    //generate cryptographically secure tokens, use as password encryption
    $rand_token = bin2hex(openssl_random_pseudo_bytes(16, $cstrong));
    //save session
    $_SESSION['passhash'] = $ObjectFromDB->passhash;
    $_SESSION['sessionToken'] = $rand_token;
    $_SESSION['sessionStudentId'] = $id;
    $enc = Encrypt($password,$rand_token);
    $json = array("authenticated"=>true,"encrypted_pass"=>$enc,"debug"=>null);
    header('Content-type: application/json');
    die(json_encode($json));    
}
else{
    //fetch uniten info
    $raw_biodata = parseUnitenInfo("http://info.uniten.edu.my/info/Ticketing.asp?WCI=Biodata",$id,$password);
    $biodata = parseBiodata($raw_biodata);
    

    
    if($biodata["name"]==""){
        $json = array("authenticated"=>false,"sessionToken"=>null,"debug"=>"id/password error from remote server");
        header('Content-type: application/json');
        die(json_encode($json));
    }
    
    $passhash = create_hash($password);
    
    //check if program already exist or not
    $sql = sprintf("SELECT * FROM `program` WHERE program_name = '%s' ",$biodata["program"]);
    $result_temp = $mysqli->query($sql);
    if(!$result)
        die($mysqli->error);
        
    if($result_temp->num_rows >0){
        $data_temp = $result_temp->fetch_assoc();
        $program_id = $data_temp["program_id"];
    }
    else{
        //insert new
        $sql = sprintf("INSERT INTO `program` (`program_name`) VALUES('%s') ",$biodata["program"]);
        $result_temp = $mysqli->query($sql);
        if(!$result)
            die($mysqli->error);
        $program_id = $mysqli->insert_id;
    }
    
    
    
    if($biodata['campus'] == "Kampus Putrajaya")
        $campus_id = 1;
    else
        $campus_id =2;
    
    
    //check if advisor name already exist in lecturer
    $sql = sprintf("SELECT * FROM  `lecturer` WHERE name = '%s' ",$biodata["advisor"]);
    $result_temp = $mysqli->query($sql);
    if(!$result)
        die($mysqli->error);
    if($result_temp->num_rows >0){
        $data_temp = $result_temp->fetch_assoc();
        $advisor_id = $data_temp["lecturer_id"];
    }
    else{
        //insert new
        $sql = sprintf("INSERT INTO `lecturer` (`name`) VALUES('%s') ",$mysqli->real_escape_string($biodata["advisor"]));
        $result_temp = $mysqli->query($sql);
        if(!$result)
            die($mysqli->error);
        $advisor_id = $mysqli->insert_id;
    }    
    if(!$is_user_exist_local){

        //not not exist, so insert
        $sql = sprintf("INSERT INTO `users` (`studentId`,`name`,`program_id`,`campus_id`,`advisor_id`,`passhash`,`email`,`phone`) 
       VALUES('%s','%s',%s,%s,%s,'%s','%s','%s')",$id,$mysqli->real_escape_string($biodata["name"]),$program_id,$campus_id,$advisor_id,$passhash,$mysqli->real_escape_string($biodata["email"]),$biodata["phone"]);
       if(!$mysqli->query($sql))
        die($mysqli->error);  

    }
    else{
       //user already exist but maybe he reset the password
       $sql = sprintf("UPDATE `users` SET `passhash`='%s',`email`='%s',`phone`='%s'  WHERE `studentId`='%s'",$passhash,$mysqli->real_escape_string($biodata["email"]),$mysqli->real_escape_string($biodata["phone"]),$id);
       if(!$mysqli->query($sql))
        die($mysqli->error);     
    }
    
    //generate cryptographically secure tokens, use as password encryption
    $rand_token = bin2hex(openssl_random_pseudo_bytes(16, $cstrong));
    //save session
    $_SESSION['passhash'] = $passhash;
    $_SESSION['sessionToken'] = $rand_token;
    $_SESSION['sessionStudentId'] = $id;
    $json = array("authenticated"=>true,"encrypted_pass"=>Encrypt($password,$rand_token),"debug"=>"data from remote");
    header('Content-type: application/json');
    die(json_encode($json)); 

}


    



?>