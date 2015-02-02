<?php

/**
 * @author Mahadir Ahmad
 * @copyright 2015
 */

if (!defined('SECURITY_ACCESS'))
{
    die("Direct access to file is not permitted!!!");
}

if(isset($_SESSION['sessionStudentId']) && !empty($_SESSION['sessionStudentId'])){
        header('Location: home');
        exit;
}




//always reset cookie
setcookie ("student_id", "", time() - 3600);
setcookie ("encrypted_pass", "", time() - 3600);

$smarty->display('login.tpl');

?>