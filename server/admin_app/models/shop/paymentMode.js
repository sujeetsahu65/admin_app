
module.exports = (superSequelize, DataTypes,lang_id) => {
  const PaymentMode = superSequelize.define('PaymentMode', {
  paymentModeId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'payment_mode_id'
  },
  paymentMode: {
    type: DataTypes.STRING,
    field: `payment_mode_lang_${lang_id}` 
  },
  paymentModeIcon: {
    type: DataTypes.STRING,
    field: 'icon' 
  },
  
},

  {
    timestamps: false,
    tableName:"payment_mode_master"
  });
  return PaymentMode;
};

// module.exports = Admin;