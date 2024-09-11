const { superSequelize } = require('../models/super_admin');
const validator = require('validator');
exports.getGeneralData = async (req, res) =>
{

  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  try
  {

    const contactUs = await shopSequelize.query(`SELECT org_name_${lang_id} as org_name,address_lang_${lang_id} as address,email_id,phone,businessid,online_ordering,online_ordering_feature,pre_booking,pre_booking_feature,print_no_of_copy,print_style,device_type_print,orientation,org_city,org_zipcode,latitude,longitude FROM contact_us where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });

    const locationInfo = await shopSequelize.query(`SELECT loc_name,dis_name,loc_address,loc_image,loc_logo,loc_favicon,display_order,active_status,active_email_status,deactive_email_status,website,businessid,location_type,website_type,site_url FROM location_master where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });

    const orderResponseTime = await shopSequelize.query(`select response_interval,max_duration from response_time_setting where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });


    return res.json({ status_code: 200, status: true, data: { "contact_us": contactUs[0], "location_master": locationInfo[0], "order_response_time": orderResponseTime[0] } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};

exports.getLanguageData = async (req, res) =>
{
  let lang_id = req.header('lang-id');
  if (!lang_id)
  {
    lang_id = 2;
  }
  else
  {
    const sanitized_lang_id = validator.escape(lang_id);
    console.log("sanitizedInput:" + sanitized_lang_id);

  }
  try
  {
    const language_master = await superSequelize.query(`SELECT * FROM admin_dashboard_content WHERE language_id =${lang_id}`, {
      type: superSequelize.QueryTypes.SELECT,
    });

    // Transform the results into the desired JSON format
    const language_data = language_master.reduce((acc, row) =>
    {
      const typeKey = `type${row.type}`;
      // acc[row['header']] = row['title'];

      // Initialize the type key if it doesn't exist
      if (!acc[typeKey])
      {
        acc[typeKey] = {};
      }

      // Add the key-value pair to the appropriate type object
      acc[typeKey][row.header] = row.title;



      return acc;
    }, {});




    return res.json({ status_code: 200, status: true, data: { language_data } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};



exports.getAppVersion = async (req, res) =>
{

  try
  {

    return res.json({ status_code: 200, status: true, data: { version: "1.0", update_url: "https://play.google.com/store/apps/details?id=com.foozu3.admin" } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};


exports.getFoodDisplayData = async (req, res) =>
{

  const { loc_id } = req;
  const { CategoryVariantType, MasterFoodCategory, MasterFoodItems } = req.models;

  try
  {
    const food_display_data = await CategoryVariantType.findAll({
      where: {
        loc_id: loc_id,
        hide_status: 1
      },
      include: [
        {
          model: MasterFoodCategory,
          where: {
            loc_id: loc_id,
            category_display: 1,
            is_category_deleted: 1
          },
          include: [

            {
              model: MasterFoodItems,
              where: {
                loc_id: loc_id,
                is_active: 1
              },
            }

          ]
        },

      ],
      // order: [['catgVariantTypeId', 'ASC']],
    });

    return res.json({ status_code: 200, status: true, data: food_display_data });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};

exports.getMenuCategories = async (req, res) =>
{

  const { loc_id } = req;
  const { CategoryVariantType } = req.models;




  try
  {
    const menu_categories = await CategoryVariantType.findAll({
      where: {
        loc_id: loc_id,
        hide_status: 1
      },
      // order: [['catgVariantTypeId', 'ASC']],
    });


    if (menu_categories.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { menu_categories } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Menu categories not found" });
    }




  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};
exports.getFoodCategories = async (req, res) =>
{

  const { loc_id } = req;
  const { menu_category_id } = req.query;
  const { MasterFoodCategory } = req.models;


  if (!menu_category_id)
  {
    return res.status(400).json({ status_code: 400, status: false, message: "Missing menu category id" });
  }

  try
  {
    const food_categories = await MasterFoodCategory.findAll({
      where: {
        loc_id: loc_id,
        // hide_status: 1
        catg_variant_type_id: menu_category_id
      },
      // order: [['catgVariantTypeId', 'ASC']],
    });

    if (food_categories.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { food_categories } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Food categories not found" });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};
exports.getFoodItems = async (req, res) =>
{

  const { loc_id } = req;
  const { food_category_id } = req.query;
  const { MasterFoodItems } = req.models;


  if (!food_category_id)
  {
    return res.status(400).json({ status_code: 400, status: false, message: "Missing food category id" });
  }

  try
  {
    const food_items = await MasterFoodItems.findAll({
      where: {
        loc_id: loc_id,
        food_item_category_id: food_category_id
      },
      // order: [['catgVariantTypeId', 'ASC']],
    });

    if (food_items.length > 0)
    {

      return res.json({ status_code: 200, status: true, data: { food_items } });
    }
    else
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Food items not found" });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};


exports.updateFoodItemDisplayStatus = async (req, res) =>
{

  const { loc_id } = req;
  const { food_item_id, display_status } = req.query;
  const { MasterFoodItems } = req.models;


  if (!food_item_id)
  {
    return res.status(400).json({ status_code: 400, status: false, message: "Missing food item id" });
  }
  else if (!display_status || display_status <0 || display_status >1)
  {
    return res.status(400).json({ status_code: 400, status: false, message: "Missing or incorrect food item display status" });
  }

  try
  {
    const food_item = await MasterFoodItems.findOne({
      where: {
        loc_id: loc_id,
        food_item_id: food_item_id
      },
    });

    if (!food_item)
    {
      return res.status(404).json({ status_code: 404, status: false, message: "Food item not found" });

    }
    else
    {


      await MasterFoodItems.update(
        { display: display_status },
        {
          where: {
            loc_id: loc_id,
            food_item_id: food_item_id
          },
        });


      return res.json({ status_code: 200, status: true });

    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};




// Fetch Visiting Timings
exports.getVisitingTimings = async (req, res) => {
  const { loc_id } = req;
    const { VisitingTiming } = req.models;
  try {
    const visting_timings = await VisitingTiming.findAll({
      where: { loc_id },
    });
  return res.json({ status_code: 200, status: true, data: { visting_timings } });
  } catch (error) {
    console.log(error);
    res.status(500).json({ error: 'Error fetching visiting timings' });
  }
};

// Fetch Lunch Timings
exports.getLunchTimings = async (req, res) => {
 const { loc_id } = req;
    const { LunchTiming } = req.models;
  try {
    const lunch_timings = await LunchTiming.findAll({
      where: { loc_id },
    });
       return res.json({ status_code: 200, status: true, data: { lunch_timings } });
  } catch (error) {
    res.status(500).json({ error: 'Error fetching lunch timings' });
  }
};

// Fetch Delivery Timings
exports.getDeliveryTimings = async (req, res) => {
  const { loc_id } = req;
    const { DeliveryTiming } = req.models;
  try {
    const delivery_timings = await DeliveryTiming.findAll({
      where: { loc_id },
    });
   return res.json({ status_code: 200, status: true, data: {delivery_timings } });
  } catch (error) {
    res.status(500).json({ error: 'Error fetching delivery timings' });
  }
};


