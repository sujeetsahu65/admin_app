const crypto = require('crypto');
const nodemailer = require('nodemailer');
const { format, subDays, parse, differenceInMinutes } = require('date-fns');
const axios = require('axios');

async function setPreOrderToCurrentOrder (sequelize, loc_id)
{
    const current_date_time = format(new Date(), 'yyyy-MM-dd HH:mm:ss');
    console.log(current_date_time);
    const dt_format = 'yyyy-MM-dd HH:mm:ss';

    const query = `SELECT orders.order_id,orders.rand_order_no,orders.order_datetime,orders.pre_order_response_alert_time from orders WHERE orders.loc_id=${loc_id} and orders.pre_order_booking=2 order by  orders.order_id DESC`;
    // console.log('pre-order:'+query);

    try
    {
        const orders = await sequelize.query(query, {
            type: sequelize.QueryTypes.SELECT
        });


        if (orders.length > 0)
        {

            for (const row of orders)
            {
                let order_id = row.order_id;
                let pre_order_response_alert_time = row.pre_order_response_alert_time;
                let preorder_datetime = row.order_datetime;

                preorder_datetime = format(new Date(preorder_datetime), 'yyyy-MM-dd HH:mm:ss');


                let date1 = parse(preorder_datetime, dt_format, new Date());
                let date2 = parse(current_date_time, dt_format, new Date());

                let diff_in_minutes = differenceInMinutes(date1, date2);
                // diff_in_minutes = Math.abs(diff_in_minutes);
                if (diff_in_minutes <= pre_order_response_alert_time)
                {

                    pre_order_query = `update orders set pre_order_booking =1 where order_id =${order_id}`;
                    const [results, metadata] = await sequelize.query(pre_order_query, {
                        type: sequelize.QueryTypes.UPDATE
                    });

                    console.log('ppre_order_query:' + pre_order_query);

                }

            }
        }

        return { status_code: 200, status: true };

    } catch (error)
    {
        return { status_code: 500, status: false, message: 'Server error' };
    }
}

