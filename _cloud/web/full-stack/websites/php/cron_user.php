<i?php
require("db.php");
exit; /* added exit on 23-05-2017 because client asked to stop mail sending */
function encryptData($sData) {
    $id = (double) $sData * 525325.24;
    return base64_encode($id);
}
function decryptData($sData) {
	$url_id = base64_decode($sData);
	$id = (double) $url_id / 525325.24;
	return $id;
}

    
$sql="SELECT id
            ,`Realtors Name`
			,`Email`
			,`Phone`
			,`subscription_start_date`
			,`first_mail`
			,`second_mail`
			,`third_mail`
			,`mail_send_date`
			,`subscription_end_date`
			,`submission_date`
			,TIMESTAMPDIFF(MONTH,`subscription_start_date`
			,NOW()) as diff_month 
FROM `students` 
WHERE TIMESTAMPDIFF(MONTH,`subscription_start_date`, NOW())='11' 
AND `status`='1' OR submission_date = '0000-00-00' 
ORDER BY id DESC";

//echo $sql;exit;

$result = mysql_query($sql);

$datas =  array();

while($record = mysql_fetch_assoc($result)){
	
	$datas[] =  $record;
}


//echo '<pre>';
//print_r($datas);exit;
if (!empty($datas) && count($datas)>0) {
	
	foreach ($datas as $key => $value) {

		/*
		* second time mail send parameters
		*/
		$days_between = 0;
		if ($value['first_mail']==1) {
			
			$first_data = $value['mail_send_date'];
			$end_date 	= date('Y-m-d H:i:s');

			$start 	= strtotime($first_data);
			$end 	= strtotime($end_date);

			$days_between = ceil(abs($end - $start) / 86400);
		}
		/*
		* third time mail send parameters
		*/
		$today_dt 	= date('Y-m-d');
		$expire_dt  = $value['subscription_end_date'];

		if ($value['second_mail']=='1') {
			
			$date = date_create($value['subscription_end_date']);
			date_sub($date, date_interval_create_from_date_string('1 days'));
			$expire_dt = date_format($date, 'Y-m-d');
		}
		/*
		* sending mail code
		*/
		if ($value['first_mail']==0) {
			
			sendMail($value);

			$user_id 		= $value['id'];			
			$mail_send_date = date('Y-m-d');

			$usql = "UPDATE `students` SET `first_mail`='1',`mail_send_date`='$mail_send_date', email_sent='Yes' WHERE `id`='$user_id'";
			mysql_query($usql);

		}else if($value['first_mail']==1 && $value['second_mail']==0 && $days_between>15){

			sendMail($value);

			$user_id 		= $value['id'];			
			$mail_send_date = date('Y-m-d');

			$usql = "UPDATE `students` SET `second_mail`='1',`mail_send_date`='$mail_send_date', email_sent='Yes' WHERE `id`='$user_id'";
			mysql_query($usql);

		}else if($value['first_mail']==1 && $value['second_mail']==1 && $value['third_mail']==0 && ($expire_dt == $today_dt)){

			sendMail($value);

			$user_id 		= $value['id'];			
			$mail_send_date = date('Y-m-d');

			$usql = "UPDATE `students` SET `third_mail`='1',`mail_send_date`='$mail_send_date', email_sent='Yes' WHERE `id`='$user_id'";
			mysql_query($usql);

		}else if(($value['first_mail']==1 && $value['second_mail']==1 && $value['third_mail']==1)||(date('Y-m-d H:i:s')>$value['subscription_end_date'])){

			
			if (date('Y-m-d H:i:s')>$value['subscription_end_date']) {
				
				$user_id 		= $value['id'];

				$usql = "UPDATE `students` SET `status`='0' WHERE `id`='$user_id'";
				mysql_query($usql);
			}

		}

	}
}
function sendMail($value = null){
	// subject
		$to  	 = $value['Email'];
		$subject = 'Subscripton Reminder';
		$user_id = encryptData($value['id']);
		$clickurl= '<a href="http://' . $_SERVER['HTTP_HOST'] . '/update_subscription.php?sid='.$user_id.'">Click Here</a>';
		
		$message = 'Membership fee will be only &euro;20 and your membership will be valid for 1 year from the date of payment.';

		$expire_date = date("M d, Y",strtotime($value['subscription_end_date']));

		$content = file_get_contents('mail_content_cron.php');
		$content = str_replace("#NICKNAME#", $value['Realtors Name'], $content);
		$content = str_replace("#EMAIL#", $value['Email'], $content);
		$content = str_replace("#PHONE#", $value['Phone'], $content);
		$content = str_replace("#MESSAGE#", $message, $content);
        $content = str_replace("#EXPIREDATE#", $expire_date, $content);
        $content = str_replace("#PAYURL#", $clickurl, $content);

        // To send HTML mail, the Content-type header must be set
		$headers  = 'MIME-Version: 1.0' . "\r\n";
		$headers .= 'Content-type: text/html; charset=iso-8859-1' . "\r\n";

		// Additional headers
		$headers .= 'To:<'.$to.'>'."\r\n";
		$headers .= 'From: '.$subject.' <admin@mail.com>' . "\r\n";

		// Mail it
		//mail($to, $subject, $content, $headers);
		//mail('ds.developertest@gmail.com ', $subject, $content, $headers);
}
?>

