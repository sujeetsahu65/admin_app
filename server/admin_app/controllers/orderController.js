const utils = require('../utils');
const { format, subDays } = require('date-fns');
const { query, body, validationResult } = require('express-validator');
// ========NEW ORDERS=========


exports.getNewOrders = async (req, res) =>
{

  const { shopSequelize, loc_id } = req;
  const { User, Order, DeliveryType, PaymentMode } = req.models;
  try
  {

    // pre_order_booking: 3= fresh preorder, 2=response time set, 1=new order as pre order, 0= non-pre order(normal order)
    const pre_orders_update_status = await utils.setPreOrderToCurrentOrder(shopSequelize, loc_id);

    if (!pre_orders_update_status.status)
    {
      return res.status(500).json({  status_code: 500, status: false,message:'Server error' });
    }

    const new_orders = await Order.findAll({
      where: {
        loc_id: loc_id,
        paymentStatusId: 5,
        ordersStatusId: [3, 5],
        preOrderBooking: [0, 1, 3]
      },
      include: [
        {
          model: User,
          attributes: ['firstName', 'lastName', 'userEmail']
        },
        {
          model: DeliveryType,
          attributes: [
            'deliveryType',
            'deliveryTypeImg'
          ]
        },
        {
          model: PaymentMode,
          attributes: [
            'paymentMode', 'paymentModeIcon'
          ]
        }
      ],
      order: [['order_id', 'DESC']],
      limit: 100
    });

    // let query = `SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_${lang_id} as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_${lang_id} as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token, orders.delivery_coupon_amt,orders.coupon_discount, orders.combo_offer_applied  FROM orders INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id = ${loc_id} and orders.payment_status_id=5 and (orders.orders_status_id=3 or orders.orders_status_id=5) and (orders.pre_order_booking=0 or orders.pre_order_booking=1 or orders.pre_order_booking=3)  order by orders.order_id DESC limit 100`;

    if (new_orders.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { new_orders } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "No orders" });
    }

  }

  catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }

}