async function mailTo (shopSequelize, superSequelize, loc_id, data, mail_type, email_settings)
{

    return new Promise(async (resolve, reject) =>
    {

        try
        {

            let to_mail = '';
            let subject = '';

            if (mail_type === 'password_reset_otp')
            {
                html = `<p>${data}</p>`;
                subject = 'Password reset';
                to_mail = email_settings.contactFormMail;
            }

            else if (mail_type === 'set_delivery_time' || mail_type === 'on_the_way' || mail_type === 'cancel')
            {

                to_mail = data.User.userEmail;
// console.log(data.User.userEmail);
                let userformessage = '';
                const locationInfo = await shopSequelize.query(`SELECT loc_name,dis_name,loc_address,loc_image,loc_logo,loc_favicon,display_order,active_status,active_email_status,deactive_email_status,website,businessid,location_type,website_type,site_url FROM location_master where loc_id =${loc_id} `, {
                    type: shopSequelize.QueryTypes.SELECT
                });

                const location = locationInfo[0];

                const contactUs = await shopSequelize.query(`SELECT org_name_${data.orderLanguageId} as org_name,address_lang_${data.orderLanguageId} as address,email_id,phone,businessid,online_ordering,online_ordering_feature,pre_booking,pre_booking_feature,print_no_of_copy,print_style,device_type_print,orientation,org_city,org_zipcode,latitude,longitude FROM contact_us where loc_id =${loc_id} `, {
                    type: shopSequelize.QueryTypes.SELECT
                });



                const contact_us = contactUs[0];
                const logo = `https://foozu3.fi/pizzaadmin/web_admin_common/onlinetandoorivilla/logo/g7yfbi4kyi8scsc0wc.png`;

                const label_data = await getOrderEmailLabels(superSequelize, data.orderLanguageId);
                if (!label_data.status)
                {
                    return { status_code: 404, status: false, mail_response: 'labels not found' };
                }
                let labels = label_data.data;

                let text = '';


                if (mail_type === 'set_delivery_time')
                {

                    subject = 'Order delivery time update';
                    userformessage = `${labels.order_no_title} ${data.orderNO} ${labels.title_is_on_the_way} ${data.setOrderMinutTime} ${labels.title_delivered_to_last} minuutissa`;

                }
                else if (mail_type === 'on_the_way')
                {


                    if (data.deliveryTypeId == 1)
                    {
                        subject = 'Order is on the way';
                        userformessage = `${labels.order_no_title} ${data.orderNO} ${labels.title_is_on_the_way}`;
                    }

                    else
                    {
                        subject = 'Order is ready to pick';
                        userformessage = `${labels.order_no_title} ${data.orderNO} ${labels.title_is_ready_to_pick}`;
                    }

                }
                else if (mail_type === 'cancel')
                {
                    subject = 'Order is cancelled';
                    userformessage = `${labels.order_no_title} ${data.orderNO} ${labels.title_was_cancelled}`;

                }

                else
                {

                    console.log(mail_type);
                }



                let html_head = `<!DOCTYPE html>
    <html>
    <head>
      <title>Order Info</title>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <meta name="viewport" content="width=device-width, initial-scale=1">
      <meta http-equiv="X-UA-Compatible" content="IE=edge" />
      <style type="text/css">
        body,
        table,
        td,
        a {
          -webkit-text-size-adjust: 100%;
          -ms-text-size-adjust: 100%;
        }
    
        table,
        td {
          mso-table-lspace: 0pt;
          mso-table-rspace: 0pt;
        }
    
        img {
          -ms-interpolation-mode: bicubic;
        }
    
        img {
          border: 0;
          height: auto;
          line-height: 100%;
          outline: none;
          text-decoration: none;
        }
    
        table {
          border-collapse: collapse !important;
        }
    
        body {
          height: 100% !important;
          margin: 0 !important;
          padding: 0 !important;
          width: 100% !important;
        }
    
    
        a[x-apple-data-detectors] {
          color: inherit !important;
          text-decoration: none !important;
          font-size: inherit !important;
          font-family: inherit !important;
          font-weight: inherit !important;
          line-height: inherit !important;
        }
    
        @media screen and (max-width: 480px) {
          .mobile-hide {
            display: none !important;
          }
    
          .mobile-center {
            text-align: center !important;
          }
        }
    
        div[style*="margin: 16px 0;"] {
          margin: 0 !important;
        }
    
        p {
          display: block;
          margin-block-start: 0.25em;
          margin-block-end: 0.25em;
          margin-inline-start: 0px;
          margin-inline-end: 0px;
        }
      </style>
    
    </head>
    
    <body style="margin: 0 !important; padding: 0 !important; background-color: #eeeeee;" bgcolor="#eeeeee">
    
    
      <table border="0" cellpadding="0" cellspacing="0" width="100%">
        <tr>
          <td align="center" style="background-color: #eeeeee;" bgcolor="#eeeeee">
    
            <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%"
              style="max-width:600px; padding: 10px; background-color: #ffffff;" bgcolor="#ffffff">`;

                let html_body = `<tr>
              <td align="start"
                style="font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 24px; padding: 5px 10px;">
                <h2 style="font-size: 16px; font-weight: 400; line-height: 36px; color: #333333; margin: 0;">
                  ${labels.title_Hello} ${data.User.firstName} ${data.User.lastName},
                  <br>
                    ${userformessage}
                </h2>
              </td>
              </tr>

              <tr>
              <td align="center" style="padding: 10px; background-color: #ffffff;" bgcolor="#ffffff">
                <table align="center" border="0" cellpadding="0" cellspacing="0" width="100%" style="max-width:600px;">
                  <tr>
                    <td align="start">
                      <img src="${logo}" width="37" height="37" style="display: block; border: 0px;" />
                    </td>
                  </tr>
                  <tr>
                    <td align="start"
                      style="font-family: Open Sans, Helvetica, Arial, sans-serif; font-size: 14px; font-weight: 400; line-height: 24px; padding: 5px 0 10px 0;">
                      <p style="font-size: 14px; font-weight: 800; line-height: 18px; color: #333333;">
                        ${labels.thank_regard}
                        <br>
                         ${contact_us.org_name}
                        <br>
                        <span style="font-weight: 400;">
                          ${contact_us.address}
                        </span>
                        <br> ${labels.Mobile_No_label} : <span style="font-weight: 400;"> ${contact_us.phone}</span>
                        <br> ${labels.E_mail_label}: <a href="mailto:${contact_us.email_id}" style="font-weight: 400;"  target="_blank">${contact_us.email_id}</a>
                        <br> ${labels.title_site} : ${location.site_url}
                        <br>
                        Powered by: <a href="https://onlinetandoorivilla.fi/" style="font-weight: 400;"  target="_blank"> Tandoorivilla</a>
                      </p>
                    </td>
                  </tr>
                </table>
              </td>
              </tr>`;


                let html_footer = `</table>
              </td>
            </tr>
          </table>
          </body>
          </html>`;

                html = html_head + html_body + html_footer;


            }



            // Create a transporter with SMTP configuration
            const transporter = nodemailer.createTransport({
                host: email_settings.emailHost,
                // port: process.env.SMTP_PORT,
                secure: false, // true for 465, false for other ports
                auth: {
                    user: email_settings.systemMailId,
                    pass: email_settings.password
                }
            });

            // Define email options
            const mailOptions = {
                from: `${email_settings.systemMailId}`,
                to: to_mail,
                subject: subject,
                text: 'Order update',
                html: html
            };

            // Send email

            transporter.sendMail(mailOptions, (error, info) =>
            {
                if (error)
                {
                    console.log(error);
                    let statusCode;
                    switch (error.code)
                    {
                        case 'EAUTH':
                            statusCode = 401;
                            break;
                        case 'ECONNECTION':
                            statusCode = 500;
                            break;
                        case 'EENVELOPE':
                            statusCode = 400;
                            break;
                        case 'ETIMEDOUT':
                            statusCode = 504;
                            break;
                        case 'EMESSAGE':
                            statusCode = 400;
                            break;
                        default:
                            statusCode = 500;
                    }
                    console.error('Error sending email:', error);
                    resolve({ status_code: statusCode, status: false, mail_response: error.message });
                } else
                {

                    console.log('Email sent:', info.response);
                    resolve({ status_code: 200, status: true, mail_response: info.response });
                }
            })

        } catch (error)
        {
            console.log(error);
            return { status_code: 500, status: false, message: 'Server error2' };
        }

    })
}



