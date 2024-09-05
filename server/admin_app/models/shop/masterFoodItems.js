
module.exports = (superSequelize, DataTypes, lang_id) =>
{
  const MasterFoodItems = superSequelize.define('MasterFoodItems', {
    // locId: {
    //   type: DataTypes.INTEGER,
    //   allowNull: false,
    //   field: 'loc_id',
    // },
    foodItemCategoryId: {
      type: DataTypes.INTEGER,
      allowNull: false,
      field: 'food_item_category_id',
    },
    foodItemId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      field: 'food_item_id',
    },
    foodItemName: {
      type: DataTypes.STRING,
      field: `food_item_name_${lang_id}`,
    },
    displayOrder: {
      type: DataTypes.INTEGER,
      field: 'display_order',
    },
    display: {
      type: DataTypes.INTEGER,
      field: 'display',
    },
    isActive: {
      type: DataTypes.INTEGER,
      field: 'is_active',
    },
  },

    {
      timestamps: false,
      tableName: "master_food_items",
      // indexes: [
      //   {
      //     unique: true,
      //     fields: ['loc_id', 'food_item_id'],
      //   },
      // ],
    });
  return MasterFoodItems;
};




