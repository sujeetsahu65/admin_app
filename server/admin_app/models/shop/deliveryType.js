
module.exports = (superSequelize, DataTypes,lang_id) => {
  const DeliveryType = superSequelize.define('DeliveryType', {
  deliveryTypeId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'delivery_type_id'
  },
  deliveryType: {
    type: DataTypes.STRING,
    field: `delivery_type_${lang_id}` 
  },
  deliveryTypeImg: {
    type: DataTypes.STRING,
    field: `delivery_type_img` 
  },
  
},

  {
    timestamps: false,
    tableName:"delivery_type_master"
  });
  return DeliveryType;
};

// module.exports = Admin;