<?php 
ini_set('session.cookie_samesite', 'None');
ini_set('session.cookie_secure', TRUE);
include"connect_superadmin.php";

session_start();
$user_id=$_POST['user_id'];
date_default_timezone_set("Europe/Helsinki");
$date = date("Y-m-d"); //time() is default so you dont need to specify.
$current=date('Y-m-d H:i:s');

/*$_SESSION['common_admin_url']="https://finnapps4.fi/pizzaadmin/web_admin_common/";
$json_data["common_admin_url"]="https://finnapps4.fi/pizzaadmin/web_admin_common/"; */

$_SESSION['common_admin_url']="https://foozu3.fi/pizzaadmin/web_admin_common/";
$json_data["common_admin_url"]="https://foozu3.fi/pizzaadmin/web_admin_common/";

/// STATEMENT 
$statement_item= $conn_super->prepare("select * from client_restaurant_login left join client_restaurant_detail ON client_restaurant_detail.client_id=client_restaurant_login.client_id where client_login_id=?"); // write query
$statement_item->bind_param("i", $user_id);// bind the data
$statement_item->execute(); // execute the query
$result_statement_item= $statement_item->get_result();	// got result 
$row_data=$result_statement_item->fetch_assoc();
$count_qr_chk_email_pass=$result_statement_item->num_rows;



if($count_qr_chk_email_pass >0)
{
	    //$row_data = mysqli_fetch_array ($qr_chk_email_pass);
		$_SESSION['username']=strtolower($row_data['login_username']);
		$_SESSION['id']=$row_data['client_login_id'];
		$_SESSION['client_name']=$row_data['client_name'];
		$_SESSION['client_url']=$row_data['url'];
		$_SESSION['client_admin_url']=$row_data['site_admin_url'];
		$_SESSION['host_server']=$row_data['host_server'];
		$_SESSION['database_name']=$row_data['database_name'];
		$_SESSION['db_username']=$row_data['db_username'];
		$_SESSION['db_password']=$row_data['db_password'];
		$_SESSION['loc_id']=$row_data['loc_id'];
				$_SESSION['enc_key']=$row_data['enc_key'];
		$_SESSION['isDatabaseEnc']=$row_data['isDatabaseEnc'];
		$_SESSION['dataentryType']=$row_data['dataentryType'];
		$_SESSION['powered_by']=$row_data['powered_by'];

		
		
		$json_data["client_id"] = $_SESSION['id'];
		$json_data["client_url"] = $_SESSION['client_url'];
		$json_data["client_admin_url"] = $_SESSION['client_admin_url'];
		$json_data["login_username"] = $_SESSION['username'];
		$json_data["client_name"] = $_SESSION['client_name'];
		$json_data["host_server"] = $_SESSION['host_server'];
		$json_data["database_name"] = $_SESSION['database_name'];
		$json_data["db_username"] = $_SESSION['db_username'];
		$json_data["db_password"] = $_SESSION['db_password'];
		$json_data["loc_id"] = $_SESSION['loc_id'];
				$json_data["enc_key"] = $_SESSION['enc_key'];
	$json_data["isDatabaseEnc"] = $_SESSION['isDatabaseEnc'];
	$json_data["dataentryType"] = $_SESSION['dataentryType'];
	$json_data["powered_by"] = $_SESSION['powered_by'];
		$_SESSION['loc_id']=$row_data['loc_id'];
		if(isset($_SESSION['loc_id'])){
		$json_data["status"] = 1;
		}
		else{
			$json_data["status"] = 0;
		}
		
		
		
		
		$_SESSION['powerd_by']="Foozu";
			$test = explode('.fi',$_SESSION['client_url']);
 $folder_site=preg_replace("(^https?://)", "", $test[0] );
 //$_SESSION['site_folder']=$folder_site;
 $json_data["site_folder"]=$folder_site;
		include"connect.php";
		if(isset($_POST['actionfrom']) AND $_POST['actionfrom'] == 'active_db_new')
		{
			//echo "insert into active_db (client_id,datetime) values('$user_id','$current')";
$qr_v=mysqli_query($conn,"insert into active_db (client_id,datetime) values('$user_id','$current')");
		}
		$get_contact=mysqli_query($conn,"select print_no_of_copy from contact_us where loc_id='$_SESSION[loc_id]'");
 $row_contact=mysqli_fetch_array($get_contact);
 $_SESSION['print_no_of_copy']=$row_contact['print_no_of_copy'];
 $json_data["print_no_of_copy"]=$row_contact['print_no_of_copy'];
	$qr_language_master=mysqli_query($conn,"select * from language_master WHERE	status=1 and loc_id='$_SESSION[loc_id]' ORDER BY sequence ASC");
	$data = array();
	while( $rows = mysqli_fetch_assoc($qr_language_master) )
	{
		if($rows['lang_display_order'] == 1)
		{
			$_SESSION['lang_code']=$rows['lang_code'];
			$_SESSION['lang_id']=$rows['my_lang_id'];
			
		}
	$data[] = $rows;
	//	$rows['lang_id'].'l;lk';
	}
	$_SESSION['lanuage_array']=$data;	

}
else {
	$json_data["status"] = 0;
}
echo json_encode($json_data);
mysqli_close($conn_super);
?>