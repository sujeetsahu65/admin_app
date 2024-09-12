$update_display="update `master_food_items` set display=$status where loc_id='$_SESSION[loc_id]' and food_item_id=$pid";

// TABLE 1:
select catg_variant_type_name_1 as catg_variant_type_name,catg_variant_type_id  from category_variant_type where loc_id=42 and hide_status =1 ORDER BY `catg_variant_type_id` ASC


// TABLE 2:
select food_item_category_id,food_category_name_lang_1 as category_name,catg_variant_type_id from master_food_category  where category_display=1 and is_category_deleted =1 and loc_id=42 order by display_order asc

// TABLE 3:
SELECT `food_item_id`,food_item_name_1 as food_item_name ,`display_order`,`display`,`is_active` FROM `master_food_items` WHERE is_active=1 and loc_id=42 order by display_order ASC




master_food_category.category_display=1 and master_food_category.is_category_deleted =1 and master_food_category.loc_id=42



master_food_items.is_active=1 and master_food_items.loc_id=42





select category_variant_type.catg_variant_type_name_1 as catg_variant_type_name,category_variant_type.catg_variant_type_id,master_food_category.food_item_category_id,master_food_category.food_category_name_lang_1 as category_name,master_food_category.catg_variant_type_id,master_food_items.food_item_id,master_food_items.food_item_name_1 as food_item_name ,master_food_items.display_order,master_food_items.display,master_food_items.is_active from category_variant_type inner join master_food_category on category_variant_type.catg_variant_type_id= master_food_category.catg_variant_type_id inner join master_food_items on master_food_category.food_item_category_id=  master_food_items.food_item_category_id where category_variant_type.loc_id=42 and category_variant_type.hide_status=1 and master_food_category.category_display=1 and master_food_category.is_category_deleted =1 and master_food_category.loc_id=42 and master_food_items.is_active=1 and master_food_items.loc_id=42;


the latest query that can be found while applying



{
    "status_code": 200,
    "status": true,
    "data": {
        "delivery_timings": [
            {
                "tableName": "delivery_timings",
                "id": 316,
                "dayName": 1,
                "fromTime": "11:00:00",
                "toTime": "21:30:00",
                "nextDay": 0,
                "closeStatus": 0
            },
            {
                "tableName": "delivery_timings",
                "id": 317,
                "dayName": 2,
                "fromTime": "11:00:00",
                "toTime": "21:30:00",
                "nextDay": 0,
                "closeStatus": 0
            },
            {
                "tableName": "delivery_timings",
                "id": 318,
                "dayName": 3,
                "fromTime": "11:00:00",
                "toTime": "21:30:00",
                "nextDay": 0,
                "closeStatus": 0
            },
            {
                "tableName": "delivery_timings",
                "id": 319,
                "dayName": 4,
                "fromTime": "11:00:00",
                "toTime": "21:30:00",
                "nextDay": 0,
                "closeStatus": 0
            },
            {
                "tableName": "delivery_timings",
                "id": 320,
                "dayName": 5,
                "fromTime": "11:00:00",
                "toTime": "22:30:00",
                "nextDay": 0,
                "closeStatus": 0
            },
            {
                "tableName": "delivery_timings",
                "id": 321,
                "dayName": 6,
                "fromTime": "11:30:00",
                "toTime": "22:30:00",
                "nextDay": 0,
                "closeStatus": 0
            },
            {
                "tableName": "delivery_timings",
                "id": 322,
                "dayName": 7,
                "fromTime": "12:30:00",
                "toTime": "21:30:00",
                "nextDay": 0,
                "closeStatus": 0
            }
        ]
    }
}