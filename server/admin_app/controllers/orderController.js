const utils = require('../utils');
const { format, subDays } = require('date-fns');
// ========NEW ORDERS=========
exports.getNewOrders = async (req, res) =>
{

  // console.log(utils.encryptPassWithKey("hi sujeet this is$%^123", "fc9653ebf224379c42031073acbc2a03"));



  const { shopSequelize, loc_id, enc_key, lang_id } = req;
  console.log(`lang:${lang_id}, enc_key:${enc_key}`);
  // const lang_id = req.lang_id
  // const enc_key = req.enc_key
  console.log("lang_id");
  try
  {

    // pre_order_booking: 3= fresh preorder, 2=response time set, 1=new order as pre order, 0= non-pre order(normal order)
    const pre_orders_update_status = await utils.setPreOrderToCurrentOrder(shopSequelize, loc_id);
    // console.log("pre_orders_update_status" + JSON.stringify(pre_orders_update_status));

    if (!pre_orders_update_status.status)
    {
      return res.status(500).json({ ...pre_orders_update_status });
    }

    let query = `SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_${lang_id} as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_${lang_id} as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token, orders.delivery_coupon_amt,orders.coupon_discount, orders.combo_offer_applied  FROM orders INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id = ${loc_id} and orders.payment_status_id=5 and (orders.orders_status_id=3 or orders.orders_status_id=5) and (orders.pre_order_booking=0 or orders.pre_order_booking=1 or orders.pre_order_booking=3)  order by orders.order_id DESC limit 100`;
    // let query = `SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_${lang_id} as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_${lang_id} as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token, orders.delivery_coupon_amt,orders.coupon_discount, orders.combo_offer_applied  FROM orders INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id = ${loc_id} and orders.payment_status_id=5 and (orders.orders_status_id=5) and (orders.pre_order_booking=0 or orders.pre_order_booking=1 or orders.pre_order_booking=3) and orders.rand_order_no ='ARYAN2347699' order by orders.order_id DESC limit 100`;

    const result = await shopSequelize.query(query, {
      type: shopSequelize.QueryTypes.SELECT
    });


    // Process each row




    if (result.length > 0)
    {
      const new_orders = result.map(row =>
      {
        return {
          // ...row,
          // key: enc_key
          userEmail: utils.decryptPassWithKey(row.user_email, enc_key),
          userMobileNo: utils.decryptPassWithKey(row.user_mobile_no, enc_key),
          userAddress: utils.decryptPassWithKey(row.address, enc_key),
          userZipcode: utils.decryptPassWithKey(row.zipcode, enc_key),
          userCity: utils.decryptPassWithKey(row.city, enc_key),
          userBuildingNo: utils.decryptPassWithKey(row.building_no, enc_key),

          firstName: row.first_name,
          lastName: row.last_name,
          userFullName: row.user_fullname,
          orderId: row.order_id,
          waiterId: row.waiter_id,
          deliveryPartnerCost: row.delivery_partner_cost,
          deliveryStatusInformation: row.partner_statusInformation,
          orderNO: row.rand_order_no,
          deliveryBoyName: row.delivery_boy_name,
          deliveryBoyMobileNo: row.delivery_boy_mob_no,
          orderDateTime: row.order_datetime,
          userNote: row.additional_info,
          deliveryTypeId: row.delivery_type_id,
          deliveryPartnerId: row.delivery_partner_id,
          deliveryTypeTitle: row.delivery_type_title,
          deliveryTypeImg: row.delivery_type_img,
          paymentModeLangTitle: row.payment_mode_lang_title,
          paymentModeId: row.payment_mode_id,
          paymentStatusId: row.payment_status_id,
          ordersStatusId: row.orders_status_id,
          preOrderBooking: row.pre_order_booking,
          tableBooking: row.table_booking,
          tableBookingDuration: row.table_booking_duration,
          tableBookingPeople: row.table_booking_people,
          sendEmailOrderSetTime: row.send_email_order_set_time,
          sendSmsOrderSetTime: row.send_sms_order_set_time,
          sendEmailOrderOntheway: row.send_email_order_ontheway,
          sendSmsOrderOntheway: row.send_sms_order_ontheway,
          sendEmailOrderCancel: row.send_email_order_cancel,
          sendSmsOrderCancel: row.send_sms_order_cancel,
          orderLanguageId: row.order_language_id,
          orderTimerStartTime: row.order_timer_start_time,
          setOrderMinutTime: row.set_order_minut_time,
          foodItemSubtotalAmt: row.food_item_subtotal_amt,
          totalItemTaxAmt: row.total_item_tax_amt,
          discountAmt: row.discount_amt,
          regOfferAmount: row.reg_offer_amount,
          deliveryCharges: row.delivery_charges,
          extraDeliveryCharges: row.extra_delivery_charges,
          minimumOrderPrice: row.Minimum_order_price,
          grandTotal: row.grand_total,
          finalPayableAmount: row.final_payable_amount,
          orderFrom: row.order_from,
          qrcodeOrderLabel: row.qrcode_order_label,
          bonusValueUsed: row.bonus_value_used,
          bonusValueGet: row.bonus_value_get,
          userId: row.user_id,
          doneStatus: row.done_status,
          orderUserDistance: row.order_user_distance,
          preOrderResponseAlertTime: row.pre_order_response_alert_time,
          tableBookingResponseAlertTime: row.table_booking_response_alert_time,
          fcmToken: row.fcm_token,
          deliveryCouponAmt: row.delivery_coupon_amt,
          couponDiscount: row.coupon_discount,
          comboOfferApplied: row.combo_offer_applied,
        }
      });





      return res.json({ status_code: 200, status: true, data: { new_orders } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "No orders" });
    }
  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};


// ========CANCELLED ORDERS=========
exports.getCancelledOrders = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  const now = new Date()
  const current_date = format(now, 'yyyy-MM-dd');
  try
  {

    let query = `SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_${lang_id} as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_${lang_id} as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token, orders.delivery_coupon_amt,orders.coupon_discount, orders.combo_offer_applied  FROM orders INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id = ${loc_id} and orders.orders_status_id=4 and orders.order_date>='${current_date}'`;



    const cancelled_orders = await shopSequelize.query(query, {
      type: shopSequelize.QueryTypes.SELECT,
    });


    if (cancelled_orders.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { cancelled_orders } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Orders not found" });
    }

  } catch (error)
  {
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};

// ========RECEIVED ORDERS=========
exports.getReceivedOrders = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id;
  const now = new Date();
  const yesterday = format(subDays(now, 1), 'yyyy-MM-dd');

  try
  {

    let query = `SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_${lang_id} as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_${lang_id} as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token, orders.delivery_coupon_amt,orders.coupon_discount, orders.combo_offer_applied  FROM orders INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id = ${loc_id} and orders.orders_status_id=6 and date(orders.order_date)>='${yesterday}'`;
    const recieved_orders = await shopSequelize.query(query, {
      type: shopSequelize.QueryTypes.SELECT,
    });


    if (recieved_orders.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { recieved_orders } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Orders not found" });
    }

  } catch (error)
  {
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};


// ========FAILDED ORDERS=========
exports.getFailedOrders = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id;
  const now = new Date()
  const yesterday = format(subDays(now, 1), 'yyyy-MM-dd');

  try
  {
    let query = `SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_${lang_id} as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_${lang_id} as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token, orders.delivery_coupon_amt,orders.coupon_discount, orders.combo_offer_applied  FROM orders INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id = ${loc_id} and orders.orders_status_id=7 and (orders.payment_status_id=2 or  orders.payment_status_id=3) and orders.order_date>='${yesterday}'`;
    const failed_orders = await shopSequelize.query(query, {
      type: shopSequelize.QueryTypes.SELECT,
    });

    if (failed_orders.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { failed_orders } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Orders not found" });
    }

  } catch (error)
  {
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};

// ========ORDER DETAILS=========
exports.getOrderDetails = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  const enc_key = req.enc_key

  try
  {

    const { order_id, order_number } = req.query;

    if (!order_id && !order_number)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID or order number" });
    }

    let order_details = await utils.getOrderDetails({ sequelize: shopSequelize, loc_id, order_id, order_number, lang_id });

    return res.status(order_details.status_code).json({ ...order_details });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};


