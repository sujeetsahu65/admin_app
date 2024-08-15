<?php

function get_labels($conn_super, $lang_code)
{
	$sql_payment_gateway = "select header,title from admin_dashboard_content where lang_code ='$lang_code' and type='1' ";
	$result_sql_payment_gateway = mysqli_query($conn_super, $sql_payment_gateway);
	$num_sql_payment_gateway = mysqli_num_rows($result_sql_payment_gateway);
	if ($num_sql_payment_gateway > 0) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($result_sql_payment_gateway)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function preOrderConvertToNewOrder($conn, $loc_id) 
{
	$today_datetime = date("Y-m-d H:i:s");
	$sql_query = "SELECT orders.order_id,orders.rand_order_no,orders.order_datetime,orders.pre_order_response_alert_time from orders WHERE orders.loc_id=$loc_id and orders.pre_order_booking=2 order by  orders.order_id DESC";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	if($rows_found>0)
	{
		while ($value = $result->fetch_assoc()) {
			
			$order_id = $value['order_id'];
			$pre_order_response_alert_time = $value['pre_order_response_alert_time'];
			$preorder_datetime = strtotime($value['order_datetime']);
			$today_currentdatetime = strtotime($today_datetime);
			$timediffwithpreorder=round(abs($preorder_datetime - $today_currentdatetime) / 60,2);
			if($timediffwithpreorder<=$pre_order_response_alert_time)
			{
			    $sql_1 = "update orders set pre_order_booking ='1'  where order_id ='".$order_id."'";
	            $rs_1 = mysqli_query($conn,$sql_1);
			}
		}
	}
}

function tblOrderConvertToNewOrder($conn, $loc_id) 
{
	$today_datetime = date("Y-m-d H:i:s");
	$sql_query = "SELECT orders.order_id,orders.rand_order_no,orders.order_datetime,orders.table_booking_response_alert_time from orders WHERE orders.loc_id=$loc_id and orders.table_booking=2 order by  orders.order_id DESC";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	if($rows_found>0)
	{
		while ($value = $result->fetch_assoc()) {
			
			$order_id = $value['order_id'];
			$table_booking_response_alert_time = $value['table_booking_response_alert_time'];
			$tblorder_datetime = strtotime($value['order_datetime']);
			$today_currentdatetime = strtotime($today_datetime);
			$timediffwithtblorder=round(abs($tblorder_datetime - $today_currentdatetime) / 60,2);
			if($timediffwithtblorder<=$table_booking_response_alert_time)
			{
			    $sql_1 = "update orders set table_booking ='1'  where order_id ='".$order_id."'";
	            $rs_1 = mysqli_query($conn,$sql_1);
			}
		}
	}
}


function getOrderDetailWithCurrentStatus($conn, $loc_id, $order_need_type, $order_id)
{
	$add_condition = "";
	if ($order_need_type == "new_order_just_placed") {
		//$add_condition = " and orders.payment_status_id=5 and (orders.orders_status_id=3 or orders.orders_status_id=5) and (orders.pre_order_booking=0 or orders.pre_order_booking=1 or orders.pre_order_booking=3) and (orders.table_booking = 0 or orders.table_booking = 1 or orders.table_booking = 3 )";
		$add_condition = " and orders.payment_status_id=5 and (orders.orders_status_id=3 or orders.orders_status_id=5) and (orders.pre_order_booking=0 or orders.pre_order_booking=1 or orders.pre_order_booking=3)";
	} 
	else if ($order_need_type == "new_preorder_just_placed") {
		$add_condition = "and orders.payment_status_id=5 and orders.orders_status_id=3 and orders.pre_order_booking=2";
	}
	else if ($order_need_type == "new_tblorder_just_placed") {
		//$add_condition = "and orders.payment_status_id=5 and orders.orders_status_id=3 and orders.table_booking=2";
		$add_condition = "and orders.payment_status_id=5 and orders.orders_status_id=3";
	}
	else if ($order_need_type == "order_data_for_set_time_msg" || $order_need_type == "print_order_detail") {
		$add_condition = " and orders.order_id=$order_id ";
	} else if ($order_need_type == "recivied_order_list") {
		$yesterday_date = date('Y-m-d',strtotime("-1 days"));
		//$yesterday_date = date('Y-m-d');
		$add_condition = " and orders.orders_status_id=6 and date(orders.order_date)>='$yesterday_date' ";
	} else if ($order_need_type == "payment_fail_order_list") {
		$today_date = date('Y-m-d',strtotime("-1 days"));
		$add_condition = " and orders.orders_status_id=7 and (orders.payment_status_id=2 or  orders.payment_status_id=3) and orders.order_date>='$today_date' ";
	} else if ($order_need_type == "cancelled_order_list") {
		//$today_date = date('Y-m-d',strtotime("-1 days"));
		$today_date_c = date('Y-m-d');
		$add_condition = " and orders.orders_status_id=4 and orders.order_date>='$today_date_c'";
	}
	else if($order_need_type == "search_order_withrandomno")
	{
		$add_condition = " and orders.rand_order_no='$order_id'"; 
	}

	


	$sql_query = "SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_$_SESSION[lang_id] as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_$_SESSION[lang_id] as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token,orders.delivery_coupon_amt,orders.coupon_discount  FROM `orders` INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id=$loc_id $add_condition order by  orders.order_id DESC";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$order_data = [];
	if ($rows_found > 0) {
		while ($value = $result->fetch_assoc()) {
			$order_data[] =  $value;
		}
		return $order_data;
	} else {
		return $order_data;
	}
}

function getItemSizeName($conn,$language_id,$item_size_id,$loc_id)
  {
    $sql_query = "SELECT master_food_varient_options_topping.food_varient_option_title_$language_id as item_size_name FROM `master_food_varient_options_topping` INNER JOIN master_food_varient_options ON master_food_varient_options_topping.food_varient_options_topping_id=master_food_varient_options.food_varient_options_topping_id WHERE master_food_varient_options.loc_id=$loc_id and master_food_varient_options.food_varient_option_id=$item_size_id";

	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if($rows_found>0)
		{
            $value = $result->fetch_assoc();
            $data =  $value;
			return $data;
		}
		else
		{
			return $data;
		}
  }

  function getSpicyTestList($conn,$language_id,$loc_id)
  {
	$sql_query = "select food_test_$language_id as food_test,food_test_id,food_test_images from master_food_test where taste_status = 1 and 
	loc_id=$loc_id order by display_order ASC";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if($rows_found>0)
			{
				while($value = $result->fetch_assoc()){
					$data[] =  $value;
				}
				return $data;
			}
			else
			{
				return $data;
			}
  }

function getAddToCartOrderListCheckout($conn, $language_id, $session_order_id)
{

	$sql_query = "SELECT order_food_items.order_food_item_id,master_food_items.food_item_name_$language_id as food_item_name,master_food_items.food_item_image,order_food_items.basic_price,order_food_items.item_order_qty,order_food_items.total_basic_price,order_food_items.item_total_toppings_price,order_food_items.food_extratext,order_food_items.size_id,order_food_items.food_test_id  FROM `order_food_items` INNER JOIN master_food_items ON order_food_items.food_item_id=master_food_items.food_item_id  WHERE combo_offer_id=0 and order_food_items.order_id=$session_order_id";
	$stmt = $conn->prepare($sql_query); 
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if ($rows_found > 0) {
		while ($value = $result->fetch_assoc()) {
			$data[] =  $value;
		}
		return $data;
	} else {
		return $data;
	}
}  
function getAddToCartOrderListCheckoutCombo($conn, $language_id, $session_order_id)
{

	$sql_query = "SELECT  combo_offer_id,combo_offer_set_id,combo_product_type, order_food_items.order_food_item_id,master_food_items.food_item_name_$language_id as food_item_name,master_food_items.food_item_image,order_food_items.basic_price,order_food_items.item_order_qty,order_food_items.total_basic_price,order_food_items.item_total_toppings_price,order_food_items.food_extratext,order_food_items.size_id,order_food_items.food_test_id  FROM `order_food_items` INNER JOIN master_food_items ON order_food_items.food_item_id=master_food_items.food_item_id  WHERE combo_offer_id!=0  and order_food_items.order_id=$session_order_id";
	$stmt = $conn->prepare($sql_query); 
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if ($rows_found > 0) {
		while ($value = $result->fetch_assoc()) {
			$data[] =  $value;
		}
		return $data;
	} else {
		return $data;
	}
}  

function getCombooffersbyid($conn, $language_id, $loc_id, $combo_offer_id)
{
    $sql_query = "SELECT combo_offer_id, combo_offer_name_$language_id AS combo_offer_name, total_price, total_product_count, active_status 
                  FROM combo_offers 
                  WHERE loc_id = ? AND active_status = 1 AND combo_offer_id = ?
                  ORDER BY combo_offer_id";
    $stmt = $conn->prepare($sql_query);
    $stmt->bind_param('ii', $loc_id, $combo_offer_id);
    $stmt->execute();
    $result = $stmt->get_result();
    $data = [];

    if ($result->num_rows > 0) {
        while ($value = $result->fetch_assoc()) {
            $data[] = $value;
        }
    }

    return $data;
}


function getAddToCartOrderListToppingsCheckout($conn,$language_id,$order_food_item_id,$loc_id){

	$sql_query = "SELECT order_varients.food_varient_option_type_id,master_food_varient_option_type.food_varient_option_type_$language_id as toppingsheading,master_food_varient_options_topping.food_varient_option_title_$language_id as toppingslistname,order_varients.food_varient_option_base_price,order_varients.food_varient_option_price,order_varients.item_adding_topping_types FROM `order_varients` INNER JOIN master_food_varient_option_type ON order_varients.food_varient_option_type_id=master_food_varient_option_type.food_varient_option_type_id INNER JOIN master_food_varient_options ON order_varients.food_varient_option_id=master_food_varient_options.food_varient_option_id INNER JOIN master_food_varient_options_topping ON master_food_varient_options.food_varient_options_topping_id=master_food_varient_options_topping.food_varient_options_topping_id WHERE order_varients.order_food_item_id=$order_food_item_id and master_food_varient_option_type.loc_id=$loc_id order BY order_varients.item_adding_topping_types";

	 $stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if($rows_found>0)
		{
			while($value = $result->fetch_assoc()){
				$data[] =  $value;
			}
			return $data;
		}
		else
		{
			return $data;
		}  
  } 
/* function getAddToCartOrderListToppingsCheckout($conn, $language_id, $order_food_item_id)
{

	$sql_query = "SELECT order_varients.food_varient_option_type_id,master_food_varient_option_type.food_varient_option_type_$language_id as toppingsheading,master_food_varient_options_topping.food_varient_option_title_$language_id as toppingslistname,order_varients.food_varient_option_base_price,order_varients.food_varient_option_price FROM `order_varients` INNER JOIN master_food_varient_option_type ON order_varients.food_varient_option_type_id=master_food_varient_option_type.food_varient_option_type_id INNER JOIN master_food_varient_options ON order_varients.food_varient_option_id=master_food_varient_options.food_varient_option_id INNER JOIN master_food_varient_options_topping ON master_food_varient_options.food_varient_options_topping_id=master_food_varient_options_topping.food_varient_options_topping_id WHERE order_varients.order_food_item_id=$order_food_item_id order BY order_varients.item_adding_topping_types";

	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if ($rows_found > 0) {
		while ($value = $result->fetch_assoc()) {
			$data[] =  $value;
		}
		return $data;
	} else {
		return $data;
	}
} */

function getOrderResponseTime($conn, $loc_id)
{
	$sql_query = "select * from response_time_setting where loc_id=$loc_id";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$response_time_data = [];
	if ($rows_found > 0) {
		$value = $result->fetch_assoc();
		$response_time_data =  $value;

		return $response_time_data;
	} else {
		return $response_time_data;
	}
}

function getPreOrderResponseTime($conn, $loc_id)
{
	$sql_query = "select * from pre_order_setting where loc_id=$loc_id";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$response_time_data = [];
	if ($rows_found > 0) {
		$value = $result->fetch_assoc();
		$response_time_data =  $value;

		return $response_time_data;
	} else {
		return $response_time_data;
	}
}

function getOrderResponse_email_for_label($conn, $order_lang_id)
{
	$s_order_land = "SELECT (SELECT title from admin_dashboard_content where `header`='order no title' and language_id='$order_lang_id' ) as order_no_title ,(SELECT title from admin_dashboard_content where `header`='title_delivered_to' and language_id='$order_lang_id' ) as title_delivered_to,(SELECT title from admin_dashboard_content where `header`='title_can_be_picked_up' and language_id='$order_lang_id' ) as title_can_be_picked_up,(SELECT title from admin_dashboard_content where `header`='title_can_be_Ready_to_serve_in' and language_id='$order_lang_id' ) as title_can_be_Ready_to_serve_in ,(SELECT title from admin_dashboard_content where `header`='title_Hello' and language_id='$order_lang_id' ) as title_Hello ,(SELECT title from admin_dashboard_content where `header`='thank regard' and language_id='$order_lang_id' ) as thank_regard ,(SELECT title from admin_dashboard_content where `header`='Mobile No label' and language_id='$order_lang_id' ) as Mobile_No_label ,(SELECT title from admin_dashboard_content where `header`='E-mail label' and language_id='$order_lang_id' ) as E_mail_label ,(SELECT title from admin_dashboard_content where `header`='title_site' and language_id='$order_lang_id' ) as title_site ,(SELECT title from admin_dashboard_content where `header`='title_delivered_to_middle' and language_id='$order_lang_id' ) as title_delivered_to_middle ,(SELECT title from admin_dashboard_content where `header`='title_delivered_to_last' and language_id='$order_lang_id' ) as title_delivered_to_last ,(SELECT title from admin_dashboard_content where `header`='title_can_be_picked_up_middle' and language_id='$order_lang_id' ) as title_can_be_picked_up_middle,(SELECT title from admin_dashboard_content where `header`='title_it_on_the_way' and language_id='$order_lang_id' ) as title_it_on_the_way,(SELECT title from admin_dashboard_content where `header`='title_is_ready_to_pick' and language_id='$order_lang_id' ) as title_is_ready_to_pick,(SELECT title from admin_dashboard_content where `header`='title_is_ready_to_serve' and language_id='$order_lang_id' ) as title_is_ready_to_serve,(SELECT title from admin_dashboard_content where `header`='title_is_on_the_way' and language_id='$order_lang_id' ) as title_is_on_the_way,(SELECT title from admin_dashboard_content where `header`='title_was_cancelled' and language_id='$order_lang_id' ) as title_was_cancelled   FROM `admin_dashboard_content` limit 1";


	$r_order_land = mysqli_query($conn, $s_order_land);
	$row_order_land = mysqli_fetch_array($r_order_land);
	$lang_label_data = [];
	$lang_label_data = $row_order_land;
	return $lang_label_data;
}

function getActivetedShopPaymentGatewayData($conn, $loc_id, $language_id)
{
	$sql_query = "select gateway_id,payment_gateway_detail_id,payment_gateway_commission_id,payment_gateway_userid,payment_gateway_title_$language_id as payment_gateway_title  from payment_gateway_setting where 	payment_gateway_status =1 and loc_id=$loc_id";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if ($rows_found > 0) {
		$value = $result->fetch_assoc();
		$data =  $value;
		return $data;
	} else {
		return $data;
	}
}

function getSuperAdminPaymentGatewayAccount($conn, $payment_gateway_detail_id, $payment_gateway_commission_id)
{
	$sql_query = "SELECT payment_gateway_details.gateway_user_id,payment_gateway_details.gateway_password,payment_gateway_commission.commission_id,payment_gateway_commission.commission_val_amt,payment_gateway_commission.commission_val_percentage FROM `payment_gateway_details` INNER JOIN payment_gateway_commission ON payment_gateway_details.payment_gateway_detail_id=payment_gateway_commission.payment_gateway_detail_id where 	payment_gateway_details.payment_gateway_detail_id =$payment_gateway_detail_id and payment_gateway_commission.payment_gateway_commission_id=$payment_gateway_commission_id";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if ($rows_found > 0) {
		$value = $result->fetch_assoc();
		$data =  $value;
		return $data;
	} else {
		return $data;
	}
}




function getContactUs($conn, $language_id, $loc_id)
{
	$sql_query = "SELECT org_name_$language_id as org_name,html_title_$language_id as html_title, address_lang_$language_id as org_address,email_id,phone,fb_url,insta_url,giftcard_url,trip_adviser,eat_url,tiktok_url,android_url,apple_url,googlemap_url,googlemap_embeded,latitude,longitude,randomcode,businessid FROM contact_us where loc_id=$loc_id";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$contact_us = [];
	if ($rows_found > 0) {
		while ($value = $result->fetch_assoc()) {
			$contact_us[] =  $value;
		}
		return $contact_us;
	} else {
		return $contact_us;
	}
}

function AllTypeEmailSend($conn, $loc_id, $send_email_id, $email_subject, $email_message, $mail_bcc = false,$isDatabaseenc=0,$enc_key=0)
{
	$email_setting_sql = "select * from email_settings where loc_id=$loc_id";
	$stmt = $conn->prepare($email_setting_sql);
	$stmt->execute();
	$email_result = $stmt->get_result();
	$emailvalue = $email_result->fetch_assoc();
if($isDatabaseenc==1)
{
	$email_host = decryptPasswithkey($emailvalue['email_host'],$enc_key);
	$system_mail_id = decryptPasswithkey($emailvalue['system_mail_id'],$enc_key);
	$email_password = decryptPasswithkey($emailvalue['password'],$enc_key);
	}
	else{
		$email_host = $emailvalue['email_host'];
	$system_mail_id = $emailvalue['system_mail_id'];
	$email_password = $emailvalue['password'];
	}
	$email_subject = '=?UTF-8?B?' . base64_encode($email_subject) . '?=';

	$mail = new PHPMailer();
	$mail->IsSMTP();
	$mail->SMTPAuth = true;
	$mail->Host = $email_host;
	$mail->Username = $system_mail_id;
	$mail->Password = $email_password;
	$mail->From = $system_mail_id;
	$mail->FromName = $system_mail_id;

	if ($mail_bcc) {
		if (!empty($emailvalue['bcc_email'])) {

			$bcc_mail_arr = explode(',', $emailvalue['bcc_email']);

			foreach ($bcc_mail_arr as $each_mail) {
				$mail->AddBCC($each_mail);
			}
		}
	}
	$mail->AddAddress($send_email_id);

	$mail->Subject = $email_subject;
	$mail->Body = $email_message;
	$mail->WordWrap = 50;
	$mail->IsHTML(true);

	$str1 = "gmail.com";
	$str2 = strtolower($system_mail_id);

	if (strstr($str2, $str1)) {
		$mail->SMTPSecure = 'ssl';
		$mail->Port = 465;
		if (!$mail->Send()) {
			return 0; //email not send
		} else {
			return 1; // email send
		}
	} else {
		$mail->Port = 25;
		if (!$mail->Send()) {
			return 0; //email not send
		} else {
			return 1; // email send
		}
	}
}

function AllTypeSmsSend($conn, $loc_id, $sms_message, $user_phone)
{
	$sms_setting_sql = "select * from sms_api_settting where sms_status=1 and loc_id=$loc_id";
	$stmt = $conn->prepare($sms_setting_sql);
	$stmt->execute();
	$sms_result = $stmt->get_result();
	$smsvalue = $sms_result->fetch_assoc();

	$sms_id = $smsvalue['sms_id'];
	$api_token = $smsvalue['sms_key'];
	$sms_username = $smsvalue['sms_username'];


	if ($sms_id == 2) //gatewayapi sms
	{
		header('Content-Type: text/html; charset=utf-8');
		$sms_api_url = "https://gatewayapi.com/rest/mtsms";

		$msg = $sms_message;
		$phone = $user_phone;
		$query = http_build_query(array(
			'token' => $api_token,
			'sender' => $sms_username,
			'message' => $msg,
			'recipients.0.msisdn' => '358' . $phone,
			//'recipients.0.msisdn' => '91'.$phone,
		));
		return  $result = file_get_contents('https://gatewayapi.com/rest/mtsms?' . $query);
	}
}

function getGenralSettingDetails($conn, $loc_id)
{
	$sql_query = "SELECT online_ordering_feature,pre_ordering_feature,home_delivery_feature,spam_email_sms,sms_confirmation_order,	sms_setordertime,sms_ontheway,Bonus_feature,pub_menu_status,item_special_descp_box_status,base_on_delivery_time_shop_open_feature,base_on_delivery_time_shop_close_feature,google_apikey_status,google_apikey,mail_order_cancelled,mail_ontheway,mail_settimeout,fcm_serverKey,firebase_notification_feature FROM general_settings where loc_id=$loc_id";
	$stmt = $conn->prepare($sql_query);
	$stmt->execute();
	$result = $stmt->get_result();
	$rows_found = $result->num_rows;
	$data = [];
	if ($rows_found > 0) {
		$value = $result->fetch_assoc();
		$data =  $value;
		return $data;
	} else {
		return $data;
	}
}




function rec_order_data($conn)
{
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$s_items = "select orders.*, users.first_name, users.last_name, users.phone FROM orders left JOIN users ON users.id= orders.user_id   where ontheway_alert=0 and  (orders.table_status=8) AND (status !=0 AND status !=3  AND status !=5 )  AND date(order_date) ='" . $date . "'  and orders.loc_id='$_SESSION[loc_id]' order by orders.order_id desc ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function all_rec_order_data($conn, $order_view_type)
{
	//echo $order_view_type;
	date_default_timezone_set("Europe/Helsinki");
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	//$date = date('Y-m-d', strtotime(date('Y-m-d'). " - 1 days")); //time() is default so you dont need to specify.
	$dayofweek = date('N', strtotime(date("Y-m-d")));
	$sql_time = "select * from visiting_timings where dayname='" . $dayofweek . "' and loc_id=$_SESSION[loc_id]";
	$res_time = mysqli_query($conn, $sql_time);
	$rows_time = mysqli_fetch_array($res_time);
	$new_from = $date . ' ' . $rows_time["fromtime"];
	$new_to = $date . ' ' . $rows_time["totime"];
	if ($rows_time["nextday"] == 1) {
		$dt = date('Y-m-d', strtotime(' +1 day'));
		$new_to = $dt . ' ' . $rows_time["totime"];
	}


	/*if($order_view_type == '1')
	{
			$cond="(orders.status=2 or orders.status=1) AND (table_status='1' OR table_status=2 OR table_status=8 )  AND order_type !='1'";
	}
	else {
		
					$cond="(orders.table_status=8)  AND (status !=0 AND status !=3)";
	}*/
	$cond = "(orders.status=2 ) AND (table_status='1' OR table_status=2 OR table_status=8 )  AND order_type ='1'";

	$item_ids = '';
	//AND order_datetime>='$new_from' AND order_datetime <='$new_to'
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$s_items = "select orders.*, users.first_name, users.last_name, users.phone FROM orders left JOIN users ON users.id= orders.user_id  where  $cond AND order_datetime>='$new_from' AND order_datetime <='$new_to'  and orders.loc_id='$_SESSION[loc_id]' order by orders.order_datetime desc ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}



function all_rec_order_data_yesterday($conn, $order_view_type)
{
	//echo $order_view_type;
	date_default_timezone_set("Europe/Helsinki");
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$date = date('Y-m-d', strtotime(' -1 day')); //time() is default so you dont need to specify.
	$dayofweek = date('N', strtotime(date("Y-m-d")));
	$sql_time = "select * from visiting_timings where dayname='" . $dayofweek . "' and loc_id=$_SESSION[loc_id]";
	$res_time = mysqli_query($conn, $sql_time);
	$rows_time = mysqli_fetch_array($res_time);
	$new_from = $date;
	$new_to = $date;

	if ($rows_time["nextday"] == 1) {
		$dt = date('Y-m-d', strtotime(' +1 day'));
		$new_to = $dt;
	}


	/*if($order_view_type == '1')
	{
			$cond="(orders.status=2 or orders.status=1) AND (table_status='1' OR table_status=2 OR table_status=8 )  AND order_type !='1'";
	}
	else {
		
					$cond="(orders.table_status=8)  AND (status !=0 AND status !=3)";
	}*/
	$cond = "(orders.status=2 ) AND (table_status='1' OR table_status=2 OR table_status=8 )  AND order_type ='1'";

	$item_ids = '';
	//AND order_datetime>='$new_from' AND order_datetime <='$new_to'
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$s_items = "select orders.*, users.first_name, users.last_name, users.phone FROM orders left JOIN users ON users.id= orders.user_id  where  $cond AND order_date>='$new_from' AND order_date <='$new_to' and orders.loc_id='$_SESSION[loc_id]' order by orders.order_datetime desc ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function all_pre_order_data($conn, $order_view_type)
{
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.


	/*$s_items="SELECT 
orders.*, users.first_name, users.last_name, users.phone 
FROM orders 
INNER JOIN  users ON users.id= orders.user_id WHERE payment_status != 1 AND 
(
(orders.order_type = 2 AND orders.table_status = 2 or orders.table_status = 5 or orders.table_status = 3) 
OR (orders.order_type = 1 AND orders.status=1 AND (orders.table_status=1 OR orders.table_status=2) ) OR ((orders.order_type = 3 or orders.order_type = 4) AND (orders.status=2 or orders.status=4 ) AND (orders.table_status=1 OR orders.table_status=2) )
) ORDER BY orders.order_datetime DESC";*/

	$s_items = "SELECT 
orders.*, users.first_name, users.last_name, users.phone 
FROM orders 
INNER JOIN  users ON users.id= orders.user_id WHERE payment_status != 1 AND status=1 and per_order_booking=1  and orders.loc_id='$_SESSION[loc_id]'
 ORDER BY orders.order_datetime DESC";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);

	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

//latest update --08-04-2020(navjeet)
function all_cancelled_order_data($conn, $order_view_type)
{

	date_default_timezone_set("Europe/Helsinki");
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$dayofweek = date('N', strtotime(date("Y-m-d")));
	$sql_time = "select * from visiting_timings where dayname='" . $dayofweek . "' and loc_id='$_SESSION[loc_id]'";
	$res_time = mysqli_query($conn, $sql_time);
	$rows_time = mysqli_fetch_array($res_time);
	$new_from = $date . ' ' . $rows_time["fromtime"];
	$new_to = $date . ' ' . $rows_time["totime"];
	if ($rows_time["nextday"] == 1) {
		$dt = date('Y-m-d', strtotime(' +1 day'));
		$new_to = $dt . ' ' . $rows_time["totime"];
	}

	$cond = "(orders.status=5 ) AND (table_status='1' OR table_status=2 OR table_status=8 )  AND order_type ='1'";

	$item_ids = '';

	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$s_items = "select orders.*, users.first_name, users.last_name, users.phone FROM orders left JOIN users ON users.id= orders.user_id  where  $cond AND order_datetime>='$new_from' AND order_datetime <='$new_to'  and orders.loc_id='$_SESSION[loc_id]' order by orders.order_datetime desc ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}
//latest update --08-04-2020(navjeet)
function all_fail_order_data($conn)
{
	date_default_timezone_set("Europe/Helsinki");
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	//$date=date('Y-m-d', strtotime(' -1 day'));
	$dayofweek = date('N', strtotime(date("Y-m-d")));
	$sql_time = "select * from visiting_timings where dayname='" . $dayofweek . "' and loc_id='$_SESSION[loc_id]'";
	$res_time = mysqli_query($conn, $sql_time);
	$rows_time = mysqli_fetch_array($res_time);
	$new_from = $date . ' ' . $rows_time["fromtime"];
	$new_to = $date . ' ' . $rows_time["totime"];
	if ($rows_time["nextday"] == 1) {
		$dt = date('Y-m-d', strtotime(' +1 day'));
		$new_to = $dt . ' ' . $rows_time["totime"];
	}

	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify. 
	$s_items = "select orders.*, users.first_name, users.last_name, users.phone FROM orders left JOIN users ON users.id= orders.user_id  where ((orders.payment_status =1 OR orders.status=0 or orders.status=3 or orders.status=6 OR ((payment_mode =4 or payment_mode =5 ) AND ( status !=2)  AND ( payment_status=0 OR RETURN_AUTHCODE is NULL)) )) 	AND order_datetime>='$new_from' AND order_datetime <='$new_to'  and orders.loc_id='$_SESSION[loc_id]' order by orders.order_id desc ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}
function p_gateway_name_n($conn, $payment_mode)
{
	$qr_p_gateway_name_n = "select payment_gateway_name as payment_gateway_title from payment_gateway_setting where `Id`='$payment_mode' and 	payment_gateway_status=1  and loc_id='$_SESSION[loc_id]'";
	$r_qr_p_gateway_name_n = mysqli_query($conn, $qr_p_gateway_name_n);
	$row_r_qr_p_gateway_name_n = mysqli_fetch_array($r_qr_p_gateway_name_n);
	return $row_r_qr_p_gateway_name_n['payment_gateway_title'];
}

function order_details($conn, $oid)
{

	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	//	$s_items = "select a.*,b.first_name,b.last_name,b.phone from  orders a ,users b where a.user_id=b.id and a.order_id='$oid'";

	$s_items = "select orders.*, users.first_name, users.last_name, users.phone FROM orders left JOIN users ON users.id= orders.user_id where orders.order_id='$oid'  and orders.loc_id='$_SESSION[loc_id]'";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//echo $rowcount.'kkk';
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function food_details($conn, $oid, $lang_id, $ordertype)
{
	$con = "";
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	if ($ordertype == "kitchen_limited") {

		$con = 'AND print=0';
	}
	$s_items = $sql_food = "SELECT
`master_food_items`.`food_item_id`,
order_food_item_id,
`master_food_items`.`food_item_name_" . $lang_id . "` AS `food_item_name`,
`order_food_items`.`food_test_id`,
`master_food_items`.`food_item_image`,
`master_food_test`.`food_test_images`,
`master_food_test`.`food_test_" . $lang_id . "` AS `food_test`,
`master_food_varient_options`.`food_varient_option_title_" . $lang_id . "` AS `size_name`,
`order_food_items`.`basic_price`,
		  `order_food_items`.`total_basic_price`,
		  `order_food_items`.`item_order_qty`,
		  `order_food_items`.`order_id`,
		  `order_food_items`.`food_itme_status`,
		  `order_food_items`.`food_extratext`,
		  `order_food_items`.`tax_rate`,
		  `order_food_items`.`tax_amount`,
		  `order_food_items`.`discount_rate`,
		  `order_food_items`.`discount_amt`,
		  `order_food_items`.`discount_apply`,
		  `order_food_items`.`basic_price_after_dis`,
		  `order_food_items`.`offer_ui_design_status`,
`master_food_varient_options`.`food_varient_option_id`
FROM
`master_food_items`
LEFT JOIN `order_food_items` ON `order_food_items`.`food_item_id` =
`master_food_items`.`food_item_id`
LEFT JOIN `master_food_test` ON `order_food_items`.`food_test_id` =
`master_food_test`.`food_test_id`
LEFT JOIN `master_food_varient_options` ON `order_food_items`.`size_id` =
`master_food_varient_options`.`food_varient_option_id` where order_id = $oid $con  and master_food_items.loc_id='$_SESSION[loc_id]'  order by order_food_item_id ASC ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//echo $rowcount.'kkk';
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function order_varient($conn, $item_id, $lang_id)
{
	$sql_ordervarient = "SELECT
	master_food_varient_options.food_varient_option_title_$lang_id AS food_varient_option_title,
	`order_varients`.`food_varient_option_price`,
	`order_varients`.`item_adding_category`
	FROM
	`order_varients`
	INNER JOIN `master_food_varient_options`
	ON `order_varients`.`food_varient_option_id` =
	`master_food_varient_options`.`food_varient_option_id` where order_food_item_id = '$item_id' and  order_varients.loc_id='$_SESSION[loc_id]' order by item_adding_category,food_varient_option_title_$lang_id";
	$r_items = mysqli_query($conn, $sql_ordervarient);
	$rowcount = mysqli_num_rows($r_items);
	//echo $rowcount.'kkk';
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

// booking fuction start
function new_booking_order_data($conn)
{
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$s_items = "select orders .*,users.first_name,users.last_name,users.phone,table_arrangement.table_id,table_title_1 from orders left join users ON users.id= orders.user_id left join  table_arrangement ON table_arrangement.table_id= orders.table_id  where (orders.table_status=1 OR orders.table_status=2) AND status =1  and order_type !='1' and orders.loc_id='$_SESSION[loc_id]' order by order_datetime ASC ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}
function rec_book_order_data($conn)
{
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$s_items = "select orders .*,users.first_name,users.last_name,users.phone from orders left join users ON users.id= orders.user_id  where (orders.table_status=1 OR orders.table_status=2) AND status =2  and order_type !='1' and orders.loc_id='$_SESSION[loc_id]' order by order_datetime ASC ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function booked_table_data($conn, $table_id)
{
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$qr_table = "select table_title_1  from table_arrangement where table_id IN($table_id) and loc_id='$_SESSION[loc_id]'";
	$r_table = mysqli_query($conn, $qr_table);
	while ($rows_table = mysqli_fetch_array($r_table)) {
		$table_title_1 .= $rows_table['table_title_1'] . ',';
	}
	$table = rtrim($table_title_1, ',');
	if ($table != "") {
		return $table;
	} else {
		return '';
	}
}

function time_interval($conn, $day_number)
{
	if ($day_number != "") {
		$dayOfWeek = $day_number;
	} else {
		$dayOfWeek = date('N');
	}


	$qr_time = "select * from visiting_timings where dayname='$dayOfWeek'  and loc_id='$_SESSION[loc_id]'";
	$res = mysqli_query($conn, $qr_time);
	$row_data = mysqli_fetch_array($res);
	$totime_p = explode(':', $row_data['totime']);
	$totime = $totime_p[0] . ":" . $totime_p[1];

	$fromtime_p = explode(':', $row_data['fromtime']);
	$fromtime = $fromtime_p[0] . ":" . $fromtime_p[1];
	return $fromtime . '-' . $totime;
}

function get_table_list($conn)
{


	$dayOfWeek = date('N');
	$qr_time = "select * from table_arrangement";
	$res = mysqli_query($conn, $qr_time);

	$data = array();
	while ($rows = mysqli_fetch_assoc($res)) {
		$data[] = $rows;
	}
	return $data;
}

function get_booked_table($conn, $date_this)
{
	// $s_items = "select table_id from orders  where (orders.table_status=1 OR orders.table_status=2) AND status =2  and order_type !='1' AND (order_datetime ='".$date_this."' OR to_time ='".$date_this."'  )  order by table_id DESC ";
	$s_items = "select table_id from orders  where (orders.table_status=1 OR orders.table_status=2) AND status =2  and order_type !='1' AND '$date_this' BETWEEN order_datetime AND to_time  and loc_id='$_SESSION[loc_id]'  order by table_id DESC ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	$data = "";
	while ($rows = mysqli_fetch_assoc($r_items)) {
		$data .= $rows['table_id'] . ',';
	}
	return rtrim($data, ',');
}

function get_booked_table_orderid($conn, $date_this, $table_id)
{
	$s_items = "select  SUBSTRING(rand_order_no FROM 4) as o_no,order_id from orders  where (status !=0 OR status !=3 ) and order_type !='1' AND ('$date_this' BETWEEN order_datetime AND to_time ) and  FIND_IN_SET('$table_id', table_id)  and loc_id='$_SESSION[loc_id]'";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$data = array();
	while ($rows = mysqli_fetch_assoc($r_items)) {
		$data[] = $rows;
	}
	return $data;
}
function get_booked_table_id_in_selected_timeslot($conn, $book_fromtime, $book_totime)
{
	$used_table_id_p = "";
	$check_bookdate = "SELECT table_id,order_id,order_datetime FROM `orders` WHERE (order_datetime BETWEEN '$book_fromtime' AND '$book_totime' OR to_time BETWEEN  '$book_fromtime' AND '$book_totime') and	order_type !=1 and status=2 and table_status !='8' and table_id!=''  and loc_id='$_SESSION[loc_id]'";
	$rs_check_bookdate = mysqli_query($conn, $check_bookdate);
	$num_bookdate = mysqli_num_rows($rs_check_bookdate);
	if ($num_bookdate > 0) {
		$used_table_id_p = "";
		while ($row_bookdate = mysqli_fetch_array($rs_check_bookdate)) {
			$used_table_id_p	.= $row_bookdate['table_id'] . ',';
			//$dt_split=explode(' ',$row_bookdate['order_datetime']);
			////$dtp = explode(':',$dt_split[1]);
			//$dt_time .= $dtp[0].':'.$dtp[1].',';
			//$dt .=$dt_time.',';

		}
		$used_table_id = rtrim($used_table_id_p, ',');
	}
	return $used_table_id;
}

function order_data($conn, $order_id)
{
	$check_order_data = "SELECT * FROM `orders` where order_id='$order_id'  and loc_id='$_SESSION[loc_id]'";
	$r_check_order_data = mysqli_query($conn, $check_order_data);
	$rowcount = mysqli_num_rows($r_check_order_data);
	$rows_check_order_data = mysqli_fetch_assoc($r_check_order_data);
	$data[] = $rows_check_order_data;
	return $data;
}

function update_food_items($conn, $order_id)
{
	$qr_up = mysqli_query($conn, "update order_food_items set print=1 where order_id='$order_id' AND print=0  and loc_id='$_SESSION[loc_id]'");
}
function all_onprogress_orders_data($conn)
{
	date_default_timezone_set("Europe/Helsinki");
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$dayofweek = date('N', strtotime(date("Y-m-d")));
	$sql_time = "select * from visiting_timings where dayname='" . $dayofweek . "' and loc_id='$_SESSION[loc_id]'";
	$res_time = mysqli_query($conn, $sql_time);
	$rows_time = mysqli_fetch_array($res_time);
	$new_from = $date . ' ' . $rows_time["fromtime"];
	$new_to = $date . ' ' . $rows_time["totime"];
	if ($rows_time["nextday"] == 1) {
		$dt = date('Y-m-d', strtotime(' +1 day'));
		$new_to = $dt . ' ' . $rows_time["totime"];
	}

	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$s_items = "select orders.*, users.first_name, users.last_name, users.phone FROM orders left JOIN users ON users.id= orders.user_id  LEFT JOIN order_food_items ON order_food_items.order_food_item_id=orders.order_id where ((orders.status=0 AND orders.table_status=0) OR (orders.status=0 AND orders.table_status=1))  	AND order_datetime>='$new_from' AND order_datetime <='$new_to'   and orders.loc_id='$_SESSION[loc_id]'  order by orders.order_id desc ";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function count_prebookaccepted_order($conn)
{
	date_default_timezone_set("Europe/Helsinki");
	$current_time = date('Y-m-d G:i');
	$current_time_beforehalfanhour = strtotime("+ 60 minutes", strtotime($current_time));
	$c_time_beforehalfanhour = date('Y-m-d G:i', $current_time_beforehalfanhour);
	$qr = "select count(order_id) as count	from 	orders where (order_type =3 OR order_type=4) AND table_status AND ('$c_time_beforehalfanhour' >= order_datetime AND '$c_time_beforehalfanhour'<= to_time ) and status=2  and loc_id='$_SESSION[loc_id]'";
	$r_items = mysqli_query($conn, $qr);
	$rowcount = mysqli_fetch_assoc($r_items);
	return $rowcount['count'];
}


function email_footer($conn, $conn_super, $lang_code)
{
	$all_labels = get_labels($conn_super, $lang_code);

	$sqlcon = "select * from contact_us";
	$resultcon = mysqli_query($conn, $sqlcon);
	$rowscon = mysqli_fetch_array($resultcon);
	$str1 = array_search('thank regard', array_column($all_labels, 'header', 'title')) . "<br>";
}
function get_label_from_superadmin_alert($conn, $lang_id)
{

	$sqlc_notice = "select header,title from admin_dashboard_content where lang_code ='$lang_id'and type='2' ";
	$resultc_sqlc_notice = mysqli_query($conn, $sqlc_notice);
	$num_sqlc_notice = mysqli_num_rows($resultc_sqlc_notice);
	//$rows = mysqli_fetch_assoc($resultc_sqlc_notice);
	//	return $rows;

	if ($num_sqlc_notice) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($resultc_sqlc_notice)) {
			//$data = $rows;
			array_push($data, $rows);
		}
		return $data;
	} else {
		return '';
	}
}
function get_response_time_pre_del($conn, $del_type)
{
	$qr = mysqli_query($conn, "select response_pre_order_time from settings where `id`='$del_type'  and loc_id='$_SESSION[loc_id]'");
	$res = mysqli_fetch_array($qr);
	return $res['response_pre_order_time'];
}
function menu_item($conn, $cat_id)
{
	//$data = array();
	$qr_ctg_varriety_type = mysqli_query($conn, "SELECT master_food_category.food_item_category_id FROM `master_food_category` INNER JOIN master_food_items ON master_food_category.food_item_category_id=master_food_items.food_item_category_id WHERE catg_variant_type_id='$cat_id'  and master_food_category.loc_id='$_SESSION[loc_id]'");
	return mysqli_num_rows($qr_ctg_varriety_type);
}

function makeRequest($url, $type, $content = "", $conn)
{
	ini_set('display_errors', 1);
	$get_patrtail_id = mysqli_query($conn, "SELECT `Id`,`payment_gateway_userid`, `payment_gateway_password` FROM `payment_gateway_setting` WHERE `payment_gateway_status`=1  and loc_id='$_SESSION[loc_id]'");
	$row_get_patrtail_id = mysqli_fetch_array($get_patrtail_id);
	//	return  mysqli_num_rows($get_patrtail_id);
	//die();
	$payment_gateway_userid = $row_get_patrtail_id['payment_gateway_userid'];
	$payment_gateway_password = $row_get_patrtail_id['payment_gateway_password'];

	$md5content = base64_encode(hash("md5", $content, true));
	$timestamp = time();
	//die();
	//$merchant_id = '54243';	
	//$secret = 'xdFgLi8v8ESjq99Cw9bzTmQnhz7HeX';

	//$merchant_id = '58549';	// pizzaservicehervanta.fi/
	// $secret = 'sfH97s1eB9rDC3ngDQwcyfsB6iqy7W';

	$merchant_id = $payment_gateway_userid;	// pizzaservicehervanta.fi/
	$secret = $payment_gateway_password;


	$stringtohash = $type . "\n" .
		$url . "\n" .
		"PaytrailMerchantAPI " . $merchant_id . "\n" .
		$timestamp . "\n" .
		$md5content;

	$hash = hash_hmac("sha256", $stringtohash, $secret, true);

	$base64 =  base64_encode($hash);

	$curl = curl_init("https://api.paytrail.com" . $url);
	curl_setopt($curl, CURLOPT_HTTPGET, 1);

	$headers = [
		"Timestamp: " . $timestamp,
		"Content-MD5: " . $md5content,
		"Authorization: PaytrailMerchantAPI " . $merchant_id . ":" . $base64
	];

	if (!empty($content)) {
		curl_setopt($curl, CURLOPT_POSTFIELDS, $content);
	}
	curl_setopt($curl, CURLOPT_RETURNTRANSFER, 1);
	curl_setopt($curl, CURLOPT_HTTPHEADER, $headers);

	$result = curl_exec($curl);

	return $result;
}

function update_orderstatus_api($conn, $orde_no, $status, $paymentMethodId)
{
	if ($status == 1) // paid
	{
		$payment_status = 2;
	} else if ($status == 3) // cancel payment
	{
		$payment_status = 1;
	} else if ($status == 6) // waiting payment
	{
		$payment_status = 1;
	} else {
		$payment_status = 0;
	}


	$qr_up = mysqli_query($conn, "update orders set status=$status,table_status=1,payment_status='$payment_status',gateway_api_check=gateway_api_check+1,gateway_payment_method_id='$paymentMethodId' where rand_order_no='$orde_no'  and loc_id='$_SESSION[loc_id]'");
	$effec = mysqli_affected_rows($conn);
	if ($effec > 0 and $status == 1) {
		//echo $temp_data=$conn;
		include_once("movetoorderlist_api.php");
	}
}
// send email to superadmin when gaetway exception got
function send_email_to_superadmin($conn, $rand_order_no, $client_name, $return_query)
{
	$return_queryr = json_decode($return_query, true);
	$error_title = $return_queryr['error']['title'];
	$error_title_id = "";
	if ($error_title == "invalid-order-number") {
		$error_title_id = 11;
	}
	$qu_updatep = mysqli_query($conn, "update orders set temp_payment_status='$error_title_id'  where rand_order_no='$rand_order_no'  and loc_id='$_SESSION[loc_id]'");



	Date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	$current = date('Y-m-d H:i:s');
	$headers = "MIME-Version: 1.0" . "\r\n";
	$headers .= "Content-type:text/html;charset=UTF-8" . "\r\n";
	// More headers
	$sss = "select * from email_settings where id=1";
	$result2 = mysqli_query($conn, $sss);
	$rows2 = mysqli_fetch_array($result2);
	$email = $rows2["email"];
	$pass = $rows2["password"];
	$mail_server = $rows2["mail_server"];
	$email2 = $rows2["email2"];
	$email3 = $rows2["email3"];
	$system_mail_id = $rows2["system_mail_id"];
	$headers .= "From: <" . $system_mail_id . ">" . "\r\n";
	$headers .= "CC:navjeet.figstech@gmail.com" . "\r\n";
	$sub = "Gateway Exception Error found: on " . $current . " # " . $client_name;
	$str1 = "Gateway Exception Error found <br> <br>
	<b>Order no:</b> $rand_order_no <br>
	<b>website:</b> $client_name <br> <br>
	<b>Error:</b> $return_query;
	";
	$qr = mysqli_query($conn, "select gateway_exception_email_send from orders where rand_order_no='$rand_order_no'  and loc_id='$_SESSION[loc_id]'");
	$row = mysqli_fetch_array($qr);
	$gateway_exception_email_send = $row['gateway_exception_email_send'];
	if ($gateway_exception_email_send == 0) {
		if (mail('reports.finnapps@gmail.com', $sub, $str1, $headers)) {
			$qu_update = mysqli_query($conn, "update orders set gateway_exception_email_send=1 where rand_order_no='$rand_order_no'  and loc_id='$_SESSION[loc_id]'");
		}
	}


	//mail('navjeet.figstech@gmail.com',$sub,$str1,$headers);

}
// START visma check 6-4-2021 (navjeet)
function update_orderstatus_api_visma($conn, $orde_no, $status, $paymentMethodId)
{
	if ($status == 0) // success payment
	{
		$order_status = 1;
		$temp_status = $status;
		$payment_status = 2;
	} else if ($status == 4) // not retrun from bank
	{
		$order_status = 6; // waiting payment
		$temp_status = $status;
		$payment_status = 1;
	} else // fail payment
	{
		//$order_status=1;// waiting payment
		$order_status = 6; // waiting payment
		$temp_status = $status;
		$payment_status = 1;
	}

	$fail_order_api_check_datetime = date('Y-m-d H:i:s');



	$qr_up = mysqli_query($conn, "update orders set status=$order_status,table_status=1,payment_status='$payment_status',gateway_api_check=gateway_api_check+1,gateway_payment_method_id='$paymentMethodId',temp_payment_status='$temp_status',	fail_order_api_check_datetime='$fail_order_api_check_datetime' where rand_order_no='$orde_no'  and loc_id='$_SESSION[loc_id]'");
	$effec = mysqli_affected_rows($conn);
	if ($effec > 0 and $status == 0) {
		//	echo "success update querry";
		// $temp_data=$conn;
		include_once("movetoorderlist_api.php");
	}
}

function update_orderstatus_api_visma_old($conn, $orde_no, $status, $paymentMethodId)
{
	//$status ==6)// waiting payment
	if ($status == 0) // paid
	{
		$payment_status = 2; // success order
	} else {
		$payment_status = 1; // fail payment
	}

	// order status define
	if ($status == 0) {
		$status = 1; // success order
		$temp_status = $status;
	} else if ($status == 4) // not retrun from bank
	{
		$status = 6; // waiting payment
		$temp_status = $status;
	} else {
		$status = 1;
		$temp_status = $status;
	}


	$qr_up = mysqli_query($conn, "update orders set status=$status,table_status=1,payment_status='$payment_status',gateway_api_check=gateway_api_check+1,gateway_payment_method_id='$paymentMethodId',temp_payment_status='$temp_status' where rand_order_no='$orde_no'  and loc_id='$_SESSION[loc_id]'");
	$effec = mysqli_affected_rows($conn);
	if ($effec > 0 and $status == 0) {
		//echo $temp_data=$conn;
		include_once("movetoorderlist_api.php");
	}
}
// END visma check 6-4-2021 (navjeet)
//start search by order no PTC-733 (navjeet:29-4-2021)
function order_details_by_orderno($conn, $ordernumber)
{

	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	mysqli_set_charset($conn, 'utf8');
	mysqli_query($conn, "set character_set_results='utf8'");
	mysqli_query($conn, "SET SESSION collation_connection ='utf8_general_ci'");
	$item_ids = '';
	date_default_timezone_set("Europe/Helsinki");
	$date = date("Y-m-d"); //time() is default so you dont need to specify.
	//	$s_items = "select a.*,b.first_name,b.last_name,b.phone from  orders a ,users b where a.user_id=b.id and a.order_id='$oid'";

	$s_items = "select orders.*, users.first_name, users.last_name, users.phone,users.email FROM orders left JOIN users ON users.id= orders.user_id where orders.rand_order_no='$ordernumber'  and orders.loc_id='$_SESSION[loc_id]'";

	$r_items = mysqli_query($conn, $s_items);
	$rowcount = mysqli_num_rows($r_items);
	//echo $rowcount.'kkk';
	//$rows = mysqli_fetch_assoc($r_items);
	if ($rowcount) {
		$data = array();
		while ($rows = mysqli_fetch_assoc($r_items)) {
			$data[] = $rows;
		}
		return $data;
	} else {
		return '';
	}
}

function getDayname($dayno, $all_labels)
{
	if ($dayno == 1) {
		$dayname =  array_search('title_monday', array_column($all_labels, 'header', 'title'));
	} else if ($dayno == 2) {
		$dayname =  array_search('title_tuesday', array_column($all_labels, 'header', 'title'));
	} else if ($dayno == 3) {
		$dayname =  array_search('title_wednesday', array_column($all_labels, 'header', 'title'));
	} else if ($dayno == 4) {
		$dayname =  array_search('title_Thursday', array_column($all_labels, 'header', 'title'));
	} else if ($dayno == 5) {
		$dayname =  array_search('title_Friday', array_column($all_labels, 'header', 'title'));
	} else if ($dayno == 6) {
		$dayname =  array_search('title_Saturday', array_column($all_labels, 'header', 'title'));
	} else {
		$dayname =  array_search('title_Sunday', array_column($all_labels, 'header', 'title'));
	}
	return $dayname;
}
//update location_id by sourabh 14-06-2022


function getReportAllTotalSuccessOrder($conn,$loc_id,$cond_arr)
			{
				 $sql_query = "Select count(order_id) as total_order_count,sum(final_payable_amount) as total_final_payable_amount,sum(total_item_tax_amt) as total_item_tax_amt,sum(home_del_charges_tax_amount) as total_home_del_charges_tax_amount,sum(total_item_tax_amt+home_del_charges_tax_amount) as total_tax_amount from orders where loc_id=$loc_id $cond_arr";
				$stmt = $conn->prepare($sql_query);
                $stmt->execute();
				$result = $stmt->get_result();
				$value = $result->fetch_assoc();
				$resultdata=[];
				return $resultdata =  $value;
			}

			


			function getReportTotalDiscountSuccessOrder($conn,$loc_id,$cond_arr)
			{
				$sql_query = "select sum(discount_amt+pickup_offer_amount+reg_offer_amount) as total_all_discount,count(order_id) as totaldiscount_order_count from orders WHERE (discount_amt>0 or pickup_offer_amount>0 or reg_offer_amount>0) and loc_id=$loc_id $cond_arr";
				$stmt = $conn->prepare($sql_query);
                $stmt->execute();
				$result = $stmt->get_result();
				$value = $result->fetch_assoc();
				$resultdata=[];
				return $resultdata =  $value;
			}

			function getReportTotalcouponSuccessOrder($conn,$loc_id,$cond_arr)
			{
				$sql_query = "select sum(coupon_discount) as total_coupon_discount,count(order_id) as totalcoupon_order_count from orders WHERE coupon_discount>0 and loc_id=$loc_id $cond_arr";
				$stmt = $conn->prepare($sql_query);
                $stmt->execute();
				$result = $stmt->get_result();
				$value = $result->fetch_assoc();
				$resultdata=[];
				return $resultdata =  $value;
			}

			function getReportTotalBonusSuccessOrder($conn,$loc_id,$cond_arr)
			{
				$sql_query = "select sum(bonus_value_used) as total_bonus_value_used,count(order_id) as totalbonus_order_count from orders WHERE bonus_value_used>0 and loc_id=$loc_id $cond_arr";
				$stmt = $conn->prepare($sql_query);
                $stmt->execute();
				$result = $stmt->get_result();
				$value = $result->fetch_assoc();
				$resultdata=[];
				return $resultdata =  $value;
			}

			

			function getPaymentmodewithTotalOrder($conn,$loc_id,$cond_arr)
			{
				 $sql_query ="Select count(order_id) as total_order_count,sum(final_payable_amount) as total_final_payable_amount,orders.payment_mode_id,payment_mode_master.payment_mode_lang_1,payment_mode_master.payment_mode_lang_2 from orders INNER JOIN payment_mode_master ON payment_mode_master.payment_mode_id =orders.payment_mode_id   where orders.loc_id=$loc_id $cond_arr GROUP BY orders.payment_mode_id";
				$stmt = $conn->prepare($sql_query);
                $stmt->execute();
				$result = $stmt->get_result();
				$resultdata=[];
				while($value = $result->fetch_assoc())
				{
					 $resultdata[] =  $value;
				}
				return $resultdata;
			}

			function getDeliveryTypewithTotalOrder($conn,$loc_id,$cond_arr)
			{
				 $sql_query ="Select count(order_id) as total_order_count,sum(final_payable_amount) as total_final_payable_amount,orders.delivery_type_id,delivery_type_master.delivery_type_1 as delivery_type_label,delivery_type_master.delivery_type_2  from orders INNER JOIN delivery_type_master ON delivery_type_master.delivery_type_id =orders.delivery_type_id where orders.loc_id=$loc_id $cond_arr GROUP BY orders.delivery_type_id";
				$stmt = $conn->prepare($sql_query);
                $stmt->execute();
				$result = $stmt->get_result();
				$resultdata=[];
				while($value = $result->fetch_assoc())
				{
					 $resultdata[] =  $value;
				}
				return $resultdata;
			}

			function getActiveLocationDetail($conn,$loc_id)
			{
				$sql_query="SELECT * FROM location_master where loc_id=$loc_id";
				$stmt = $conn->prepare($sql_query);
                $stmt->execute();
				$result = $stmt->get_result();
				$value = $result->fetch_assoc();
				$resultdata=[];
				return $resultdata =  $value;
			}


function send_fcm_notification($serverKey, $deviceToken,$notification_title,$notification_msg,$notification_image = "") {
    $message = [
        'title' => $notification_title,
        'body' => $notification_msg,
        'image' => $notification_image
    ];

    // $fields = [
    //     'to' => $deviceToken,
    //     'priority' => 'high',
    //     'notification' => $message,
    // ];

    // $headers = [
    //     'Authorization: key=' . $serverKey,
    //     'Content-Type: application/json',
    // ];


    $fields = [
        'to' => "$deviceToken",
        'priority' => 'high',
        'notification' => $message,
    ];

    $headers = [
        'Authorization: key=' . "$serverKey",
        'Content-Type: application/json',
    ];

    $ch = curl_init();
    curl_setopt($ch, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
    curl_setopt($ch, CURLOPT_POST, true);
    curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
    curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
    curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
    curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

   $result = curl_exec($ch);
    // echo $result;
//print_r($ch);
   /* if ($result === false) {
        echo 'Error: ' . curl_error($ch);
    } else {
        echo 'Notification sent successfully.';
    }*/

    curl_close($ch);
}

function send_fcm_notification_multi($serverKey, $topic, $message) {
  $fields = [
    'to' => '/topics/' . $topic,
    'priority' => 'high',
    'notification' => $message,
  ];

  $headers = [
    'Authorization: key=' . $serverKey,
    'Content-Type: application/json',
  ];

  $ch = curl_init();
  curl_setopt($ch, CURLOPT_URL, 'https://fcm.googleapis.com/fcm/send');
  curl_setopt($ch, CURLOPT_POST, true);
  curl_setopt($ch, CURLOPT_HTTPHEADER, $headers);
  curl_setopt($ch, CURLOPT_RETURNTRANSFER, true);
  curl_setopt($ch, CURLOPT_SSL_VERIFYPEER, false);
  curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($fields));

  $result = curl_exec($ch);

  if ($result === false) {
    echo 'Error: ' . curl_error($ch);
  } else {
    echo 'Notification sent successfully.';
  }

  curl_close($ch);
}


function isDataEncrypted($data)
{
  $decodedData = base64_decode($data, true);
  return ($decodedData !== false && base64_encode($decodedData) === $data);
}
function encryptPasswithkey16($string, $key)
{
  $sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';

  $sSalt = substr(hash('sha256', $sSalt, true), 0, 16); // Adjusted to 16 bytes
  $key = substr(hash('sha256', $key, true), 0, 16); // Ensure the key is 16 bytes

  // Combine salt and key
  $combined = $sSalt . $key;

  $method = 'aes-256-cbc';

  // Use the first 16 bytes of the combined string as the IV
  $iv = substr($combined, 0, 16);

  try {
    $encrypted = base64_encode(openssl_encrypt($string, $method, $key, OPENSSL_RAW_DATA, $iv));
    return $encrypted;
  } catch (Exception $e) {
    return 'Encryption error: ' . $e->getMessage();
  }
}

function decryptPasswithkey16($encryptedString, $key)
{
  $sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';

  $sSalt = substr(hash('sha256', $sSalt, true), 0, 16); // Adjusted to 16 bytes
  $key = substr(hash('sha256', $key, true), 0, 16); // Ensure the key is 16 bytes

  // Combine salt and key
  $combined = $sSalt . $key;

  $method = 'aes-256-cbc';

  // Use the first 16 bytes of the combined string as the IV
  $iv = substr($combined, 0, 16);

  try {
    $decrypted = openssl_decrypt(base64_decode($encryptedString), $method, $key, OPENSSL_RAW_DATA, $iv);
    return $decrypted !== false ? rtrim($decrypted) : 'Decryption failed';
  } catch (Exception $e) {
    return 'Decryption error: ' . $e->getMessage();
  }
}


function encryptPasswithkey($string, $key) {
    $sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';

    // Adjust salt to 16 bytes
    $sSalt = substr(hash('sha256', $sSalt, true), 0, 16);

    // Combine key with salt and hash them
    $key = substr(hash('sha256', $sSalt . $key, true), 0, 32);

    $method = 'aes-256-cbc';

    // Generate a secure IV
    // $iv = openssl_random_pseudo_bytes(openssl_cipher_iv_length($method));
    $iv = $sSalt;

    try {
        $encrypted = openssl_encrypt($string, $method, $key, OPENSSL_RAW_DATA, $iv);
        if ($encrypted === false) {
            throw new Exception('Encryption failed: ' . openssl_error_string());
        }

        // Combine the IV and the encrypted string
        $encrypted = base64_encode($iv . $encrypted);
        return $encrypted;
    } catch (Exception $e) {
        return 'Encryption error: ' . $e->getMessage();
    }
}



function decryptPasswithkey($encrypted, $key) {
    $sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';

    // Adjust salt to 16 bytes
    $sSalt = substr(hash('sha256', $sSalt, true), 0, 16);

    // Combine key with salt and hash them
    $key = substr(hash('sha256', $sSalt . $key, true), 0, 32);

    $method = 'aes-256-cbc';

    // Decode the base64-encoded string
    $encrypted = base64_decode($encrypted);

    // Extract the IV and the encrypted string
    $iv_length = openssl_cipher_iv_length($method);
    $iv = substr($encrypted, 0, $iv_length);
    $encrypted_string = substr($encrypted, $iv_length);

    try {
        $decrypted = openssl_decrypt($encrypted_string, $method, $key, OPENSSL_RAW_DATA, $iv);
        if ($decrypted === false) {
            throw new Exception('Decryption failed: ' . openssl_error_string());
        }
        return $decrypted;
    } catch (Exception $e) {
        return 'Decryption error: ' . $e->getMessage();
    }
}
