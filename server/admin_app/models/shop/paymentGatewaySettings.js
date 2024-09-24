
module.exports = (superSequelize, DataTypes) => {
  const PaymentGatewaySetting = superSequelize.define('PaymentGatewaySetting',{
    locId: {
      type: DataTypes.INTEGER,
      field: 'loc_id',
      allowNull: false,
      defaultValue: 0
    },
    gatewayId: {
      type: DataTypes.INTEGER,
      field: 'gateway_id',
      allowNull: true
    },
    paymentGatewayDetailId: {
      type: DataTypes.INTEGER,
      field: 'payment_gateway_detail_id',
      allowNull: true
    },
    paymentGatewayCommissionId: {
      type: DataTypes.INTEGER,
      field: 'payment_gateway_commission_id',
      allowNull: true
    },
    paymentGatewayUserid: {
      type: DataTypes.STRING,
      field: 'payment_gateway_userid',
      allowNull: true
    },

    vismaSelectedPaymentMethod: {
      type: DataTypes.STRING,
      field: 'visma_selected_paymentmethod',
      allowNull: true
    },
    paymentGatewayStatus: {
      type: DataTypes.TINYINT,
      field: 'payment_gateway_status',
      allowNull: true,
      defaultValue: 0
    },
    mobilePayStatus: {
      type: DataTypes.TINYINT,
      field: 'mobile_pay_status',
      allowNull: true
    },
    channelPartnerStatus: {
      type: DataTypes.INTEGER,
      field: 'channel_partner_status',
      allowNull: true,
      defaultValue: 1
    },
    channelPartnerSettingsId: {
      type: DataTypes.INTEGER,
      field: 'channel_partner_settings_id',
      allowNull: true
    }
  },

  {
    timestamps: false,
    tableName:"payment_gateway_setting"
  });
  return PaymentGatewaySetting;
};

// module.exports = Admin;