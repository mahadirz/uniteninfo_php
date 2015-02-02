<?php

/**
 * @author Mahadir Ahmad
 * @author Alif Fakhruddin Azhar
 * @copyright 2015
 * @version 18/1/2015 : 22:41
 */


// Core Engine Parser

//include_once "NTLM_parser.php";
//$raw_biodata = parseUnitenInfo("http://info.uniten.edu.my/info/Ticketing.asp?WCI=Biodata","sw091740","");

//$rawHtml = file_get_contents("biodata.htm");
//echo '<pre>';
//print_r(parseBiodata($raw_biodata));
//echo '</pre>';

function parseBiodata($rawHtml){
    $pattern = '/Name:<\/TD><TD>([\s\S]+?)<\/TD>[\s\S]+?Program:<\/TD><TD>([\s\S]+?)<\/TD>[\s\S]+?Campus:<\/TD><TD>([\s\S]+?)<\/TD>[\s\S]+?Advisor:<\/TD><TD>([\s\S]+?)<\/TD>[\s\S]+?CPHONE"[\s\S]+?VALUE="([\s\S]+?)"><\/TD>[\s\S]+?EMAIL" VALUE="([\s\S]+?)" SIZE/i';
    preg_match($pattern, $rawHtml, $matches);
    //append to array
    return array("name"=>$matches[1],"program"=>$matches[2],"campus"=>$matches[3],"advisor"=>$matches[4],"phone"=>$matches[5],"email"=>$matches[6]);
}

function parseAddress($rawHtml){
    $pattern = '/CADDRESS"[\s\S]+?value="([\s\S]*?)">[\s\S]+?CTOWN"[\s\S]+?value="([\s\S]*?)"[\s\S]+?CSTATE[\s\S]+?value="([\s\S]*?)">[\s\S]+?CPOSTCODE[\s\S]+?value="([\s\S]*?)">/i';
    preg_match($pattern, $rawHtml, $matches);
    return array("CADDRESS"=>$matches[1],"CTOWN"=>$matches[2],"CSTATE"=>$matches[3],"CPOSTCODE"=>$matches[4]);
}

function parseListTimetable($rawHtml){
    $pattern = '/<TR CLASS="LINE[\d]{1,2}"><TD>\d\.<\/TD>[\s\S]+?<A HREF="([\s\S]+?)">([\s\S]+?)<\/A>/i';
    preg_match_all($pattern,$rawHtml,$matches);
        
    $ret=array();
    for($i=0;$i<count($matches[1]);$i++){
        $ret[] = array("url"=>"http://info.uniten.edu.my/info/".trim($matches[1][$i]),"semester"=>trim($matches[2][$i]));
    }
    return $ret;
    
}



?>