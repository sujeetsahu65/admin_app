const { superSequelize } = require('../models/super_admin');
const validator = require('validator');
const { body, validationResult } = require('express-validator');
exports.getGeneralData = async (req, res) =>
{

  const { shopSequelize, loc_id } = req;
  const lang_id = req.lang_id
  try
  {

    const contactUs = await shopSequelize.query(`SELECT org_name_${lang_id} as org_name,address_lang_${lang_id} as address,email_id,phone,businessid,online_ordering,online_ordering_feature,pre_booking,pre_booking_feature,print_no_of_copy,print_style,device_type_print,orientation,org_city,org_zipcode,latitude,longitude FROM contact_us where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });
    const generalSettings = await shopSequelize.query(`SELECT home_delivery_feature,online_ordering_feature FROM general_settings where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });

    const locationInfo = await shopSequelize.query(`SELECT loc_name,dis_name,loc_address,loc_image,loc_logo,loc_favicon,display_order,active_status,active_email_status,deactive_email_status,website,businessid,location_type,website_type,site_url FROM location_master where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });

    const orderResponseTime = await shopSequelize.query(`select response_interval,max_duration from response_time_setting where loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });


    return res.json({ status_code: 200, status: true, data: { "contact_us": contactUs[0], "location_master": locationInfo[0], "order_response_time": orderResponseTime[0], "general_settings":generalSettings[0] } });

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
  else if (!display_status || display_status < 0 || display_status > 1)
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
exports.getVisitingTimings = async (req, res) =>
{
  const { loc_id } = req;
  const { VisitingTiming } = req.models;
  try
  {
    const visiting_timings = await VisitingTiming.findAll({
      where: { loc_id },
    });
    return res.json({ status_code: 200, status: true, data: { visiting_timings } });
  } catch (error)
  {
    console.log(error);
    res.status(500).json({ error: 'Error fetching visiting timings' });
  }
};

// Fetch Lunch Timings
exports.getLunchTimings = async (req, res) =>
{
  const { loc_id } = req;
  const { LunchTiming } = req.models;
  try
  {
    const lunch_timings = await LunchTiming.findAll({
      where: { loc_id },
    });
    return res.json({ status_code: 200, status: true, data: { lunch_timings } });
  } catch (error)
  {
    res.status(500).json({ error: 'Error fetching lunch timings' });
  }
};

// Fetch Delivery Timings
exports.getDeliveryTimings = async (req, res) =>
{
  const { loc_id } = req;
  const { DeliveryTiming, } = req.models;
  try
  {
    const delivery_timings = await DeliveryTiming.findAll({
      where: { loc_id },
    });
    return res.json({ status_code: 200, status: true, data: { delivery_timings } });
  } catch (error)
  {
    res.status(500).json({ error: 'Error fetching delivery timings' });
  }
};




