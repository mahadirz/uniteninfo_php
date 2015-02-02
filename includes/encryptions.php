<?php

/**
 * @author Mahadir
 * @copyright 2014
 */
 
$IV = "ufwTesgk0ThAan0pidg+Foz1vEawyiGC3t8TEX48ubs=";

function Encrypt($data,$key){
    global $IV;
    $crypttext = mcrypt_encrypt(MCRYPT_RIJNDAEL_256, $key, $data, MCRYPT_MODE_ECB, base64_decode($IV)); 
    return bin2hex($crypttext);
}

function Decrypt($crypttext,$key){
    global $IV;
    return mcrypt_decrypt(MCRYPT_RIJNDAEL_256,$key,hex2bin ($crypttext),MCRYPT_MODE_ECB,base64_decode($IV));
}


//base64 cannot be stored in cookie, can cause problem

?>