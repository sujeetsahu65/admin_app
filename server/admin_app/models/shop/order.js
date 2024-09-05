const utils = require('../../utils');


module.exports = (superSequelize, DataTypes, enc_key) =>
{
  const Order = superSequelize.define('Order', {

    userMobileNo: {
      type: DataTypes.STRING,
      field: 'user_mobile_no',
      get ()
      {
        const encryptedMobileNo = this.getDataValue('userMobileNo');
        return encryptedMobileNo ? utils.decryptPassWithKey(encryptedMobileNo, enc_key) : encryptedMobileNo;
      }
    },
    userAddress: {
      type: DataTypes.STRING,
      field: 'address',
      allowNull: false,
      get ()
      {
        const encryptedAddress = this.getDataValue('userAddress');
        return encryptedAddress ? utils.decryptPassWithKey(encryptedAddress, enc_key) : encryptedAddress;
      }

    },
    userZipcode: {
      type: DataTypes.STRING,
      field: 'zipcode',
      allowNull: false,
      get ()
      {
        const encryptedZipcode = this.getDataValue('userZipcode');
        return encryptedZipcode ? utils.decryptPassWithKey(encryptedZipcode, enc_key) : encryptedZipcode;
      }
    },
    userCity: {
      type: DataTypes.STRING,
      field: 'city',
      allowNull: false,
      get ()
      {
        const encryptedCity = this.getDataValue('userCity');
        return encryptedCity ? utils.decryptPassWithKey(encryptedCity, enc_key) : encryptedCity;
      }
    },
    userBuildingNo: {
      type: DataTypes.STRING,
      field: 'building_no',
            // allowNull: false,
            // defaultValue: '',
      get ()
      {
        const encryptedBuildingNo = this.getDataValue('userBuildingNo');
        return encryptedBuildingNo ? utils.decryptPassWithKey(encryptedBuildingNo, enc_key) : encryptedBuildingNo;
      }
    },
    userNote: {
      type: DataTypes.STRING,
      field: 'additional_info'
    },
    userFullName: {
      type: DataTypes.STRING,
      field: 'user_fullname'
    },
    orderId: {
      type: DataTypes.INTEGER,
      primaryKey: true,
      field: 'order_id'
    },
    orderDateTime: {
      type: DataTypes.DATE,
      field: 'order_datetime'
    },
    waiterId: {
      type: DataTypes.INTEGER,
      field: 'waiter_id'
    },
    deliveryPartnerCost: {
      type: DataTypes.DOUBLE,
      field: 'delivery_partner_cost'
    },
    deliveryStatusInformation: {
      type: DataTypes.INTEGER,
      field: 'partner_statusInformation'
    },
    orderNO: {
      type: DataTypes.STRING,
      field: 'rand_order_no'
    },
    deliveryTypeId: {
      type: DataTypes.INTEGER,
      field: 'delivery_type_id'
    },
    deliveryPartnerId: {
      type: DataTypes.INTEGER,
      field: 'delivery_partner_id'
    },
    paymentModeId: {
      type: DataTypes.INTEGER,
      field: 'payment_mode_id'
    },
    paymentStatusId: {
      type: DataTypes.INTEGER,
      field: 'payment_status_id'
    },
    ordersStatusId: {
      type: DataTypes.INTEGER,
      field: 'orders_status_id'
    },
    preOrderBooking: {
      type: DataTypes.INTEGER,
      field: 'pre_order_booking'
    },
    // sendEmailOrderSetTime: {
    //   type: DataTypes.INTEGER,
    //   field: 'send_email_order_set_time'
    // },
    // sendSmsOrderSetTime: {
    //   type: DataTypes.INTEGER,
    //   field: 'send_sms_order_set_time'
    // },
    // sendEmailOrderOntheway: {
    //   type: DataTypes.INTEGER,
    //   field: 'send_email_order_ontheway'
    // },
    // sendSmsOrderOntheway: {
    //   type: DataTypes.INTEGER,
    //   field: 'send_sms_order_ontheway'
    // },
    // sendEmailOrderCancel: {
    //   type: DataTypes.INTEGER,
    //   field: 'send_email_order_cancel'
    // },
    // sendSmsOrderCancel: {
    //   type: DataTypes.INTEGER,
    //   field: 'send_sms_order_cancel'
    // },
    orderLanguageId: {
      type: DataTypes.INTEGER,
      field: 'order_language_id'
    },
    orderTimerStartTime: {
      type: DataTypes.DATE,
      field: 'order_timer_start_time'
    },
    setOrderMinutTime: {
      type: DataTypes.STRING,
      field: 'set_order_minut_time',
      allowNull: true
    },
    foodItemSubtotalAmt: {
      type: DataTypes.DOUBLE,
      field: 'food_item_subtotal_amt'
    },
    totalItemTaxAmt: {
      type: DataTypes.DOUBLE,
      field: 'total_item_tax_amt'
    },
    discountAmt: {
      type: DataTypes.DOUBLE,
      field: 'discount_amt'
    },
    regOfferAmount: {
      type: DataTypes.DOUBLE,
      field: 'reg_offer_amount'
    },
    deliveryCharges: {
      type: DataTypes.DOUBLE,
      field: 'delivery_charges'
    },
    extraDeliveryCharges: {
      type: DataTypes.DOUBLE,
      field: 'extra_delivery_charges'
    },
    minimumOrderPrice: {
      type: DataTypes.DOUBLE,
      field: 'Minimum_order_price'
    },
    grandTotal: {
      type: DataTypes.DOUBLE,
      field: 'grand_total'
    },
    finalPayableAmount: {
      type: DataTypes.DOUBLE,
      field: 'final_payable_amount'
    },
    orderFrom: {
      type: DataTypes.STRING,
      field: 'order_from'
    },
    qrcodeOrderLabel: {
      type: DataTypes.STRING,
      field: 'qrcode_order_label'
    },
    bonusValueUsed: {
      type: DataTypes.DOUBLE,
      field: 'bonus_value_used'
    },
    bonusValueGet: {
      type: DataTypes.DOUBLE,
      field: 'bonus_value_get'
    },
    userId: {
      type: DataTypes.INTEGER,
      field: 'user_id'
    },
    doneStatus: {
      type: DataTypes.INTEGER,
      field: 'done_status'
    },
    orderUserDistance: {
      type: DataTypes.DOUBLE,
      field: 'distance'
    },
    preOrderResponseAlertTime: {
      type: DataTypes.INTEGER,
      field: 'pre_order_response_alert_time'
    },
    // tableBookingResponseAlertTime: {
    //   type: DataTypes.INTEGER,
    //   field: 'table_booking_response_alert_time'
    // },
    // fcmToken: {
    //   type: DataTypes.STRING,
    //   field: 'fcm_token',
    //   allowNull: true
    // },
    deliveryCouponAmt: {
      type: DataTypes.DOUBLE,
      field: 'delivery_coupon_amt'
    },
    couponDiscount: {
      type: DataTypes.DOUBLE,
      field: 'coupon_discount'
    },
    comboOfferApplied: {
      type: DataTypes.INTEGER,
      field: 'combo_offer_applied'
    }
  }, {
    timestamps: false,
    tableName: "orders"
  });
  return Order;
};

// module.exports = Admin;