// ========SET PRE-ORDER RESPONSE TIME=========
exports.setPreOrderResponseAlertTime = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;

  try
  {

    const { order_id, alert_time } = req.body;

    if (!order_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }
    else if (!alert_time)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing response time" });
    }

    let query = `update orders set pre_order_booking ='2',pre_order_response_alert_time= :pre_order_response_alert_time where orders.loc_id = ${loc_id} and order_id = :order_id`;

    let replacements = { order_id, pre_order_response_alert_time: alert_time };

    const [update_preorder, metadata] = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.UPDATE
    });

    if (metadata === 0)
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Order not found" });
    }
    else
    {
      return res.json({ status_code: 200, status: true });
    }


  } catch (error)
  {
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};


// ========SET ORDER DELIVERY TIME=========
exports.setOrderDeliveryTime = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  const mail_type = "set_delivery_time"
  const now = new Date()
  const current_date_time = format(now, 'yyyy-MM-dd HH:mm:ss');
  try
  {

    const { order_id, delivery_time } = req.body;

    if (!order_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }
    else if (!delivery_time)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing delivery time" });
    }

    let str_delivery_time = delivery_time
    let query = `update orders set orders_status_id=5,set_order_minut_time= :set_order_minut_time,order_timer_start_time='${current_date_time}' where loc_id = ${loc_id} and order_id = :order_id`;

    let replacements = { order_id, set_order_minut_time: str_delivery_time };

    const [set_delivery_time, metadata] = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.UPDATE
    });

    if (metadata === 0)
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Order not found" });
    }
    else
    {

      let order_details = await utils.getOrderDetails({ sequelize: shopSequelize, loc_id, order_id, lang_id });

      // return res.status(order_details.status_code).json({ ...order_details });

      let mail_status = await utils.mailTo(shopSequelize, loc_id, order_details, mail_type);


      if (mail_status.status)
      {

        let mail_status_query = `update orders set send_email_order_set_time=1 where loc_id = ${loc_id} and order_id = :order_id`;

        const [set_mail_status, metadata] = await shopSequelize.query(mail_status_query, {
          replacements: { order_id },
          type: shopSequelize.QueryTypes.UPDATE
        });
      }
      // console.log(mail_status);
      // CALL A FUNCTION TO SEND EMAIL AND SMS AND UPDATE ORDER
      // send_email_order_set_time
      // send_sms_order_set_time


      return res.json({ status_code: 200, status: true, mail_status_code: mail_status.status_code, mail_response: mail_status.mail_response });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};



