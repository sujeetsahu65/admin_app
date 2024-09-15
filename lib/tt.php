<!---page div start-->
<div class="page" data-name="todayorder_app">
	<?php
	include_once("startup.php");
	$active = 'today';
	$page_title = array_search('title_basic_report', array_column($all_labels, 'header', 'title'));
	include_once('common_header.php');


	?>
	<div class="page-content">
		<!-- 
		<div class="card">
			<div class="card-header">
			<div class="list list-strong-ios list-dividers-ios inset-ios">
      <ul>
        <li class="item-content item-input item-input-outline">
          <div class="item-media">
            <i class="icon fa fa-send"></i>
          </div>
          <div class="item-inner">
            <div class="" style="border:1px solid grey; border-radius:30px;color: black !important;">
              <input type="text" placeholder="Your name">
            </div>
          </div>
        </li>
		</ul>
</div> -->



		<!-- </div>
		</div>   -->









		<div class="card">
			<div class="card-header">

				<div class="row row_report">
					<!-- <li class="item-content item-input item-input-outline"> -->
					<div class="item-media col-15 col_report_icon">
						<i class="icon fa fa-send" id="emailsendreport_new"></i>
					</div>
					<div class="item-inner col-85 col_report_input">
						<div class="">
							<input type="text" placeholder="Your Email" id="report_pdf_bcc">
						</div>
					</div>
					<!-- </li> -->
				</div>
			</div>



			<div class="card-header">
				<input type="hidden" value="<?php echo $_SESSION['client_url']; ?>" id="site_url" />
				<input type="hidden" value="fi" id="lang_code" />



				<p class="row" style=" width: 100%;">
					<button class="col-50 button button-round button-raised" id="report_print"><i class="fa fa-print" aria-hidden="true"></i> <?= $label_print ?></button>
					<button class="col-50 button button-round button-raised button-fill" id="iframe_butto_for"><i class="fa fa-calendar" aria-hidden="true"></i> <?= array_search('customlabel', array_column($all_labels, 'header', 'title')); ?></button>
				</p>
			</div>
		</div>

		<div class="card-content">
			<?php
			if (isset($_GET["start_date"])) {
				$start_date = $_GET["start_date"];
				$end_date = $_GET["end_date"];
			} else {
				$start_date = date("Y-m-d");
				$end_date = date("Y-m-d");
			}
			?>
			<!--form start-->
			<form class="custome_filter_h list">
				<ul>
					<li>
						<div class="item-content item-input">
							<div class="item-inner">
								<div class="item-title item-label"><?= array_search('start_date_label', array_column($all_labels, 'header', 'title')); ?></div>
								<div class="item-input-wrap">
									<input type="date" placeholder="To date" value="<?= $start_date ?>" id="start_date" name="start_date">
								</div>
							</div>
						</div>
					</li>
					<li>
						<div class="item-content item-input">
							<div class="item-inner">
								<div class="item-title item-label"><?= array_search('end_date_label', array_column($all_labels, 'header', 'title')); ?></div>
								<div class="item-input-wrap">
									<input type="date" value="<?php echo $end_date ?>" placeholder="From date" id="end_date" name="end_date">
								</div>
							</div>
						</div>
					</li>
					<li>
						<div class="item-content item-input">
							<button type="button" class="col-50 button  button-raised button-fill" id="btn_calender"><i class="fa fa-calendar" aria-hidden="true"></i> <?php echo  array_search('title_submit', array_column($all_labels, 'header', 'title'));	?></button>
						</div>
					</li>
				</ul>
			</form>
			<!--form close-->

			<!--today basic report start-->
			<div>
				<?php
				if ($start_date == date('Y-m-d')) {
					$date = date_create($start_date);
					$selected_date = date_format($date, "d-m-Y");
				} else {
					$date = date_create($start_date);
					$dateend = date_create($end_date);
					$selected_date = date_format($date, "d-m-Y") . ' - ' . date_format($dateend, "d-m-Y");
				}

				$cond_arr = " AND date(orders.order_date) >= '" . $start_date . "' AND date(orders.order_date) <= '" . $end_date . "' and orders.orders_status_id =6";
				$total_order_count = 0;
				$total_final_payable_amount = 0;
				$total_item_tax_amt = 0;
				$total_tax_amount = 0;

				$totaldiscount_order_count = 0;
				$total_all_discount = 0;



				$result_get_total_order = getReportAllTotalSuccessOrder($conn, $loc_id, $cond_arr);

				if (!empty($result_get_total_order)) {
					if ($result_get_total_order['total_order_count'] > 0) {
						$total_order_count = $result_get_total_order['total_order_count'];
						$total_final_payable_amount = number_format($result_get_total_order['total_final_payable_amount'], 2, ".", "");
						$total_item_tax_amt = number_format($result_get_total_order['total_item_tax_amt'], 2, ".", "");
						$total_home_del_charges_tax_amount = number_format($result_get_total_order['total_home_del_charges_tax_amount'], 2, ".", "");
						$total_tax_amount = number_format($result_get_total_order['total_tax_amount'], 2, ".", "");
					} else {
				?>
						<div class="my_card_header2">
							<h3 class="margin-10 text-center">
								<img src="<?php echo $_SESSION['site_url']; ?>img/no-order.png" width="70%" /><br />
								<?php echo array_search('no order title', array_column($all_labels, 'header', 'title')); ?>
							</h3>
						</div>
				<?php
						exit;
					}
				}


				$result_get_discounttotal_order = getReportTotalDiscountSuccessOrder($conn, $loc_id, $cond_arr);
				if (!empty($result_get_discounttotal_order)) {
					$totaldiscount_order_count = $result_get_discounttotal_order['totaldiscount_order_count'];
					$total_all_discount = number_format($result_get_discounttotal_order['total_all_discount'], 2, ".", "");
				}

				$result_get_bonustotal_order = getReportTotalBonusSuccessOrder($conn, $loc_id, $cond_arr);
				if (!empty($result_get_bonustotal_order)) {
					$totalbonus_order_count = $result_get_bonustotal_order['totalbonus_order_count'];
					$total_bonus_value_used = number_format($result_get_bonustotal_order['total_bonus_value_used'], 2, ".", "");
				}

				$result_get_copupontotal_order = getReportTotalcouponSuccessOrder($conn, $loc_id, $cond_arr);
				if (!empty($result_get_copupontotal_order)) {
					$total_coupon_discount = number_format($result_get_copupontotal_order['total_coupon_discount'], 2, ".", "");
					$totalcoupon_order_count = $result_get_copupontotal_order['totalcoupon_order_count'];
				}

				?>
				<h4 align='center' class="text-center bold" style="font-weight: bold;">
					<?= array_search('title_basic_report', array_column($all_labels, 'header', 'title')); ?>(<?= $selected_date ?>)
				</h4>

				<h4 align='center' class="text-center bold" style="font-weight: bold;">
					<?= array_search('Summary label', array_column($all_labels, 'header', 'title')); ?>
				</h4>

				<table>
					<tbody>
						<tr>
							<td> <?php echo array_search('title_Total_Order', array_column($all_labels, 'header', 'title'));	?></td>
							<td><?= $total_order_count ?></td>
							<td style="color: green;"><?= $total_final_payable_amount ?> <?= $currancyicon ?></td>
						</tr>
						<?php
						if ($totaldiscount_order_count > 0) {
						?>
							<tr>
								<td> <?php echo array_search('title_Total_discount', array_column($all_labels, 'header', 'title'));	?></td>
								<td><?= $totaldiscount_order_count ?></td>
								<td style="color: green;"><?= $total_all_discount ?> <?= $currancyicon ?></td>
							</tr>
						<?php
						}
						if ($totalcoupon_order_count > 0) {

						?>

							<tr>
								<td> <?php echo array_search('title_Total_coupon_discount', array_column($all_labels, 'header', 'title'));	?></td>
								<td><?= $totalcoupon_order_count ?></td>
								<td style="color: green;"><?= $total_coupon_discount ?> <?= $currancyicon ?></td>
							</tr>
						<?php
						}
						if ($totalbonus_order_count > 0) {
						?>
							<tr>
								<td> <?php echo array_search('title_user_bonus_credit', array_column($all_labels, 'header', 'title'));	?></td>
								<td><?= $totalbonus_order_count ?></td>
								<td style="color: green;"><?= $total_bonus_value_used ?> <?= $currancyicon ?></td>
							</tr>
						<?php
						}
						?>
						<tr>
							<td> <?php echo array_search('tax label', array_column($all_labels, 'header', 'title'));	?></td>
							<td><?= $total_order_count ?></td>
							<td style="color: green;"><?= $total_item_tax_amt ?> <?= $currancyicon ?></td>
						</tr>
						<?php
						if ($total_home_del_charges_tax_amount > 0) {
						?>

							<tr>
								<td> <?php echo array_search('title_Home_delivery_tax', array_column($all_labels, 'header', 'title'));	?></td>
								<td>-</td>
								<td style="color: green;"><?= $total_home_del_charges_tax_amount ?> <?= $currancyicon ?></td>
							</tr>
							<tr>
								<td> <?php echo array_search('title_Total_Tax', array_column($all_labels, 'header', 'title'));	?></td>
								<td><?= $total_order_count ?></td>
								<td style="color: green;"><?= $total_tax_amount ?> <?= $currancyicon ?></td>
							</tr>
						<?php
						}
						?>

					</tbody>
				</table>

				<h4 align='center' class="text-center bold" style="font-weight: bold;">
					<?= array_search('title_Summary_by_payment_mode', array_column($all_labels, 'header', 'title')); ?>
				</h4>

				<table>
					<tbody>
						<?php
						$total_order = 2;
						$final_amount = 10;
						//title_order_type_pickup
						$result_getPaymentmodewithTotalOrder =  getPaymentmodewithTotalOrder($conn, $loc_id, $cond_arr);
						if (!empty($result_getPaymentmodewithTotalOrder)) {
							foreach ($result_getPaymentmodewithTotalOrder as $result_getPaymentmodewithTotalOrder) {

						?>
								<tr>
									<td><?= $result_getPaymentmodewithTotalOrder['payment_mode_lang_' . $lang_id] ?></td>
									<td><?= $result_getPaymentmodewithTotalOrder['total_order_count'] ?></td>
									<td style="color: green;"><?= number_format($result_getPaymentmodewithTotalOrder['total_final_payable_amount'], 2, ".", ""); ?> <?= $currancyicon ?></td>
								</tr>
						<?php
							}
						}
						?>
					</tbody>
				</table>

				<h4 align='center' class="text-center bold" style="font-weight: bold;">
					<?= array_search('title_Summary_by_delivery_type', array_column($all_labels, 'header', 'title')); ?>
				</h4>

				<table>
					<tbody>
						<?php
						$resul_getDeliveryTypewithTotalOrder = getDeliveryTypewithTotalOrder($conn, $loc_id, $cond_arr);
						if (!empty($resul_getDeliveryTypewithTotalOrder)) {
							$total_payment=0;
							foreach ($resul_getDeliveryTypewithTotalOrder as $resul_getDeliveryTypewithTotalOrder) {
								if ($lang_id == 2) {
									$delivery_type_label = $resul_getDeliveryTypewithTotalOrder['delivery_type_' . $lang_id];
								} else {
									$delivery_type_label = $resul_getDeliveryTypewithTotalOrder['delivery_type_label'];
								}
								$total_payment=$total_payment+$resul_getDeliveryTypewithTotalOrder['total_final_payable_amount'];
						?>
								<tr>
									<td><?= $delivery_type_label ?></td>
									<td><?= $resul_getDeliveryTypewithTotalOrder['total_order_count'] ?></td>
									<td style="color: green;"><?= number_format($resul_getDeliveryTypewithTotalOrder['total_final_payable_amount'], 2, ".", "") ?> <?= $currancyicon ?></td>
								</tr>
						<?php
							}
						}
						  
$savings = ($total_payment * $other_company_ordercharges_percent) / 100;
?>
<tr>
    
    <td colspan="3">
        <?= sprintf(
            array_search('total_savings', array_column($all_labels, 'header', 'title')),
            number_format($savings, 2),
            $currancyicon,
            number_format($other_company_ordercharges_percent, 2) . '%'
        ) ?>
    </td>
</tr>

					</tbody>
				</table>


			</div>



			<!--today basic report end-->


		</div>
		<?php
		mysqli_close($conn);
		mysqli_close($conn_super);
		?>
	</div>
	<!---page div start-->