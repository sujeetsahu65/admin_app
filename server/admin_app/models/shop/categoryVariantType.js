
module.exports = (superSequelize, DataTypes, lang_id) =>
{
  const CategoryVariantType = superSequelize.define('CategoryVariantType', {
    // locId: {
    //   type: DataTypes.INTEGER,
    //   allowNull: false,
    //   field: 'loc_id',
    // },
    catgVariantTypeId: {
      type: DataTypes.INTEGER,
      // primaryKey: true,
      field: 'catg_variant_type_id',
    },
    catgVariantTypeName: {
      type: DataTypes.STRING,
      field: `catg_variant_type_name_${lang_id}`,
    },
    // hideStatus: {
    //   type: DataTypes.INTEGER,
    //   field: `hide_status`,
    // },
  },

    {
      timestamps: false,
      tableName: "category_variant_type",
      // indexes: [
      //   {
      //     unique: true,
      //     fields: ['loc_id', 'catg_variant_type_id'],
      //   },
      // ],
    });
  return CategoryVariantType;
};