// ========SET ORDER ON THE WAY TIME=========
exports.concludeOrder = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id;
  const mail_type = "on_the_way";
  const now = new Date();
  const current_date_time = format(now, 'yyyy-MM-dd HH:mm:ss');
  try
  {

    const { order_id } = req.body;

    if (!order_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }


    let query = `update orders set orders_status_id ='6',stop_timer='1',ontheway_datetime='${current_date_time}' where loc_id = ${loc_id} and order_id = :order_id`;

    let replacements = { order_id };

    const [order_on_the_way, metadata] = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.UPDATE
    });

    if (metadata === 0)
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Order not found" });
    }
    else
    {

      let order_details = await utils.getOrderDetails({ sequelize: shopSequelize, loc_id, order_id, lang_id });

      // return res.status(order_details.status_code).json({ ...order_details });

      let mail_status = await utils.mailTo(shopSequelize, loc_id, order_details, mail_type);

      if (mail_status.status)
      {

        let mail_status_query = `update orders set send_email_order_ontheway=1 where loc_id = ${loc_id} and order_id = :order_id`;

        const [set_mail_status, metadata] = await shopSequelize.query(mail_status_query, {
          replacements: { order_id },
          type: shopSequelize.QueryTypes.UPDATE
        });
      }
      // console.log(mail_status);
      // CALL A FUNCTION TO SEND EMAIL AND SMS AND UPDATE ORDER
      // send_email_order_cancel
      // send_sms_order_cancel

      // send_email_order_ontheway
      // send_sms_order_ontheway

      return res.json({ status_code: 200, status: true, mail_status_code: mail_status.status_code, mail_response: mail_status.mail_response });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};



