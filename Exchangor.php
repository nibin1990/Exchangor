<?php

/* 
 * Utility to notify you when you have favourable exchange rates
 * @Author Nibin
 */

require '/var/www/html/email_client.php';
$threshold=$argv[1];
$receiver=$argv[2];

$API_SECRET=$argv[3];
$CURRENCY=$argv[4];

$url="http://apilayer.net/api/live?access_key=".$API_SECRET."&currencies=".$CURRENCY."&format=1";
$handle = curl_init($url);
curl_setopt($handle,  CURLOPT_RETURNTRANSFER, TRUE);

$json = json_decode(curl_exec($handle), true);

 print_r(curl_exec($handle));

if($json['success'] && $json['quotes']['USDINR']>=$threshold){
   $message= "Exchange rates above ".$json['quotes']['USDINR']." INR. Consider transferring money now.";
   $subject= "Favourable Exchange Rates !!";
   
}elseif(!$json['success'] ){
   $message= "There is some issue with the Exchangor API. Please look into it";
   $subject= "Issue with the Exchangor API";
}else{
    return 0;
}
email_client::email_send($receiver,$message,$subject);
?>
