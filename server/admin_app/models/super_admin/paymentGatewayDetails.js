
module.exports = (superSequelize, DataTypes) => {
  const PaymentGatewayDetails = superSequelize.define('PaymentGatewayDetails', {
    paymentGatewayDetailId: {
      type: DataTypes.INTEGER,
      field: 'payment_gateway_detail_id',
      primaryKey: true,
      autoIncrement: true,
    },
    gatewayName: {
      type: DataTypes.STRING,
      field: 'gateway_name',
      allowNull: false
    },
    gatewayHolderName: {
      type: DataTypes.STRING,
      field: 'gateway_holder_name',
      allowNull: false
    },
    gatewayUserId: {
      type: DataTypes.STRING,
      field: 'gateway_user_id',
      allowNull: false
    },
    gatewayPassword: {
      type: DataTypes.STRING,
      field: 'gateway_password',
      allowNull: false
    },
    gatewayChannelClassId: {
      type: DataTypes.STRING,
      field: 'gateway_channel_class_id',
      allowNull: false
    },
    gatewayUrl: {
      type: DataTypes.STRING,
      field: 'gateway_url',
      allowNull: false
    },
    gatewayPhoneno: {
      type: DataTypes.INTEGER,
      field: 'gateway_phoneno',
      allowNull: false
    }
  },

  {
    timestamps: false,
    tableName:"payment_gateway_details"
  });
  return PaymentGatewayDetails;
};

// module.exports = Admin;