async function getOrderDetails ({ req })
{


    const { loc_id } = req;
    const { User, Order, DeliveryType, PaymentMode } = req.models;
    const { order_id, order_number } = req.query;

    try
    {

        let replacements = {};

        if (order_id)
        {
            // query += ' and orders.order_id = :order_id';
            replacements.order_id = order_id;
        } else if (order_number)
        {
            // query += ' and orders.rand_order_no = :rand_order_no';
            replacements.rand_order_no = order_number;
        }


        const order_details = await Order.findOne({
            where: {
                loc_id: loc_id,
                ordersStatusId: [3, 4, 5, 6, 7],
                ...replacements
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





        // let query = `SELECT users.first_name,users.last_name,users.user_email,orders.user_fullname,orders.waiter_id,orders.user_mobile_no,orders.order_id,orders.delivery_partner_cost,orders.partner_statusInformation,orders.rand_order_no,orders.delivery_boy_name,orders.delivery_boy_mob_no,orders.order_datetime,orders.address,orders.zipcode,orders.city,orders.building_no,orders.additional_info,orders.delivery_type_id,orders.delivery_partner_id,delivery_type_master.delivery_type_${lang_id} as delivery_type_title,delivery_type_master.delivery_type_img,payment_mode_master.payment_mode_lang_${lang_id} as payment_mode_lang_title,orders.payment_mode_id,orders.payment_status_id,orders.orders_status_id,orders.pre_order_booking,orders.table_booking,orders.table_booking_duration,orders.table_booking_people,orders.send_email_order_set_time,orders.send_sms_order_set_time,orders.send_email_order_ontheway,orders.send_sms_order_ontheway,orders.send_email_order_cancel,orders.send_sms_order_cancel,orders.order_language_id,orders.order_timer_start_time,orders.set_order_minut_time,orders.food_item_subtotal_amt,orders.total_item_tax_amt,orders.discount_amt,orders.reg_offer_amount,orders.delivery_charges,orders.extra_delivery_charges,orders.Minimum_order_price,orders.grand_total,orders.final_payable_amount,orders.order_from,orders.qrcode_order_label,orders.bonus_value_used,orders.bonus_value_get,orders.user_id,orders.done_status,orders.distance as order_user_distance,orders.pre_order_response_alert_time,orders.table_booking_response_alert_time,orders.fcm_token  FROM orders INNER JOIN users ON orders.user_id=users.user_id INNER JOIN delivery_type_master ON orders.delivery_type_id=delivery_type_master.delivery_type_id INNER JOIN payment_mode_master ON orders.payment_mode_id=payment_mode_master.payment_mode_id WHERE orders.loc_id = ${loc_id}`;



        if (order_details)
        {
            return { status_code: 200, status: true, order_details };
        }
        else
        {
            return { status_code: 404, status: false, message: "Order not found" };
        }

    } catch (error)
    {
        console.log(error);
        return { status_code: 500, status: false, message: 'Server error' };
    }
}



async function getOrderItemToppings ({ sequelize, loc_id, order_food_item_id, order_number, lang_id })
{

    try
    {

        let query = `SELECT order_varients.food_varient_option_type_id,master_food_varient_option_type.food_varient_option_type_${lang_id} as toppingsheading,master_food_varient_options_topping.food_varient_option_title_${lang_id} as toppingslistname,order_varients.food_varient_option_base_price,order_varients.food_varient_option_price,order_varients.item_adding_topping_types FROM order_varients INNER JOIN master_food_varient_option_type ON order_varients.food_varient_option_type_id=master_food_varient_option_type.food_varient_option_type_id INNER JOIN master_food_varient_options ON order_varients.food_varient_option_id=master_food_varient_options.food_varient_option_id INNER JOIN master_food_varient_options_topping ON master_food_varient_options.food_varient_options_topping_id=master_food_varient_options_topping.food_varient_options_topping_id WHERE order_varients.order_food_item_id= :order_food_item_id and master_food_varient_option_type.loc_id=${loc_id} order BY order_varients.item_adding_topping_types`;

        let replacements = { order_food_item_id };

        const order_item_toppings = await sequelize.query(query, {
            replacements,
            type: sequelize.QueryTypes.SELECT
        });


        if (order_item_toppings.length > 0)
        {
            return order_item_toppings;
        }
        else
        {
            return [];
        }

    } catch (error)
    {
        console.log(error);
        return { status_code: 500, status: false, message: 'Server error' };
    }
}


async function getComboOffersbyid ({ sequelize, loc_id, combo_offer_id, lang_id })
{

    try
    {

        let query = `SELECT combo_offer_id, combo_offer_name_${lang_id} AS combo_offer_name, total_price, total_product_count, active_status 
FROM combo_offers WHERE loc_id = ${loc_id}  AND combo_offer_id = ${combo_offer_id} ORDER BY combo_offer_id`;

        let replacements = {};

        const combo_offer = await sequelize.query(query, {
            replacements,
            type: sequelize.QueryTypes.SELECT
        });

        // console.log("combo_offer:"+combo_offer);

        if (combo_offer.length > 0)
        {
            return combo_offer;
        }
        else
        {
            return [];
        }

    } catch (error)
    {
        console.log(error);
        return { status_code: 500, status: false, message: 'Server error' };
    }
}


async function getItemSizeName ({ sequelize, loc_id, item_size_id, lang_id })
{

    try
    {

        let query = `SELECT master_food_varient_options_topping.food_varient_option_title_${lang_id} as item_size_name FROM master_food_varient_options_topping INNER JOIN master_food_varient_options ON master_food_varient_options_topping.food_varient_options_topping_id=master_food_varient_options.food_varient_options_topping_id WHERE master_food_varient_options.loc_id=:loc_id and master_food_varient_options.food_varient_option_id=:item_size_id`;

        let replacements = { item_size_id, loc_id };

        const size_data = await sequelize.query(query, {
            replacements,
            type: sequelize.QueryTypes.SELECT
        });

        // console.log(size_data);

        // console.log("combo_offer:"+combo_offer);

        if (size_data.length > 0)
        {
            return size_data[0].item_size_name;
        }
        else
        {
            return '';
        }

    } catch (error)
    {
        console.log(error);
        return { status_code: 500, status: false, message: 'Server error' };
    }
}




async function getOrderComboOfferItems ({ sequelize, loc_id, order_id, lang_id, data_entry_type })
{

    try
    {

        let query = `SELECT  order_food_items.combo_offer_id,order_food_items.combo_offer_set_id,order_food_items.combo_product_type, order_food_items.order_food_item_id,master_food_items.food_item_name_${lang_id} as food_item_name,master_food_items.food_item_image,order_food_items.basic_price,order_food_items.item_order_qty,order_food_items.total_basic_price,order_food_items.item_total_toppings_price,order_food_items.food_extratext,order_food_items.size_id,order_food_items.food_test_id  FROM order_food_items INNER JOIN master_food_items ON order_food_items.food_item_id=master_food_items.food_item_id  WHERE order_food_items.combo_offer_id!=0  and order_food_items.order_id = :order_id`;

        let replacements = { order_id };

        let combo_offer_items = await sequelize.query(query, {
            replacements,
            type: sequelize.QueryTypes.SELECT
        });

        if (combo_offer_items.length > 0)
        {

            let combo_data = {};
            for (let item of combo_offer_items)
            {

                let combo_offer_id = item.combo_offer_id;
                let combo_offer_set_id = item.combo_offer_set_id;

                if (!combo_data.hasOwnProperty(combo_offer_set_id))
                {
                    // Function to get combo offer details including name
                    let combo_offer_details = await getComboOffersbyid({ sequelize, loc_id, combo_offer_id, lang_id });
                    // console.log(combo_offer_details);
                    if (combo_offer_details.length > 0)
                    {
                        let combo_name = combo_offer_details[0].combo_offer_name;
                        let combo_total_price = combo_offer_details[0].total_price;
                        combo_data[combo_offer_set_id] = {
                            combo_name: combo_name,
                            total_price: combo_total_price,
                            combo_offer_id: combo_offer_id,
                            combo_offer_set_id: combo_offer_set_id,
                            order_items: []
                        };

                    }
                    else
                    {

                        return [];
                    }
                }

                let item_basic_price = Number(item.basic_price).toFixed(2);
                let total_basic_price = Number(item.total_basic_price).toFixed(2);
                let item_order_qty = item.item_order_qty;
                let food_item_name = item.food_item_name;
                let order_food_item_id = item.order_food_item_id;
                let item_size_id = item.size_id;
                let food_test_id = item.food_test_id;
                let food_extratext = item.food_extratext;
                let combo_product_type = item.combo_product_type;
                let item_total_toppings_price = Number(item.item_total_toppings_price).toFixed(2);
                let total_item_price_with_toppings = (parseFloat(total_basic_price) + parseFloat(item_total_toppings_price)).toFixed(2);
                combo_data[combo_offer_set_id].total_price += parseFloat(total_item_price_with_toppings);
                let item_size_name;


                if (data_entry_type === 'single')
                {
                    item_size_name = await getItemSizeName({ sequelize, loc_id: 1, item_size_id, lang_id });
                } else
                {
                    item_size_name = await getItemSizeName({ sequelize, loc_id, item_size_id, lang_id });
                }



                // if (result_getItemSizeName) {
                //     item_size_name = result_getItemSizeName.item_size_name;
                // }

                const toppings = await getOrderItemToppings({ sequelize, loc_id, order_food_item_id: item.order_food_item_id, lang_id });

                combo_data[combo_offer_set_id].order_items.push({
                    order_food_item_id: order_food_item_id,
                    food_item_name: food_item_name,
                    food_item_image: item.food_item_image,
                    basic_price: item_basic_price,
                    total_basic_price: total_basic_price,
                    item_order_qty: item_order_qty,
                    item_total_toppings_price: item_total_toppings_price,
                    food_extratext: food_extratext,
                    size_id: item_size_id,
                    item_size_name: item_size_name,
                    food_test_id: food_test_id,
                    combo_product_type: combo_product_type,
                    toppings
                    // currency: currency // You need to define this variable
                });

            };

            return Object.values(combo_data);

        }

        else
        {

            return [];
        }

    } catch (error)
    {
        console.log(error);
        return { status_code: 500, status: false, message: 'Server error' };
    }
}





function decryptPass (string)
{
    const sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';
    const truncatedSalt = crypto.createHash('sha256').update(sSalt).digest();
    const method = 'aes-256-cbc';

    const iv = Buffer.alloc(16, 0); // Initialization Vector

    const decipher = crypto.createDecipheriv(method, truncatedSalt, iv);

    let decrypted = decipher.update(Buffer.from(string, 'base64'), 'binary', 'utf8');
    decrypted += decipher.final('utf8');

    return decrypted;
}


function decryptPassWithKey16 (encrypted, key)
{

    if (encrypted != null && encrypted !== "")
    {

        const sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';

        // Adjust salt to 16 bytes
        const salt = Buffer.from(crypto.createHash('sha256').update(sSalt).digest(), 'binary').slice(0, 16);

        // Combine key with salt and hash them
        const combinedKey = Buffer.concat([salt, Buffer.from(key, 'utf8')]);
        const hashedKey = crypto.createHash('sha256').update(combinedKey).digest();

        const method = 'aes-256-cbc';

        // Decode the base64-encoded string
        const encryptedBuffer = Buffer.from(encrypted, 'base64');

        // Extract the IV and the encrypted string
        const iv = encryptedBuffer.slice(0, 16);
        const encryptedString = encryptedBuffer.slice(16);

        try
        {
            const decipher = crypto.createDecipheriv(method, hashedKey, iv);
            let decrypted = decipher.update(encryptedString);
            decrypted = Buffer.concat([decrypted, decipher.final()]);
            return decrypted.toString('utf8');
        } catch (error)
        {
            return 'Decryption error: ' + 'Server error';
        }
    }
    else
    {
        return encrypted;
    }
}


function decryptPassWithKey (encrypted, key)
{

    if (encrypted != null && encrypted !== "")
    {
        const sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';

        // Adjust salt to 16 bytes
        const salt = crypto.createHash('sha256').update(sSalt).digest().slice(0, 16);

        // Combine key with salt and hash them
        const combinedKey = Buffer.concat([salt, Buffer.from(key, 'utf8')]);
        const hashedKey = crypto.createHash('sha256').update(combinedKey).digest().slice(0, 32);

        const method = 'aes-256-cbc';

        // Decode the base64-encoded string
        const encryptedBuffer = Buffer.from(encrypted, 'base64');

        // Extract the IV and the encrypted string
        const ivLength = crypto.getCipherInfo(method).ivLength;
        const iv = encryptedBuffer.slice(0, ivLength);
        const encryptedString = encryptedBuffer.slice(ivLength);

        try
        {
            const decipher = crypto.createDecipheriv(method, hashedKey, iv);
            let decrypted = decipher.update(encryptedString, 'binary', 'utf8');
            decrypted += decipher.final('utf8');
            return decrypted;
        } catch (error)
        {
            return 'Decryption error: ' + 'Server error';
        }
    }
    else
    {
        return encrypted;
    }
}


function encryptPassWithKey (string, key)
{

    if (string != null && string !== "")
    {


        const sSalt = '20adeb83e85f03cfc84d0fb7e5f4d290';

        // Adjust salt to 16 bytes
        const salt = Buffer.from(crypto.createHash('sha256').update(sSalt).digest(), 'binary').slice(0, 16);

        // Combine key with salt and hash them
        const combinedKey = Buffer.concat([salt, Buffer.from(key, 'utf8')]);
        const hashedKey = crypto.createHash('sha256').update(combinedKey).digest();

        const method = 'aes-256-cbc';


        // Generate a secure IV
        const iv = crypto.createHash('sha256').update(sSalt).digest().slice(0, 16);

        try
        {
            const cipher = crypto.createCipheriv(method, hashedKey, iv);
            let encrypted = cipher.update(string, 'utf8', 'binary');
            encrypted += cipher.final('binary');

            // Combine the IV and the encrypted string
            const encryptedBuffer = Buffer.concat([iv, Buffer.from(encrypted, 'binary')]);
            return encryptedBuffer.toString('base64');
        } catch (error)
        {
            return 'Encryption error: ' + 'Server error';
        }
    }
    else
    {
        return string;
    }
}

// function convertToFinlandTime(utcDateTime) {
//   const zonedTime = utcToZonedTime(utcDateTime, finlandTimeZone);
//   return zonedTime;
// }







//**
//  * Function to calculate authcode based on the input string and private key
//  * @param {string} input - The concatenated string (api_key|order_number or token)
//  * @param {string} privateKey - The private key for the Visma API
//  * @returns {string} - The authcode hash
//  */
function calcAuthcode (input, privateKey)
{
    return crypto.createHmac('sha256', privateKey).update(input).digest('hex').toUpperCase();
}

/**
 * Function to check the payment status using the order number
 * @param {string} apiKey - The API key for the Visma API
 * @param {string} privateKey - The private key for the Visma API
 * @param {string} orderNumber - The order number to check the payment status for
 */
async function checkStatusWithOrderNumber (apiKey, privateKey, orderNumber)
{
    // Input validation
    if (!apiKey || !privateKey || !orderNumber)
    {
        return { status_code: 400, status: false, message: 'Missing required parameters: apiKey, privateKey, or orderNumber' };
    }

    // Create authcode based on API key and order number
    const authcodeInput = `${apiKey}|${orderNumber}`;
    const authcode = calcAuthcode(authcodeInput, privateKey);

    // Payload to send to Visma Pay API
    const params = {
        version: 'w3.2', // Assuming API version 3.2; update if needed
        api_key: apiKey,
        order_number: orderNumber,
        authcode: authcode,
    };

    try
    {
        // Making the POST request to the Visma Pay API
        const response = await axios.post(`https://www.vismapay.com/pbwapi/check_payment_status`, params, {
            headers: {
                'Content-Type': 'application/json',
            },
        });

        // Log and return the payment status
        console.log('Payment Status:', response.data);
        return { status_code: 200, status: true, data: response.data };
    } catch (error)
    {
        // Catch and handle errors
        return { status_code: 500, status: false, message: error.message };
    }
}

async function getOrderEmailLabels (sequelize, order_lang_id)
{


    const query = `SELECT (SELECT title from admin_dashboard_content where header='order no title' and language_id='${order_lang_id}' ) as order_no_title ,(SELECT title from admin_dashboard_content where header='title_delivered_to' and language_id='${order_lang_id}' ) as title_delivered_to,(SELECT title from admin_dashboard_content where header='title_can_be_picked_up' and language_id='${order_lang_id}' ) as title_can_be_picked_up,(SELECT title from admin_dashboard_content where header='title_can_be_Ready_to_serve_in' and language_id='${order_lang_id}' ) as title_can_be_Ready_to_serve_in ,(SELECT title from admin_dashboard_content where header='title_Hello' and language_id='${order_lang_id}' ) as title_Hello ,(SELECT title from admin_dashboard_content where header='thank regard' and language_id='${order_lang_id}' ) as thank_regard ,(SELECT title from admin_dashboard_content where header='Mobile No label' and language_id='${order_lang_id}' ) as Mobile_No_label ,(SELECT title from admin_dashboard_content where header='E-mail label' and language_id='${order_lang_id}' ) as E_mail_label ,(SELECT title from admin_dashboard_content where header='title_site' and language_id='${order_lang_id}' ) as title_site ,(SELECT title from admin_dashboard_content where header='title_delivered_to_middle' and language_id='${order_lang_id}' ) as title_delivered_to_middle ,(SELECT title from admin_dashboard_content where header='title_delivered_to_last' and language_id='${order_lang_id}' ) as title_delivered_to_last ,(SELECT title from admin_dashboard_content where header='title_can_be_picked_up_middle' and language_id='${order_lang_id}' ) as title_can_be_picked_up_middle,(SELECT title from admin_dashboard_content where header='title_it_on_the_way' and language_id='${order_lang_id}' ) as title_it_on_the_way,(SELECT title from admin_dashboard_content where header='title_is_ready_to_pick' and language_id='${order_lang_id}' ) as title_is_ready_to_pick,(SELECT title from admin_dashboard_content where header='title_is_ready_to_serve' and language_id='${order_lang_id}' ) as title_is_ready_to_serve,(SELECT title from admin_dashboard_content where header='title_is_on_the_way' and language_id='${order_lang_id}' ) as title_is_on_the_way,(SELECT title from admin_dashboard_content where header='title_was_cancelled' and language_id='${order_lang_id}' ) as title_was_cancelled   FROM admin_dashboard_content limit 1`;
    // console.log('pre-order:'+query);

    try
    {
        const labels = await sequelize.query(query, {
            type: sequelize.QueryTypes.SELECT
        });


        if (labels.length > 0)
        {

            return { status_code: 200, status: true, data: labels[0] };

        }
        else
        {
            return { status_code: 503, status: false, message: 'Something went wrong' };
        }


    } catch (error)
    {
        return { status_code: 500, status: false, message: 'Server error' };
    }
}


module.exports = {
    setPreOrderToCurrentOrder,
    mailTo,
    getOrderDetails,
    encryptPassWithKey,
    decryptPass,
    decryptPassWithKey,
    getOrderItemToppings,
    getComboOffersbyid,
    getOrderComboOfferItems,
    getItemSizeName,
    checkStatusWithOrderNumber

};