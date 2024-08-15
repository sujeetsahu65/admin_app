<?php
	  include_once("startup.php");
?>
	<div class="col-100">
	  <div class="list media-list text-color-black">
		<?php
		$order_id=$_REQUEST['order_id'];
		$print_order_detail = getOrderDetailWithCurrentStatus($conn,$loc_id,"print_order_detail",$order_id);
		if(!empty($print_order_detail))
		{
			//payment summary 
			$payment_mode_lang_title = $print_order_detail[0]['payment_mode_lang_title'];
			$food_item_subtotal_amt=number_format($print_order_detail[0]['food_item_subtotal_amt'],2,".","");
			$total_item_tax_amt=number_format($print_order_detail[0]['total_item_tax_amt'],2,".","");
			$discount_amt=number_format($print_order_detail[0]['discount_amt'],2,".","");
			$reg_offer_amount=number_format($print_order_detail[0]['reg_offer_amount'],2,".","");
			$delivery_charges=number_format($print_order_detail[0]['delivery_charges'],2,".","");
			$extra_delivery_charges=number_format($print_order_detail[0]['extra_delivery_charges'],2,".","");
			$Minimum_order_price=number_format($print_order_detail[0]['Minimum_order_price'],2,".","");
			$grand_total=number_format($print_order_detail[0]['grand_total'],2,".","");
			$final_payable_amount=number_format($print_order_detail[0]['final_payable_amount'],2,".","");
			$order_user_distance = number_format($print_order_detail[0]['order_user_distance'],2,".","");

            $delivery_coupon_amt = number_format($print_order_detail[0]['delivery_coupon_amt'],2,".","");
			$coupon_discount_amt=number_format($print_order_detail[0]['coupon_discount'],2,".","");


$order_item_list = getAddToCartOrderListCheckout($conn, $lang_id, $order_id);
$combo_offer_list = getAddToCartOrderListCheckoutCombo($conn, $lang_id, $order_id);

//print_r($combo_offer_list);

if (!empty($order_item_list)) {
    foreach ($order_item_list as $order_item) {
        $item_order_qty = (int)$order_item['item_order_qty'];
        $item_basic_price = number_format($order_item['basic_price'], 2, ".", "");
        $total_basic_price = number_format($order_item['total_basic_price'], 2, ".", "");
        $food_item_name = $order_item["food_item_name"];
        $order_food_item_id = $order_item['order_food_item_id'];
        $item_size_id = $order_item['size_id'];
        $food_extratext = $order_item['food_extratext'];
        $item_food_test_id = $order_item['food_test_id'];
        $food_test_images = "";

        if ($item_food_test_id > 0) {
            if ($_SESSION['dataentryType'] == 'single') {
                $food_spicy_level = getSpicyTestList($conn, $lang_id, 1);
            } else {
                $food_spicy_level = getSpicyTestList($conn, $lang_id, $loc_id);
            }

            if (!empty($food_spicy_level)) {
                foreach ($food_spicy_level as $food_spicy_level_list) {
                    if ($food_spicy_level_list['food_test_id'] == $item_food_test_id) {
                        $food_test_images = $food_spicy_level_list['food_test_images'];
                    }
                }
            }
        }

        if ($_SESSION['dataentryType'] == 'single') {
            $result_getItemSizeName = getItemSizeName($conn, $lang_id, $item_size_id, 1);
        } else {
            $result_getItemSizeName = getItemSizeName($conn, $lang_id, $item_size_id, $loc_id);
        }

        $item_size_name = '';
        if (!empty($result_getItemSizeName)) {
            $item_size_name = $result_getItemSizeName['item_size_name'];
        }
?>

<!-- Individual item list start -->
<div class="margin-0 padding-0" id="card_id0">
    <div class="card-content" style='border-bottom: solid 1px #eee;'>
        <div class="content-block margin-top-10 productdata mobile_css_margin_top_10 app_padding_leftright-">
            <h5 class="size-14 margin-0 maintitle col-100 padding-0 bold ">
                <span class="color-orange"><?= $item_order_qty ?> x</span> <?= $food_item_name ?> (<?= $item_size_name ?>) 
                <?php if ($food_test_images != "") { ?>
                    <img src="<?= $_SESSION['site_url']; ?>img/chiliimg/<?= $food_test_images ?>" style='width: auto;height: 15px;vertical-align: baseline;' />
                <?php } ?>
                <span class="pull-right size-12"><?= $total_basic_price ?>&euro;</span>
            </h5>

            <?php if ($food_extratext != "") { ?>
                <h6 class="size-12 margin-0 maintitle col-100 padding-0 bold ">
                    <span class="color-orange">Extra Comment: </span>
                    <span class="pull-right size-12"><?= $food_extratext ?></span>
                </h6>
            <?php } ?>

            <?php
            $result_item_topping_list = getAddToCartOrderListToppingsCheckout($conn, $lang_id, $order_food_item_id, $loc_id);
            if (!empty($result_item_topping_list)) {
                $topping_sub_heading_id = 0;
                foreach ($result_item_topping_list as $item_topping_list_data) {
                    $food_varient_option_price = number_format($item_topping_list_data['food_varient_option_price'], 2, ".", "");
                    if ($item_topping_list_data['food_varient_option_type_id'] != $topping_sub_heading_id) {
                        $topping_sub_heading_id = $item_topping_list_data['food_varient_option_type_id'];
                        echo "<p class='margin-0 app_margin_top_2 size-14 margin-left-0'><b>{$item_topping_list_data['toppingsheading']}: </b></p>";
                    }
            ?>
                    <div class="row">
                        <div class="col-100 margin-left-0 size-14">
                            <span style="color:red"><?= $item_topping_list_data['toppingslistname'] ?></span>
                            <?php if ($food_varient_option_price > 0) { ?>
                                <span class="margin-right-0" style="float:right"><?= $food_varient_option_price ?></span>
                            <?php } ?>
                        </div>
                    </div>
            <?php
                }
            }
            ?>
        </div>
    </div>
</div>
<!-- Individual item list end -->

<?php
    }
}

// Display combo offers
if (!empty($combo_offer_list)) {
	
	  $combo_data = [];
    foreach ($combo_offer_list as $combo_offer_list) {
        $combo_offer_id = $combo_offer_list['combo_offer_id'];
        $combo_offer_set_id = $combo_offer_list['combo_offer_set_id'];
        if (!isset($combo_data[$combo_offer_set_id])) {
            // Function to get combo offer details including name
            $combo_offer_details = getCombooffersbyid($conn, $lang_id, $loc_id, $combo_offer_id);
            if (!empty($combo_offer_details)) {
                $combo_name = $combo_offer_details[0]['combo_offer_name'];
                $combo_total_price = $combo_offer_details[0]['total_price'];
                $combo_data[$combo_offer_set_id] = [
                    'combo_name' => $combo_name,
                    'total_price' => $combo_total_price,
                    'combo_offer_id' => $combo_offer_id,
                    'combo_offer_set_id' => $combo_offer_set_id,
                    'items' => []
                ];
            }
        }
       
        $item_basic_price = number_format($combo_offer_list['basic_price'], 2, ".", "");
        $item_order_qty = (int)$combo_offer_list['item_order_qty'];
        $item_size_id = (int)$combo_offer_list['size_id'];
        $combo_product_type = $combo_offer_list['combo_product_type'];
        $total_basic_price = number_format($combo_offer_list['total_basic_price'], 2, ".", "");
        $item_total_toppings_price = number_format($combo_offer_list['item_total_toppings_price'], 2, ".", "");
        $total_item_price_with_toppings = floatval($total_basic_price) + floatval($item_total_toppings_price);
        $total_item_price_with_toppings = number_format($total_item_price_with_toppings, 2, ".", "");
        $combo_data[$combo_offer_set_id]['total_price'] += $total_item_price_with_toppings;
         if($dataentryType=='single'){
        $result_getItemSizeName = getItemSizeName($conn,$lang_id,$item_size_id,1);
}else{
	 $result_getItemSizeName = getItemSizeName($conn,$lang_id,$item_size_id,$loc_id);
}
       $item_size_name='';
       if(!empty($result_getItemSizeName))
       {
        $item_size_name = $result_getItemSizeName['item_size_name'];
       }
        $combo_data[$combo_offer_set_id]['items'][] = [
            'food_item_name' => $combo_offer_list['food_item_name'],
            'order_food_item_id' => $combo_offer_list['order_food_item_id'],
            'item_size_name' => $item_size_name, // You need to define this variable
            'item_order_qty' => $item_order_qty,
            'item_basic_price' => $item_basic_price,
            'combo_product_type' => $combo_product_type,
            'currency' => $currency // You need to define this variable
        ];
    }
	
	
	  foreach ($combo_data as $combo_offer_set_id => $combo) {
        $combo_name = $combo['combo_name'];
        $total_combo_price = $combo['total_price'];
        $combo_offer_id = $combo['combo_offer_id'];
        $combo_offer_set_id = $combo['combo_offer_set_id'];
        ?>


<!-- Combo offer list start -->
<div class="margin-0 padding-0" id="combo_card_id0">
    <div class="card-content" style='border-bottom: solid 1px #eee;'>
        <div class="content-block margin-top-10 productdata mobile_css_margin_top_10 app_padding_leftright-">
            <h5 class="size-14 margin-0 maintitle col-100 padding-0 bold ">
                <span class="color-orange">Combo Offer: <?= $combo_name ?> </span>
                <span class="pull-right size-12"><?= $total_combo_price ?>&euro;</span>
            </h5>
            <h6 class="size-12 margin-0 maintitle col-100 padding-0 bold ">
                <span class="color-orange">Combo Items: </span>
            </h6>
            <?php
         foreach ($combo['items'] as $item) { ?>
               
          
                    <p class='margin-0 app_margin_top_2 size-14 margin-left-0'>  <?=$item['food_item_name']?>(<?=$item_size_name?>) x <?=$item['item_order_qty']?></p>
                     <?php if ($food_extratext != "") { ?>
                <h6 class="size-12 margin-0 maintitle col-100 padding-0 bold ">
                    <span class="color-orange">Extra Comment: </span>
                    <span class="pull-right size-12"><?= $food_extratext ?></span>
                </h6>
            <?php } ?>

            <?php
            $result_item_topping_list = getAddToCartOrderListToppingsCheckout($conn, $lang_id, $item['order_food_item_id'], $loc_id);
            if (!empty($result_item_topping_list)) {
                $topping_sub_heading_id = 0;
                foreach ($result_item_topping_list as $item_topping_list_data) {
                    $food_varient_option_price = number_format($item_topping_list_data['food_varient_option_price'], 2, ".", "");
                    if ($item_topping_list_data['food_varient_option_type_id'] != $topping_sub_heading_id) {
                        $topping_sub_heading_id = $item_topping_list_data['food_varient_option_type_id'];
                        echo "<p class='margin-0 app_margin_top_2 size-14 margin-left-0'><b>{$item_topping_list_data['toppingsheading']}: </b></p>";
                    }
            ?>
                    <div class="row">
                        <div class="col-100 margin-left-0 size-14">
                            <span style="color:red"><?= $item_topping_list_data['toppingslistname'] ?></span>
                            <?php if ($food_varient_option_price > 0) { ?>
                                <span class="margin-right-0" style="float:right"><?= $food_varient_option_price ?></span>
                            <?php } ?>
                        </div>
                    </div>
            <?php
                }
            }
            ?>
            <?php
               
            }
            ?>
        </div>
    </div>
</div>
<!-- Combo offer list end -->

<?php
    }
}
?>


		

		<!--payment summary  start-->
	         <ul>
				<li>
				   <div class="row">
						<div class="col-100 padding-right-10  size-16">
							<div class="item-subtitle text-right">
							 <?=array_search('sub total label', array_column($all_labels, 'header','title'))?>:<?=$food_item_subtotal_amt?> <?=$currancyicon?>
							</div>
							<div class="item-subtitle text-right">
							 <?=array_search('tax label', array_column($all_labels, 'header','title'))?>:<?=$total_item_tax_amt?><?=$currancyicon?>
							</div>
							<?php
							 if($discount_amt>0)
							 {
							  ?>
								<div class="item-subtitle text-right">
								<?=array_search('discount label', array_column($all_labels, 'header','title'))?>:<?=$discount_amt?> <?=$currancyicon?>
								</div>
							  <?php
							 }
							 if($reg_offer_amount>0)
							 {
							?>
								<div class="item-subtitle text-right">
								<?=array_search('title_registration_Offers', array_column($all_labels, 'header','title'))?>:<?=$reg_offer_amount?><?=$currancyicon?>
								</div>
							<?php
							 }
							 if($delivery_charges>0)
							 {
							 ?>
							 <div class="item-subtitle text-right">
								<?=array_search('delivery charge label', array_column($all_labels, 'header','title'))?>:<?=$delivery_charges?><?=$currancyicon?>
							 </div>
							 <?php
							 }
							 if($extra_delivery_charges>0)
							 {
							  ?>
                             <div class="item-subtitle text-right">
								<?=array_search('Extra Delivery Charges label', array_column($all_labels, 'header','title'))?>:<?=$extra_delivery_charges?><?=$currancyicon?>
							 </div>
							  <?php
							 }
							 if($Minimum_order_price>0)
		                      {
							   ?>
							    <div class="item-subtitle text-right">
								<?=array_search('title_Minimum_order_price', array_column($all_labels, 'header','title'))?>:<?=$Minimum_order_price?><?=$currancyicon?>
							 </div>
							   <?php
							  }
                              if($order_user_distance>0)
							  {
								?>
								<div class="item-subtitle text-right">
								<?=array_search('title_distance', array_column($all_labels, 'header','title'))?>:<?=$order_user_distance?> Km
							   </div>
								<?php
							  }
                              if($delivery_coupon_amt>0)
							  {
                                ?>
                                <div class="item-subtitle text-right">
								<?=array_search('delivery_coupon_discount_title', array_column($all_labels, 'header','title'))?>:<?=$delivery_coupon_amt?> <?=$currancyicon?>
							   </div>
                                <?php
                              }
                              if($coupon_discount_amt>0)
							  {
                                ?>
                                <div class="item-subtitle text-right">
								<?=array_search('coupon discount title', array_column($all_labels, 'header','title'))?>:<?=$coupon_discount_amt?> <?=$currancyicon?>
							   </div>

                               <?php
                              }
							 ?>
                            <div class="item-subtitle text-right">
								<?=array_search('Grand Total lable', array_column($all_labels, 'header','title'))?>:<?=$grand_total?><?=$currancyicon?>
							 </div>
							 <div class="item-subtitle text-right">
								<?=array_search('total label', array_column($all_labels, 'header','title'))?>:<?=$final_payable_amount?><?=$currancyicon?>
							 </div>
							 <div class="item-subtitle text-right">
							 <?=array_search('title_payment_mode', array_column($all_labels, 'header','title'))?>:<?=$payment_mode_lang_title?>  
							 </div>
						</div>
				   </div>
				</li>

				<!--tax summary start-->
				<li>  
				<hr style="margin: 0px;border: solid .5px #efefef;"/>
				    <div class="row">
					<div class="col-100">
					<div class="data-table">
					  <h5 class="margin-0" style="font-size: 11px;">
					  <?=array_search('Tax Summary', array_column($all_labels, 'header','title'))?>
					  </h5>

					  <table style="text-align: center">
    <thead>
      <tr>
        <th class="padding-0 " style="font-size: 11px;"><?=array_search('tax label', array_column($all_labels, 'header','title'))?></th>
        <th class="padding-0 " style="font-size: 11px;"><?=array_search('total label', array_column($all_labels, 'header','title'))?></th>
        <th class="padding-0 " style="font-size: 11px;"><?=array_search('title_Total_amount', array_column($all_labels, 'header','title'))?></th>
		
      </tr>
    </thead>
    <tbody>
    <?php 
    $qr_tax_summary=mysqli_query($conn,"SELECT tax_rate,SUM(tax_amount) as tax_sum,SUM(total_basic_price) as total_basic_price FROM order_food_items where order_id='$order_id'  and loc_id='$_SESSION[loc_id]'          
GROUP BY tax_rate

");
while($res=mysqli_fetch_array($qr_tax_summary))
{
    ?>
      <tr>
        <td class="padding-0" style="font-size: 11px;"><?php echo $res['tax_rate'];?> %</td>
        <td class="padding-0" style="font-size: 11px;"><?php echo $res['total_basic_price'];?> &euro;</td>
        <td class="padding-0" style="font-size: 11px;"><?php echo $res['tax_sum'];?> &euro;</td> 
       
      </tr>
      <?php  }
	  ?>
     
    </tbody>
  </table>


					</div>
					</div>
					</div>
				</li>
				<!--tax summary start-->


			 </ul>
			 <!--payment summary  end-->
		<?php
		}
		?>
	  </div>
	</div>