exports.updateShopTimings = [
  // Validation middleware
  body('table_name')
    .isIn(['visiting_timings', 'lunch_timings', 'delivery_timings'])
    .withMessage('Invalid table name'),
  
  body('day_number')
    .isInt({ min: 1, max: 7 })
    .withMessage('day_number must be an integer between 1 and 7'),
  
  body('field')
    .isIn(['fromTime', 'toTime', 'closeStatus'])
    .withMessage('Invalid field name'),
  
  body('new_value')
    .custom(async (value, { req }) => {
      const timeRegex = /^([01]\d|2[0-3]):([0-5]\d)(:[0-5]\d)?$/;
      const { field, day_number, table_name } = req.body;
      
      // Validate time format or boolean for closeStatus
      if (field === 'closeStatus') {
        if (typeof value !== 'boolean') {
          throw new Error('closeStatus must be a boolean');
        }
      } else if (!timeRegex.test(value)) {
        throw new Error('Invalid time format, expected HH:mm or HH:mm:ss');
      } else {
        // Get models
           const { loc_id } = req;
        const { VisitingTiming, LunchTiming, DeliveryTiming } = req.models;
        let model;
        
        if (table_name === 'visiting_timings') {
          model = VisitingTiming;
        } else if (table_name === 'lunch_timings') {
          model = LunchTiming;
        } else if (table_name === 'delivery_timings') {
          model = DeliveryTiming;
        } else {
          throw new Error('Invalid table name');
        }

        // Fetch the current timing record from the database
        const timing = await model.findOne({ where: { dayNumber: day_number, loc_id } });
        if (!timing) {
          throw new Error('Timing record not found');
        }

        const currentFromTime = timing.fromTime;
        const currentToTime = timing.toTime;

        // Compare new_value with current values based on field
        const fromTime = field === 'fromTime' ? value : currentFromTime;
        const toTime = field === 'toTime' ? value : currentToTime;

        // Convert time to minutes for easier comparison
        const timeToMinutes = (time) => {
          const [hours, minutes] = time.split(':').map(Number);
          return hours * 60 + minutes;
        };

        const fromTimeMinutes = timeToMinutes(fromTime);
        const toTimeMinutes = timeToMinutes(toTime);

        // Validate fromTime (must not be before 06:00)
        if (field === 'fromTime' && fromTimeMinutes < 360) {
          throw new Error('fromTime cannot be before 06:00');
        }

        // Validate toTime (must not be before fromTime, unless it's allowed for next-day closure)
        if (field === 'toTime') {
          if (toTimeMinutes < fromTimeMinutes && toTimeMinutes >= 360) {
            throw new Error('toTime cannot be earlier than fromTime within the same day.');
          }
          if (toTimeMinutes >= 360 && fromTimeMinutes >= 360 && toTimeMinutes < fromTimeMinutes) {
            throw new Error('toTime cannot be earlier than fromTime.');
          }
        }
      }
      return true;
    }),

  // Route handler
  async (req, res) => {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    const { loc_id } = req;
    const { table_name, day_number, field, new_value } = req.body;
    const { DeliveryTiming, VisitingTiming, LunchTiming } = req.models;

    try {
      let model;

      // Determine the model based on the table_name
      if (table_name === 'visiting_timings') {
        model = VisitingTiming;
      } else if (table_name === 'lunch_timings') {
        model = LunchTiming;
      } else if (table_name === 'delivery_timings') {
        model = DeliveryTiming;
      } else {
        return res.status(400).json({ error: 'Invalid table name' });
      }

      // Find the timing record by dayNumber and loc_id
      const timing = await model.findOne({ where: { dayNumber: day_number, loc_id } });

      if (!timing) {
        return res.status(404).json({ error: 'Timing record not found' });
      }

      // Normalize the time to HH:mm:ss
      let normalizedTime = new_value;
      if (field === 'fromTime' || field === 'toTime') {
        if (/^\d{2}:\d{2}$/.test(new_value)) {
          normalizedTime = `${new_value}:00`; // Convert HH:mm to HH:mm:ss
        }
      }

      // Update the relevant field based on input
      if (field === 'fromTime') {
        timing.fromTime = normalizedTime;
      } else if (field === 'toTime') {
        timing.toTime = normalizedTime;

        // Check if toTime is between 00:00:00 and 06:00:00, then update nextDay
        const toTimeHour = parseInt(normalizedTime.split(':')[0], 10); // Get hour part of toTime
        if (toTimeHour >= 0 && toTimeHour < 6) {
          timing.nextDay = 1; // Set nextDay to true
        } else {
          timing.nextDay = 0; // Otherwise, set nextDay to false
        }
      } else if (field === 'closeStatus') {
        timing.closeStatus = new_value ? 1 : 0; // Convert boolean to int (1 for true, 0 for false)
      }

      await timing.save(); // Save changes to the database

      return res.json({ status_code: 200, status: true });
    } catch (error) {
      console.error(error);
      return res.status(500).json({ error: 'Error updating timings' });
    }
  }
];





