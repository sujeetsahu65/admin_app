
module.exports = (superSequelize, DataTypes) => {
  const PaymentGatewayCommission = superSequelize.define('PaymentGatewayCommission', {
    paymentGatewayCommissionId: {
      type: DataTypes.INTEGER,
      field: 'payment_gateway_commission_id',
      primaryKey: true,
      autoIncrement: true,
    },
    paymentGatewayDetailId: {
      type: DataTypes.INTEGER,
      field: 'payment_gateway_detail_id',
      allowNull: false,
      defaultValue: 0
    },
    commissionName: {
      type: DataTypes.STRING(50),
      field: 'commission_name',
      allowNull: false
    },
    commissionId: {
      type: DataTypes.STRING(100),
      field: 'commission_id',
      allowNull: false
    },
    commissionValAmt: {
      type: DataTypes.DOUBLE(11, 2),
      field: 'commission_val_amt',
      allowNull: false
    },
    commissionValPercentage: {
      type: DataTypes.STRING(100),
      field: 'commission_val_percentage',
      allowNull: false
    }
  },

  {
    timestamps: false,
    tableName:"payment_gateway_commission"
  });
  return PaymentGatewayCommission;
};

// module.exports = Admin;