// ========SET CANCEL ORDER=========
exports.cancelOrder = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  const enc_key = req.enc_key
  const mail_type = "cancel"
  try
  {

    const { order_id } = req.body;

    if (!order_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }


    let query = `update orders set orders_status_id = 4,stop_timer='1' where loc_id = ${loc_id} and order_id = :order_id`;

    let replacements = { order_id };

    const [order_on_the_way, metadata] = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.UPDATE
    });

    if (metadata === 0)
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Order not found" });
    }
    else
    {

      let order_details = await utils.getOrderDetails({ sequelize: shopSequelize, loc_id, order_id, lang_id });

      // return res.status(order_details.status_code).json({ ...order_details });

      let mail_status = await utils.mailTo(shopSequelize, loc_id, order_details, mail_type);

      if (mail_status.status)
      {

        let mail_status_query = `update orders set send_email_order_cancel=1 where loc_id = ${loc_id} and order_id = :order_id`;

        const [set_mail_status, metadata] = await shopSequelize.query(mail_status_query, {
          replacements: { order_id },
          type: shopSequelize.QueryTypes.UPDATE
        });
      }
      // CALL A FUNCTION TO SEND EMAIL AND SMS AND UPDATE ORDER
      // send_email_order_cancel
      // send_sms_order_cancel

      return res.json({ status_code: 200, status: true, mail_status_code: mail_status.status_code, mail_response: mail_status.mail_response });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};

// ========GET ORDERED ITEMS=========
exports.orderItems = async (req, res) =>
{
  const { shopSequelize, loc_id,data_entry_type } = req;
  const lang_id = req.lang_id

  try
  {

    const { order_id, include_toppings } = req.query;

    if (!order_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }


    let query = `SELECT order_food_items.order_food_item_id,order_food_items.combo_product_type,master_food_items.food_item_name_${lang_id} as food_item_name,master_food_items.food_item_image,order_food_items.basic_price,order_food_items.item_order_qty,order_food_items.total_basic_price,order_food_items.item_total_toppings_price,order_food_items.food_extratext,order_food_items.size_id,order_food_items.food_test_id  FROM order_food_items INNER JOIN master_food_items ON order_food_items.food_item_id=master_food_items.food_item_id WHERE combo_offer_id=0 and order_food_items.order_id = :order_id and order_food_items.loc_id=${loc_id}`;

    let replacements = { order_id, lang_id };
    let combo_offer_items=[];

    const menu_loc_id = data_entry_type=='single'?1:loc_id;

    let order_items = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.SELECT
    });


    if (include_toppings)
    {

      // Fetch toppings for each order item and add to the order item object
      order_items = await Promise.all(order_items.map(async (item) =>
      {

        const toppings = await utils.getOrderItemToppings({ sequelize: shopSequelize, loc_id, order_food_item_id: item.order_food_item_id, lang_id });
        return {
          ...item,
          item_size_name: await utils.getItemSizeName({ sequelize:shopSequelize, loc_id: menu_loc_id, item_size_id:item.size_id, lang_id }),
          toppings
        };
      }));


      combo_offer_items = await utils.getOrderComboOfferItems({ sequelize: shopSequelize, loc_id, order_id, lang_id });



    }
    // let order_details = await utils.getOrderDetails({ sequelize: shopSequelize, loc_id, item.order_food_item_id, lang_id });



    return res.status(200).json({ status_code: 200, status: true, data: { order_items,combo_offer_items } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};

// ========GET ORDER TOPPINGS=========
exports.orderItemToppings = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id

  try
  {

    const { order_food_item_id } = req.query;

    if (!order_food_item_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order food item ID" });
    }

    const toppings = await utils.getOrderItemToppings({ sequelize: shopSequelize, loc_id, order_food_item_id, lang_id });

    return res.status(200).json({ status_code: 200, status: true, data: { toppings } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};


// ========GET ORDERED COMBO OFFER ITEMS=========
exports.orderComboOfferItems = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  const enc_key = req.enc_key
  const data_entry_type = req.data_entry_type

  try
  {

    const { order_id } = req.query;

    if (!order_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }

      const combo_offer_items = await utils.getOrderComboOfferItems({ sequelize: shopSequelize, loc_id, order_id, lang_id });

    return res.status(200).json({ status_code: 200, status: true, data: {combo_offer_items} });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};



// ========GET COMBO OFFER BY ID=========
exports.comboOfferById = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  const enc_key = req.enc_key

  try
  {

    const { combo_offer_id } = req.query;

    if (!combo_offer_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }

    let query = `SELECT combo_offer_id, combo_offer_name_${lang_id} AS combo_offer_name, total_price, total_product_count, active_status FROM combo_offers WHERE loc_id = ${loc_id} AND active_status = 1 AND combo_offer_id = :combo_offer_id ORDER BY combo_offer_id`;

    let replacements = { combo_offer_id };

    const combo_offer = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.SELECT
    });

    return res.status(200).json({ status_code: 200, status: true, data: { combo_offer } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};



