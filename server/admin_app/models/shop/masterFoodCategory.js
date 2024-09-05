
module.exports = (superSequelize, DataTypes, lang_id) =>
{
  const MasterFoodCategory = superSequelize.define('MasterFoodCategory', {
    // locId: {
    //   type: DataTypes.INTEGER,
    //   allowNull: false,
    //   field: 'loc_id',
    // },
    foodItemCategoryId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      field: 'food_item_category_id',
    },
    categoryName: {
      type: DataTypes.STRING,
      field: `food_category_name_lang_${lang_id}`,
    },
    catgVariantTypeId: {
      type: DataTypes.INTEGER,
      // references: {
      //   model: CategoryVariantType,
      //   key: 'catg_variant_type_id',
      // },
      field: 'catg_variant_type_id',
    },
  },

    {
      timestamps: false,
      tableName: "master_food_category",
      // indexes: [
      //   {
      //     unique: true,
      //     fields: ['loc_id', 'catg_variant_type_id'],
      //   },
      // ],
    });
  return MasterFoodCategory;
};




