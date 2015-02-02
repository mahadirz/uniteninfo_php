<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 * @version 25/1/2015 : 0:30
 */

//echo "<pre>";
//print_r($_POST);
//echo "</pre>";

if (!defined('SECURITY_ACCESS'))
{
    die("Direct access to file is not permitted!!!");
}

header("content-type:application/json");
//check url is correct, this is also for security reason
$url = $_POST['url'];
$pattern = '/^http:\/\/info.uniten.edu.my\/info\/Ticketing.asp\?WCI=TimeTable&WCE=\d+$/i';
if(!preg_match($pattern,$url)){
    die(json_encode(array("error"=>true,"debug"=>"the url is weird!")));
}
    

$password = getPasswordFromCookie();
$studentId = $_SESSION['sessionStudentId'];

//retrieve user_id
$sql = sprintf("SELECT `user_id` FROM `users` WHERE `studentId`='%s'",$studentId);
$result = $mysqli->query($sql);
if(!$result)
    die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
$user_id= $result->fetch_object();
$user_id = $user_id->user_id;

//now lets fetch the timetable
$raw_html = parseUnitenInfo($url,$studentId,$password); 

//get the semester name
$pattern = '/Time Table for([\s\S]+?)<\/H1>/i';
if(!preg_match($pattern,$raw_html,$matches_semester)){
    die(json_encode(array("error"=>true,"debug"=>"semester name not found!")));
}

    //get semester id
    $sql = sprintf("SELECT * FROM   `semester` WHERE `semester_name`='%s'",$matches_semester[1]);
    $result = $mysqli->query($sql);
    if(!$result)
        die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
    $semester_id = "";
    if($result->num_rows <= 0){
        //result not exist
        $sql = sprintf("INSERT INTO `semester` (`semester_name`) VALUES('%s')",$matches_semester[1]);
        if(!$mysqli->query($sql))
            die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
        
        $semester_id = $mysqli->insert_id;    
    }
    else{
        $semester_id = $result->fetch_object();
        $semester_id = $semester_id->semester_id;
    }
    
    
    //update last  `last_update_subject`
    //get last_update_subject_id
    $sql = sprintf("SELECT * FROM   `last_update_subject` WHERE `user_id`='%s'",$user_id);
    $result = $mysqli->query($sql);
    if(!$result)
        die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));

    if($result->num_rows <= 0){
        //result not exist
        $sql = sprintf("INSERT INTO `last_update_subject` (`user_id`,`semester_id`,`date`) VALUES('%s','%s',NOW())",$user_id,$semester_id);
        if(!$mysqli->query($sql))
            die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
   
    }
    else{
        $sql = sprintf("UPDATE `last_update_subject` SET `semester_id`='%s',`date`= NOW() WHERE `user_id` = '%s'",$semester_id,$user_id);
        if(!$mysqli->query($sql))
            die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
    }


//extract subject list table
$pattern = '/<TABLE CELLSPACING="0"([\s\S]+?)<\/TABLE>/i';
if(!preg_match($pattern,$raw_html,$matches_subject_table)){
    die(json_encode(array("error"=>true,"debug"=>"subject table not found!")));
}

//extract subject list, lecturer, and price
// $matches_subject_list[1] => subject code
// $matches_subject_list[2] => lecturer's name
// $matches_subject_list[3] => fee
$pattern = '/<TR CLASS="LINE\d{1,2}"><TD>\d{1,2}\.<\/TD><TD>([\s\S]+?)<\/TD>[\s\S]+?RIGHT">\d<\/TD><TD>([\s\S]+?)<\/TD><TD ALIGN=RIGHT>([\s\S]+?)<\/TD><\/TR>/i';
if(!preg_match_all($pattern,$raw_html,$matches_subject_list)){
    die(json_encode(array("error"=>true,"debug"=>"subject list error!")));
}


for($i=0; $i<count($matches_subject_list[1]); $i++){
    //get lecturer id,or insert if not exist
    $sql = sprintf("SELECT * FROM  `lecturer` WHERE `name`='%s'",$mysqli->real_escape_string($matches_subject_list[2][$i]));
    $result = $mysqli->query($sql);
    if(!$result)
        die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
    $lecturer_id = "";
    if($result->num_rows <= 0){
        //result not exist
        $sql = sprintf("INSERT INTO `lecturer` (`name`) VALUES('%s')",$mysqli->real_escape_string($matches_subject_list[2][$i]));
        if(!$mysqli->query($sql))
            die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
        
        $lecturer_id = $mysqli->insert_id;    
    }
    else{
        $lecturer_id = $result->fetch_object();
        $lecturer_id = $lecturer_id->lecturer_id;
    }
    
    //get subject id
    $sql = sprintf("SELECT * FROM  `subjects` WHERE `code`='%s'",$matches_subject_list[1][$i]);
    $result = $mysqli->query($sql);
    if(!$result)
        die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
    $subject_id = "";
    if($result->num_rows <= 0){
        //result not exist
        $sql = sprintf("INSERT INTO `subjects` (`code`,`name`) VALUES('%s','%s')",$matches_subject_list[1][$i],$matches_subject_list[1][$i]);
        if(!$mysqli->query($sql))
            die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
        
        $subject_id = $mysqli->insert_id;    
    }
    else{
        $subject_id = $result->fetch_object();
        $subject_id = $subject_id->subject_id;
    }
    

    
    //check if data already exist
    $sql = sprintf("SELECT * FROM `subject_by_student`
    WHERE user_id = %s AND
    semester_id = %s AND
    lecturer_id =%s AND
    subjects_id = %s",$user_id,$semester_id,$lecturer_id,$subject_id);
    
    $result = $mysqli->query($sql);
    if(!$result)
        die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
    
    if($result->num_rows > 0){
        die(json_encode(array("error"=>false,"debug"=>"","data"=>"Record already exist")));
    }
    
    
    //save this data into database
    $price = str_replace(",","",$matches_subject_list[3][$i]);
    $sql = sprintf("INSERT INTO `subject_by_student` (price,subjects_id,semester_id,user_id,lecturer_id) 
    VALUES('%s','%s','%s','%s','%s')",$price,$subject_id,$semester_id,$user_id,$lecturer_id);
    if(!$mysqli->query($sql))
        die(json_encode(array("error"=>true,"debug"=>$sql." error:".$mysqli->error)));
}




echo(json_encode(array("error"=>false,"debug"=>"","data"=>"OK")));



?>