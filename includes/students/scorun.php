<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 * @version 25/1/2015 : 15:28
 */

if (!defined('SECURITY_ACCESS'))
{
    die("Direct access to file is not permitted!!!");
}

$password = getPasswordFromCookie();
$studentId = $_SESSION['sessionStudentId'];

//retrieve user_id
$user_id = getUserIdFromStudentId($studentId,$mysqli);


$sql = sprintf("SELECT * FROM `scorun` WHERE user_id='%s'",$user_id);
$result = $mysqli->query($sql);
if(!$result)
    die("error ".$sql." ".$mysqli->error);

if($result->num_rows <= 0){
    //no record yet
    $sql = sprintf("INSERT INTO `scorun` (`user_id`,`value`,`last_update`) VALUES('%s',0,DATE_SUB(NOW(),INTERVAL 8 DAY))",$user_id);
    if(!$mysqli->query($sql))
        die("error: $sql ".$mysqli->error);
        
    //refresh previous query
    $sql = sprintf("SELECT * FROM `scorun` WHERE `user_id` = '%s'",$user_id);
    $result = $mysqli->query($sql);
    
}

//check if last update less than 7 days
$last_update_scorun = $result->fetch_object();
if(strtotime($last_update_scorun->last_update) < time()-604800){
    $raw_scorun_progress = parseUnitenInfo("http://info.uniten.edu.my/Scorun/ProgressReport.aspx?mode=student",$studentId,$password);
    $pattern = '/Total Student Run :[\s\S]+?size="2">([\s\S]+?)<\/font>/i';
    preg_match($pattern,$raw_scorun_progress,$scorun_matches);
    $scorun_value = trim($scorun_matches[1]);
    
    
    $sql = sprintf("UPDATE `scorun` SET `value` = %s,`last_update` = NOW() WHERE `user_id`='%s'",$scorun_value,$user_id);
    if(!$mysqli->query($sql))
        die("error: $sql ".$mysqli->error);   
        
    
}

$sql = "SELECT LCASE(`users`.name) AS `name`, `program`.program_name
        FROM `scorun`
        INNER JOIN `users` ON `users`.user_id = `scorun`.user_id
        INNER JOIN `program` ON `program`.program_id = `users`.program_id
        ORDER BY `scorun`.value DESC
        LIMIT 50 ";
$result = $mysqli->query($sql);
if(!$result)
    die("error ".$sql." ".$mysqli->error);
    
$top_scorun = array();

while($rows = $result->fetch_assoc()){
    $top_scorun[] = $rows;
}

$smarty->assign("top_scorun",$top_scorun);

//echo "<pre>";
//print_r($top_scorun);
//echo "</pre>";

$smarty->assign("nav","c");
$smarty->display('students/scorun.tpl');
?>