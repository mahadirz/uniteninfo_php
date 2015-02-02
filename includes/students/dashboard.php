<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2014
 */

if (!defined('SECURITY_ACCESS'))
{
    die("Direct access to file is not permitted!!!");
}

$password = getPasswordFromCookie();
$studentId = $_SESSION['sessionStudentId'];

if($_POST){
    
    $biodata_html = parseUnitenInfo("http://info.uniten.edu.my/info/Ticketing.asp?WCI=Biodata",$studentId,$password);
    $address = parseAddress($biodata_html);
    $new_biodata_html = updateBiodata($studentId,$password,$_POST['email'],$_POST['phone'],$address);
    
    $new_biodata = parseBiodata($new_biodata_html);
    
    if(count($new_biodata)>0 ){
        $sql = sprintf("UPDATE `users` SET `email`='%s', `phone`='%s' WHERE `studentId`='%s'",$new_biodata['email'],$new_biodata['phone'],$studentId);
        if(!$mysqli->query($sql))
            die($mysqli->error);
    }
    
}


$sql = sprintf("SELECT `users`.studentId,`users`.name,`users`.email,`users`.phone,`lecturer`.name as advisor,`program`.program_name,`campus`.name as campus,`scorun`.value as scorun
FROM `users` 
LEFT JOIN `lecturer`
ON `lecturer`.lecturer_id = `users`.advisor_id
LEFT JOIN `program`
ON `program`.program_id = `users`.program_id
LEFT JOIN `campus`
ON `campus`.campus_id = `users`.campus_id
LEFT JOIN `scorun`
ON `scorun`.user_id = `users`.user_id
WHERE studentId='%s'",$studentId);

$result = $mysqli->query($sql);
if(!$result)
    die($sql." error:".$mysqli->error);
$student_data = $result->fetch_object();

//echo "<pre>";
//print_r($student_data);
//echo "</pre>";

$smarty->assign("student_data",$student_data);
$smarty->assign("nav","a");

$smarty->display('students/index.tpl');

?>