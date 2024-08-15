<?php


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
        $item_order_qty = $combo_offer_list['item_order_qty'];
        $item_size_id = $combo_offer_list['size_id'];
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



}


?>