<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 * 
 * Pitfall of this design
 * Using too many sql query sequentially is confusing
 * Should use object with method approach,
 * debugging will be costy
 * 
 * Never use this approach in future
 * 
 */

if (!defined('SECURITY_ACCESS'))
{
    die("Direct access to file is not permitted!!!");
}

$password = getPasswordFromCookie();
$studentId = $_SESSION['sessionStudentId'];

//retrieve user_id
$user_id = getUserIdFromStudentId($studentId,$mysqli);


$sql = sprintf("SELECT * FROM `last_update_subject` WHERE `user_id` = '%s'",$user_id);
$result = $mysqli->query($sql);
if($result->num_rows <= 0){
    //no record yet
    $sql = sprintf("INSERT INTO `last_update_subject` (`user_id`,`date`) VALUES('%s',DATE_SUB(NOW(),INTERVAL 8 DAY))",$user_id);
    if(!$mysqli->query($sql))
        die("error: $sql ".$mysqli->error);
        
    //refresh previous query
    $sql = sprintf("SELECT * FROM `last_update_subject` WHERE `user_id` = '%s'",$user_id);
    $result = $mysqli->query($sql);
    
}

//check if last update less than 7 days
$last_update_subject = $result->fetch_object();
if(strtotime($last_update_subject->date) < time()-604800){
    //get list of timetable from student info, in form of (url=>"",semester=>"")
    $raw_html = parseUnitenInfo("http://info.uniten.edu.my/info/Ticketing.asp?WCI=TimeTable",$studentId,$password);
    $list_tb = parseListTimetable($raw_html);
    //$list_tb  = json_decode(file_get_contents("list_tb.cache"),1);
    
    //reverse it, 0 => first semester
    $list_tb = array_reverse($list_tb);
    
    //I made mistake just found it, the update by ajax is asynchronous
    //so the sequence of update is uncertain
    //this is the patch for latest semester recorded by system
    $sql = sprintf("SELECT `semester`.semester_name FROM `subject_by_student` AS sbs
    INNER JOIN `semester` ON `semester`.semester_id = sbs.semester_id
    WHERE sbs.user_id = '%s'
    GROUP BY `semester`.semester_id
    ORDER BY semester_sort(`semester`.semester_name) DESC
    LIMIT 1
    ",$user_id);
    
    $result = $mysqli->query($sql);
    if(!$result)
        die("error:".$sql." ".$mysqli->error);
    
    $latest_semester_name_recorded = $result->fetch_object();
    $latest_semester_name_recorded = $latest_semester_name_recorded->semester_name;
    
    //first of the array will be the latest one,
    //check if the last updated is the latest
    //if yes, don't waste on iniating update
    //$sql = sprintf("SELECT * FROM `semester` WHERE `semester_name` = '%s'",$list_tb[count($list_tb)-1]["semester"]);
    //$result = $mysqli->query($sql);
    //if(!$result)
    //    die("error:".$sql." ".$mysqli->error);
    //$semester = $result->fetch_object();
    
    echo_html($latest_semester_name_recorded);
    //die($list_tb[count($list_tb)-1]["semester"]);
    
    if(strcasecmp(trim($latest_semester_name_recorded),trim($list_tb[count($list_tb)-1]["semester"])) != 0){
        //data in last_update_subject was absolete
        //block student from performing subject search
        $smarty->assign("block_search_access",true);
        
        //generate data for ajax to update
        //search for last update
        $i=count($list_tb);
        foreach($list_tb as $k){
            if(strcasecmp(trim($latest_semester_name_recorded),trim($k["semester"])) == 0){
                break;
            }
            $i--;
        }
        $smarty->assign("update_start_index",$i);
        $smarty->assign("total_array",count($list_tb));
        $smarty->assign("update_total",count($list_tb)-$i);
        $smarty->assign("list_tb",json_encode($list_tb));
    }
    else{
        //update last update
        //update last  `last_update_subject`
        //get last_update_subject_id
        $sql = sprintf("UPDATE `last_update_subject` SET `date`= NOW() WHERE `user_id` = '%s'",$user_id);
            if(!$mysqli->query($sql))
                die("error:".$sql." ".$mysqli->error);
    }
    
    
    
   
}




if($_POST){
    //when search was clicked
    $searchSubject = stripcslashes(strip_tags($_POST['searchSubject']));
    $searchSubject = $mysqli->real_escape_string($searchSubject);
    
    $sql = sprintf("SELECT `subjects`.code,`subjects`.name,ROUND( sbs.price, 2 ) as price 
    FROM `subject_by_student` as sbs
    INNER JOIN `subjects` ON `subjects`.subject_id = sbs.subjects_id
    WHERE `subjects`.name LIKE '%%%s%%' OR `subjects`.code LIKE '%%%s%%' GROUP BY `subjects`.code
    LIMIT 10",$searchSubject,$searchSubject);    
    $result = $mysqli->query($sql);
    if(!$result)
        die("error".$sql." ".$mysqli->error);
    $search_result = array();
    while($row = $result->fetch_assoc()){
        $search_result[] = $row;
    }
    $smarty->assign("search_result",$search_result);
}

$smarty->assign("nav","b");

if($_GET['code']){
    $subject_code = $mysqli->real_escape_string(stripcslashes(strip_tags($_GET['code']))); 
    $sql = sprintf("SELECT `semester`.semester_name,`subjects`.code,`subjects`.name,ROUND( sbs.price, 2 ) as price 
    FROM `subject_by_student` as sbs
    INNER JOIN `subjects` ON `subjects`.subject_id = sbs.subjects_id
    INNER JOIN `semester` ON `semester`.semester_id = sbs.semester_id
    WHERE `subjects`.code = '%s' GROUP BY `price`
    ORDER BY  SUBSTRING(`semester`.semester_name , -9 ) DESC
    LIMIT 10",$subject_code);
    $result = $mysqli->query($sql);
    if(!$result)
        die("error".$sql." ".$mysqli->error);
    
    $subject_list1 = array();
    while($rows = $result->fetch_assoc()){
        $subject_list1[] = $rows;
    }
    
    $sql = sprintf("SELECT LCASE(`lecturer`.name) AS lecturer_name,`semester`.semester_name
    FROM `subject_by_student` as sbs
    INNER JOIN `subjects` ON `subjects`.subject_id = sbs.subjects_id
    INNER JOIN `semester` ON `semester`.semester_id = sbs.semester_id
    INNER JOIN `lecturer` ON sbs.lecturer_id = `lecturer`.lecturer_id
    WHERE `subjects`.code = '%s' GROUP BY `lecturer`.name
    ORDER BY  SUBSTRING(`semester`.semester_name , -9 ) DESC
    LIMIT 10",$subject_code);
    $result = $mysqli->query($sql);
    if(!$result)
        die("error".$sql." ".$mysqli->error);
    
    $subject_list2 = array();
    while($rows = $result->fetch_assoc()){
        $subject_list2[] = $rows;
    }    
    $smarty->assign("subject_list1",$subject_list1);
    $smarty->assign("subject_list2",$subject_list2);
    $smarty->assign("subject_code",$subject_code);
    $smarty->assign("subject_name",$subject_list1[0]["name"]);
    $smarty->display('students/subjectdetails.tpl');
    //debug_pre($subject_list2);
    exit;
}
else{
    //get total subject
    $sql = "SELECT  DISTINCT count(subjects_id) as t FROM `subject_by_student`";
    $result = $mysqli->query($sql);
    $total_subjects = $result->fetch_object();
    $smarty->assign("total_subjects",$total_subjects->t);
    
    $smarty->display('students/subjects.tpl');
}



?>