const { superSequelize } = require('../models');
const validator = require('validator');
exports.getGeneralData = async (req, res) =>
{

  const { shopSequelize, loc_id } = req;
    const lang_id = req.lang_id
  try
  {

    const contactUs = await shopSequelize.query(`SELECT org_name_${lang_id} as org_name,address_lang_${lang_id} as address,email_id,phone,online_ordering,online_ordering_feature,pre_booking,pre_booking_feature,print_no_of_copy,print_style,device_type_print,orientation,org_city,org_zipcode,latitude,longitude FROM contact_us where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });

    const locationInfo = await shopSequelize.query(`SELECT loc_name,dis_name,loc_address,loc_image,loc_logo,loc_favicon,display_order,active_status,active_email_status,deactive_email_status,website,businessid,location_type,website_type,site_url FROM location_master where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });

    const orderResponseTime = await shopSequelize.query(`select response_interval,max_duration from response_time_setting where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });


    return res.json({status_code:200, status: true, data: { "contact_us": contactUs[0], "location_master":locationInfo[0], "order_response_time":orderResponseTime[0] } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({status_code:500, status: false, message: error.message });
  }
};

exports.getLanguageData = async (req, res) =>
{
  let lang_id = req.header('lang-id');
  if (!lang_id)
  {
   lang_id = 2;
  } 
  else{
    const sanitized_lang_id = validator.escape(lang_id);
console.log("sanitizedInput:"+sanitized_lang_id); 
    
  }
  try
  {
    const language_master = await superSequelize.query(`SELECT * FROM admin_dashboard_content WHERE language_id =${lang_id}`, {
      type: superSequelize.QueryTypes.SELECT,
    });

     // Transform the results into the desired JSON format
    const language_data = language_master.reduce((acc, row) => {
       const typeKey = `type${row.type}`;
      // acc[row['header']] = row['title'];

   // Initialize the type key if it doesn't exist
    if (!acc[typeKey]) {
      acc[typeKey] = {};
    }

    // Add the key-value pair to the appropriate type object
    acc[typeKey][row.header] = row.title;



      return acc;
    }, {});




    return res.json({status_code:200, status: true, data: { language_data } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({status_code:500, status: false, message: error.message });
  }
};



exports.getAppVersion = async (req, res) =>
{

  try
  {

    return res.json({status_code:200, status: true, data: { version:"1.0", update_url:"https://play.google.com/store/apps/details?id=com.foozu3.admin" } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({status_code:500, status: false, message: error.message });
  }
};
