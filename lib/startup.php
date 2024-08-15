<?php
include('connect_superadmin.php');
$_SESSION['site_url']="https://foozu3.fi/app_admin_multiple_ravintola/";
$_SESSION['image_url']="https://foozu3.fi/app_admin_multiple_ravintola/";
$_SESSION['common_admin_url']="https://foozu3.fi/web_admin_common/";
$_SESSION['org_name']="Foozu";
$_SESSION['domain'] = "www.foozu3.fi/";
$loc_id=$_SESSION['loc_id'];
$currancyicon = "€";
$current=date('Y-m-d H:i:s');


// if(!isset($_SESSION['loc_id'])){

	//$txt = "Page:  startup.php | user_id: $_SESSION[id] | loc_id: $_SESSION[loc_id] | client_name: $_SESSION[client_name] |Time: $current";

// $myfile = file_put_contents('admin_session_log.txt', $txt.PHP_EOL , FILE_APPEND | LOCK_EX);
// }


if(isset($_REQUEST['langid']))
{
	$_SESSION['lang_id'] = $_REQUEST['langid'];
	$_SESSION['lang_code'] = $_REQUEST['lang_code'];
	$lang_id = $_SESSION['lang_id'];
	$lang_code = $_SESSION['lang_code'];
}

if(!isset($_SESSION['lang_id']))
{
	$_SESSION['lang_id']=2;	
	$_SESSION['lang_code']='FI';	
}

if(isset($_SESSION['lang_code']))
{
	$lang_code=$_SESSION['lang_code'];
	$lang_id=$_SESSION['lang_id'];
}

/* if(isset($_REQUEST['loc_id']))
{
	$_SESSION['loc_id'] = $_REQUEST['loc_id'];
	$loc_id=$_SESSION['loc_id'];
}
 */

if(isset($_SESSION['loc_id']))
{
	include('connect.php');
	include_once('common_function.php');

	$sqlc = "select * from contact_us  where  loc_id='$_SESSION[loc_id]'";
	$resultc = mysqli_query($conn,$sqlc);
	$rowsc = mysqli_fetch_array($resultc);
	$_SESSION['org_address'] = $rowsc["address"];
	$_SESSION['org_email'] = $rowsc["email"];
	$_SESSION['android_url'] = $rowsc["android_url"];
	$_SESSION['apple_url'] = $rowsc["apple_url"];
	$_SESSION['pre_booking'] = $rowsc["pre_booking"];
	
	$sqlgeneral_settings = "select * from general_settings  where  loc_id='$_SESSION[loc_id]'";
	$resultcgeneral_settings = mysqli_query($conn,$sqlgeneral_settings);
	$rowsgeneral_settings = mysqli_fetch_array($resultcgeneral_settings);
	$_SESSION['pre_ordering_feature'] = $rowsgeneral_settings["pre_ordering_feature"];
}

/*error_reporting(E_ALL);
ini_set('display_errors', '1');
*/

$all_labels=get_labels_new($conn_super,$_SESSION['lang_code']);
function get_labels_new($conn_super,$lang_code)
{
	    $sql_payment_gateway = "select header,title from admin_dashboard_content where lang_code ='$lang_code' and type='1'";
		$result_sql_payment_gateway = mysqli_query($conn_super,$sql_payment_gateway);
		$num_sql_payment_gateway=mysqli_num_rows($result_sql_payment_gateway);
		if($num_sql_payment_gateway > 0)
		{
		    $data = array();
			while( $rows = mysqli_fetch_assoc($result_sql_payment_gateway) )
			{
				$data[] = $rows;
			}
			return $data;
		}
		else 
		{
			return '';
		}
}

?>