// ========CANCELLED ORDERS=========
exports.getCancelledOrders = async (req, res) =>
{
  const { Op, loc_id } = req;
  const { User, Order, DeliveryType, PaymentMode } = req.models;
  const now = new Date()
  const current_date = format(now, 'yyyy-MM-dd');
  try
  {


    const cancelled_orders = await Order.findAll({
      where: {
        loc_id: loc_id,
        ordersStatusId: 4,
        // order_date: {
        //   [Op.gte]: current_date,
        // }
      },
      include: [
        {
          model: User,
          attributes: ['firstName', 'lastName', 'userEmail']
        },
        {
          model: DeliveryType,
          attributes: [
            'deliveryType',
            'deliveryTypeImg'
          ]
        },
        {
          model: PaymentMode,
          attributes: [
            'paymentMode', 'paymentModeIcon'
          ]
        }
      ],
      order: [['order_id', 'DESC']],
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
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};

// ========RECEIVED ORDERS=========
exports.getReceivedOrders = async (req, res) =>
{
  const { Op, loc_id } = req;
  const { User, Order, DeliveryType, PaymentMode } = req.models;
  const now = new Date();
  const yesterday = format(subDays(now, 1), 'yyyy-MM-dd');

  try
  {

    const received_orders = await Order.findAll({
      where: {
        loc_id: loc_id,
        ordersStatusId: 6,
        // order_date: {
        //   [Op.gte]: yesterday,
        // }
      },
      include: [
        {
          model: User,
          attributes: ['firstName', 'lastName', 'userEmail']
        },
        {
          model: DeliveryType,
          attributes: [
            'deliveryType',
            'deliveryTypeImg'
          ]
        },
        {
          model: PaymentMode,
          attributes: [
            'paymentMode', 'paymentModeIcon'
          ]
        }
      ],
      order: [['order_id', 'DESC']],
    });

    if (received_orders.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { received_orders } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Orders not found" });
    }

  } catch (error)
  {
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};


// ========FAILDED ORDERS=========
exports.getFailedOrders = async (req, res) =>
{

  const { Op, loc_id } = req;
  const { User, Order, DeliveryType, PaymentMode } = req.models;
  const now = new Date()
  const yesterday = format(subDays(now, 1), 'yyyy-MM-dd');

  try
  {

    const failed_orders = await Order.findAll({
      where: {
        loc_id: loc_id,
        ordersStatusId: 7,
        paymentStatusId: [2, 3],
        // order_date: {
        //   [Op.lte]: yesterday,
        // }
      },
      include: [
        {
          model: User,
          attributes: ['firstName', 'lastName', 'userEmail']
        },
        {
          model: DeliveryType,
          attributes: [
            'deliveryType',
            'deliveryTypeImg'
          ]
        },
        {
          model: PaymentMode,
          attributes: [
            'paymentMode', 'paymentModeIcon'
          ]
        }
      ],
      order: [['order_id', 'DESC']],
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
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};


// ========PRE-ORDERS=========
exports.getPreOrders = async (req, res) =>
{

  // const {Op, loc_id } = req;
  const { loc_id } = req;
  const { User, Order, DeliveryType, PaymentMode } = req.models;
  // const now = new Date()
  // const yesterday = format(subDays(now, 1), 'yyyy-MM-dd');

  try
  {

    const pre_orders = await Order.findAll({
      where: {
        loc_id: loc_id,
        ordersStatusId: 3,
        paymentStatusId: 5,
        preOrderBooking: 2,
        // order_date: {
        //   [Op.gte]: yesterday,
        // }
      },
      include: [
        {
          model: User,
          attributes: ['firstName', 'lastName', 'userEmail']
        },
        {
          model: DeliveryType,
          attributes: [
            'deliveryType',
            'deliveryTypeImg'
          ]
        },
        {
          model: PaymentMode,
          attributes: [
            'paymentMode', 'paymentModeIcon'
          ]
        }
      ],
      order: [['order_id', 'DESC']],
    });



    if (pre_orders.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { pre_orders } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Orders not found" });
    }

  } catch (error)
  {
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};

// ========ORDER DETAILS=========
exports.getOrderDetails = async (req, res) =>
{

  try
  {

    const { order_id, order_number } = req.query;

    if (!order_id && !order_number)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID or order number" });
    }

    let order_details = await utils.getOrderDetails({ req });
if(order_details.status_code ==200){
    return res.status(order_details.status_code).json({ status_code: 200, status: true, data: { order_details: order_details.order_details }});

}

    return res.status(order_details.status_code).json({ status_code: order_details.status_code, status: order_details.status, message:order_details.message});
    //  return res.status(200).json({ status_code: 200, status: true, data: { order_details } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
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
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};


// ========SET ORDER DELIVERY TIME=========
exports.setOrderDeliveryTime = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
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

      let order_details = await utils.getOrderDetails({ req });

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
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
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

      let order_details = await utils.getOrderDetails({ req });

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
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};



// ========SET CANCEL ORDER=========
exports.cancelOrder = async (req, res) =>
{
  const { shopSequelize, loc_id } = req;
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

      let order_details = await utils.getOrderDetails({ req });

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
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};

// ========GET ORDERED ITEMS=========
exports.orderItems = async (req, res) =>
{
  const { shopSequelize, loc_id, data_entry_type } = req;
  const lang_id = req.lang_id
  console.log("llllllllllllll" + lang_id);
  try
  {

    const { order_id, include_toppings } = req.query;

    if (!order_id)
    {
      return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    }


    let query = `SELECT order_food_items.order_food_item_id,order_food_items.combo_product_type,master_food_items.food_item_name_${lang_id} as food_item_name,master_food_items.food_item_image,order_food_items.basic_price,order_food_items.item_order_qty,order_food_items.total_basic_price,order_food_items.item_total_toppings_price,order_food_items.food_extratext,order_food_items.size_id,order_food_items.food_test_id  FROM order_food_items INNER JOIN master_food_items ON order_food_items.food_item_id=master_food_items.food_item_id WHERE combo_offer_id=0 and order_food_items.order_id = :order_id and order_food_items.loc_id=${loc_id}`;

    let replacements = { order_id, lang_id };
    let combo_offer_items = [];

    const menu_loc_id = data_entry_type == 'single' ? 1 : loc_id;

    let order_items = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.SELECT
    });


    // if (include_toppings)
    // {

    // Fetch toppings for each order item and add to the order item object
    order_items = await Promise.all(order_items.map(async (item) =>
    {

      const toppings = await utils.getOrderItemToppings({ sequelize: shopSequelize, loc_id, order_food_item_id: item.order_food_item_id, lang_id });
      return {
        ...item,
        item_size_name: await utils.getItemSizeName({ sequelize: shopSequelize, loc_id: menu_loc_id, item_size_id: item.size_id, lang_id }),
        toppings
      };
    }));

    // }


    combo_offer_items = await utils.getOrderComboOfferItems({ sequelize: shopSequelize, loc_id, order_id, lang_id });

    // if (combo_offer_items.length == 0)
    // {
    //   combo_offer_items = [];
    // }
    // let order_details = await utils.getOrderDetails({ sequelize: shopSequelize, loc_id, item.order_food_item_id, lang_id });



    return res.status(200).json({ status_code: 200, status: true, data: { order_items, combo_offer_items } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
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
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};


// ========GET ORDERED COMBO OFFER ITEMS=========
exports.orderComboOfferItems = [query('order_id')
  .isInt().withMessage('Missing order ID'),

async (req, res) =>
{



  // Check validation result
  const errors = validationResult(req);
  if (!errors.isEmpty())
  {
    return res.status(400).json({ status_code: 400, status: false, message:"Bad request", errors: errors.array() });
  }


  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  const enc_key = req.enc_key
  const data_entry_type = req.data_entry_type

  try
  {

    const { order_id } = req.query;

    // if (!order_id)
    // {
    //   return res.status(400).json({ status_code: 400, status: false, message: "Missing order ID" });
    // }

    const combo_offer_items = await utils.getOrderComboOfferItems({ sequelize: shopSequelize, loc_id, order_id, lang_id });



    if (combo_offer_items.length > 0)
    {

      return res.status(200).json({ status_code: 200, status: true, data: { combo_offer_items } });

    }
    else
    {
      return res.status(404).json({ status_code: 200, status: false, message: "No Combo offer items found" });

    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
}];



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

    let query = `SELECT combo_offer_id, combo_offer_name_${lang_id} AS combo_offer_name, total_price, total_product_count, active_status FROM combo_offers WHERE loc_id = ${loc_id} AND combo_offer_id = :combo_offer_id ORDER BY combo_offer_id`;

    let replacements = { combo_offer_id };

    const combo_offer = await shopSequelize.query(query, {
      replacements,
      type: shopSequelize.QueryTypes.SELECT
    });

    if (combo_offer.length > 0)
    {

      return res.status(200).json({ status_code: 200, status: true, data: { combo_offer } });

    }
    else
    {
      return res.status(404).json({ status_code: 200, status: false, message: "Combo offer not found" });

    }


  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};




exports.getReports = [
  query('start_date')
    .isDate({ format: 'yyyy-MM-dd' })
    .withMessage('Start date must be in yyyy-MM-dd format'),
  query('end_date')
    .isDate({ format: 'yyyy-MM-dd' })
    .withMessage('End date must be in yyyy-MM-dd format'),

  async (req, res) =>
  {

    // Check validation result
    const errors = validationResult(req);
    if (!errors.isEmpty())
    {
      return res.status(400).json({ status_code: 400, status: false,message:"Bad request", errors: errors.array() });
    }


    const { Op, fn, col, literal, loc_id, lang_id } = req;
    const { start_date, end_date } = req.query;
    const { Order, DeliveryType, PaymentMode } = req.models;

    // if (!start_date || !end_date)
    // {
    //   return res.status(500).json({ status_code: 400, status: false, message: 'missing date parameters(start_date or end_date)' });
    // }
    try
    {
      // Query 1: Total success order report
      const successOrders = await Order.findOne({
        attributes: [
          [fn('COUNT', col('order_id')), 'tatalOrders'],
          [fn('COALESCE', fn('SUM', col('final_payable_amount')), 0), 'totalAmount'],
          [fn('COALESCE', fn('SUM', col('total_item_tax_amt')), 0), 'totalOrderTax'],
          [fn('COALESCE', fn('SUM', col('home_del_charges_tax_amount')), 0), 'totalHomeDeliveryTax'],
          [fn('COALESCE', fn('SUM', literal('total_item_tax_amt + home_del_charges_tax_amount')), 0), 'totalTax']
        ],
        where: {
          loc_id,
          ordersStatusId: 6,
          order_date: {
            [Op.between]: [start_date, end_date],
          }

        },
        // logging: console.log,
      });

      // Query 2: Total discount success order report
      const discountedOrders = await Order.findOne({
        attributes: [
          [fn('COALESCE', fn('SUM', literal('discount_amt + pickup_offer_amount + reg_offer_amount')), 0), 'totalDiscount'],
          [fn('COUNT', col('order_id')), 'tatalOrders']
        ],
        where: {
          loc_id,
          ordersStatusId: 6,
          order_date: {
            [Op.between]: [start_date, end_date],
          },

          [Op.or]: [
            { discount_amt: { [Op.gt]: 0 } },
            { pickup_offer_amount: { [Op.gt]: 0 } },
            { reg_offer_amount: { [Op.gt]: 0 } }
          ]
        }
      });

      // Query 3: Total bonus success order report
      const bonusOrders = await Order.findOne({
        attributes: [
          [fn('COALESCE', fn('SUM', col('bonus_value_used')), 0), 'totalBonus'],
          [fn('COUNT', col('order_id')), 'tatalOrders']
        ],
        where: {
          loc_id,
          ordersStatusId: 6,
          order_date: {
            [Op.between]: [start_date, end_date],
          },

          bonus_value_used: { [Op.gt]: 0 }
        },

      });

      // Query 4: Total coupon success order report
      const couponOrders = await Order.findOne({
        attributes: [
          [fn('COALESCE', fn('SUM', col('coupon_discount')), 0), 'totalCouponDiscount'],
          [fn('COUNT', col('order_id')), 'tatalOrders']
        ],
        where: {
          loc_id,
          ordersStatusId: 6,
          order_date: {
            [Op.between]: [start_date, end_date],
          },

          coupon_discount: { [Op.gt]: 0 }
        }
      });

      // Query 5: Payment mode with total order report
      const ordersByPaymentMode = await Order.findAll({
        attributes: [
          [fn('COUNT', col('order_id')), 'tatalOrders'],
          [fn('COALESCE', fn('SUM', col('final_payable_amount')), 0), 'totalAmount'],
          'paymentModeId',
          [col(`PaymentMode.payment_mode_lang_${lang_id}`), 'paymentMode'],
        ],
        include: [
          {
            model: PaymentMode,
            attributes: []
          }

        ],
        where: {
          loc_id,
          ordersStatusId: 6,
          order_date: {
            [Op.between]: [start_date, end_date],
          }

        },
        group: ['paymentModeId'],
        //  group: ['paymentModeId', 'PaymentMode.paymentMode'],
        // logging: console.log,
        // raw: true 
      });

      // Query 6: Delivery type with total order report
      const ordersByDeliveryType = await Order.findAll({
        attributes: [
          [fn('COUNT', col('order_id')), 'tatalOrders'],
          [fn('COALESCE', fn('SUM', col('final_payable_amount')), 0), 'totalAmount'],
          'deliveryTypeId',
          [col(`DeliveryType.delivery_type_${lang_id}`), 'deliveryType'],
        ],
        include: [
          {
            model: DeliveryType,
            attributes: []
          }
        ],
        where: {
          loc_id,
          ordersStatusId: 6,
          order_date: {
            [Op.between]: [start_date, end_date],
          }
        },
        group: ['deliveryTypeId']
      });

      // Combine all results into a single response
      return res.json({
        status_code: 200,
        status: true,
        data: {
          successOrders,
          discountedOrders,
          bonusOrders,
          couponOrders,
          ordersByPaymentMode,
          ordersByDeliveryType
        }
      });

    } catch (error)
    {
      console.error(error);
      return res.status(500).json({ status_code: 500, status: false, error: 'Server error' });
    }
  }
]