exports.updateShopTimingsbk = [
  // Validation middleware
  body('table_name')
    .isIn(['visiting_timings', 'lunch_timings', 'delivery_timings'])
    .withMessage('Invalid table name'),
  body('day_number')
    .isInt({ min: 1, max: 7 })
    .withMessage('day_number must be an integer between 1 and 7'),
  body('field')
    .isIn(['fromTime', 'toTime', 'closeStatus'])
    .withMessage('Invalid field name'),
  body('new_value')
    .custom((value, { req }) =>
    {
      if (req.body.field === 'closeStatus')
      {
        if (typeof value !== 'boolean')
        {
          throw new Error('closeStatus must be a boolean');
        }
      } else
      {
        // Allow both HH:mm and HH:mm:ss formats
        const timeRegex = /^([01]\d|2[0-3]):([0-5]\d)(:[0-5]\d)?$/;
        if (!timeRegex.test(value))
        {
          throw new Error('Invalid time format, expected HH:mm or HH:mm:ss');
        }
      }
      return true;
    }),

  // Route handler
  async (req, res) =>
  {
    // Check validation result
    const errors = validationResult(req);
    if (!errors.isEmpty())
    {
      return res.status(400).json({ errors: errors.array() });
    }

    const { loc_id } = req;
    const { table_name, day_number, field, new_value } = req.body;
    const { DeliveryTiming, VisitingTiming, LunchTiming } = req.models;

    try
    {
      let model;

      // Determine the model based on the table_name
      if (table_name === 'visiting_timings')
      {
        model = VisitingTiming;
      } else if (table_name === 'lunch_timings')
      {
        model = LunchTiming;
      } else if (table_name === 'delivery_timings')
      {
        model = DeliveryTiming;
      } else
      {
        return res.status(400).json({ error: 'Invalid table name' });
      }

      // Find the timing record by dayNumber and loc_id
      const timing = await model.findOne({ where: { dayNumber: day_number, loc_id } });

      if (!timing)
      {
        return res.status(404).json({ error: 'Timing record not found' });
      }

      // Normalize the time to HH:mm:ss
      let normalizedTime = new_value;
      if (field === 'fromTime' || field === 'toTime')
      {
        if (/^\d{2}:\d{2}$/.test(new_value))
        {
          normalizedTime = `${new_value}:00`; // Convert HH:mm to HH:mm:ss
        }
      }

      // Update the relevant field based on input
      if (field === 'fromTime')
      {
        timing.fromTime = normalizedTime;
      } else if (field === 'toTime')
      {
        timing.toTime = normalizedTime;

        // Check if toTime is between 00:00:00 and 06:00:00, then update nextDay
        const toTimeHour = parseInt(normalizedTime.split(':')[0], 10); // Get hour part of toTime
        if (toTimeHour >= 0 && toTimeHour < 6)
        {
          timing.nextDay = 1; // Set nextDay to true
        } else
        {
          timing.nextDay = 0; // Otherwise, set nextDay to false
        }
      } else if (field === 'closeStatus')
      {
        timing.closeStatus = new_value ? 1 : 0; // Convert boolean to int (1 for true, 0 for false)
      }

      await timing.save(); // Save changes to the database

      return res.json({ status_code: 200, status: true });
    } catch (error)
    {
      console.error(error);
      return res.status(500).json({ error: 'Error updating timings' });
    }
  }
];


exports.getGeneralSettings = async (req, res) =>
{

  const { shopSequelize, loc_id } = req;
  try
  {


    const generalSettings = await shopSequelize.query(`SELECT general_settings.home_delivery_feature,general_settings.online_ordering_feature, contact_us.print_no_of_copy,contact_us.print_style,contact_us.orientation FROM general_settings inner join contact_us on general_settings.loc_id = contact_us.loc_id where general_settings.loc_id =${loc_id} `, {
      type: shopSequelize.QueryTypes.SELECT
    });

    return res.json({ status_code: 200, status: true, data: { "general_settings":generalSettings[0] } });

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};







