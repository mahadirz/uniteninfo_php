<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 * @version 18/1/2015 : 21:42
 */


function parseUnitenInfo($url,$username,$password){
    $cookie_file_path = dirname(__FILE__) . '/cookies.txt';
    $ch = curl_init();

    //==============================================================
     curl_setopt($ch, CURLOPT_USERPWD, $username. ':' . $password);
     curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
     curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
     curl_setopt($ch, CURLOPT_URL, $url);
     curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
     curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_NTLM);
     curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
     curl_setopt($ch, CURLINFO_HEADER_OUT, true);
     curl_setopt($ch, CURLOPT_FAILONERROR, 0);
     curl_setopt($ch, CURLOPT_MAXREDIRS, 100);
     curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file_path);
     curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file_path);
    //=============================================================
    $ret = curl_exec($ch);
    //file_put_contents("unitendb/".$filename,$ret);
    return $ret;
}

function updateBiodata($username,$password,$email,$phone,$address_arr){
    //echo "<pre>";
    //print_r($address_arr);
    //echo '</pre>';
    $cookie_file_path = dirname(__FILE__) . '/cookies.txt';
    $data = array('CPHONE' => $phone, 'EMAIL' => $email);
    $data += $address_arr;
    foreach($data as $key=>$value) { $fields_string .= $key.'='.urlencode($value).'&'; }
    
    $fields_string = rtrim($fields_string, '&');
        
    //print_r($fields_string);
    //die("<br>");

    $ch = curl_init();

    //==============================================================
     curl_setopt($ch, CURLOPT_USERPWD, $username. ':' . $password);
     curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
     curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, 0);
     curl_setopt($ch, CURLOPT_URL, "http://info.uniten.edu.my/info/Ticketing.asp?WCI=Biodata&WCE=PROCESS");
     curl_setopt($ch, CURLOPT_SSL_VERIFYHOST, 0);
     curl_setopt($ch, CURLOPT_HTTPAUTH, CURLAUTH_NTLM);
     curl_setopt($ch, CURLOPT_FOLLOWLOCATION, true);
     curl_setopt($ch, CURLINFO_HEADER_OUT, true);
     curl_setopt($ch, CURLOPT_FAILONERROR, 1);
     curl_setopt($ch, CURLOPT_POST, 1);
     curl_setopt($ch, CURLOPT_POSTFIELDS, $fields_string);
     curl_setopt($ch, CURLOPT_MAXREDIRS, 100);
     curl_setopt($ch, CURLOPT_COOKIEFILE, $cookie_file_path);
     curl_setopt($ch, CURLOPT_COOKIEJAR, $cookie_file_path);
    //=============================================================
    $ret = curl_exec($ch);
    //file_put_contents("unitendb/".$filename,$ret);
    return $ret;
}



?>