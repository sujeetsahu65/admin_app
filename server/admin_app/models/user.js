const utils = require('../utils');


module.exports = (superSequelize, DataTypes,enc_key) => {
  const User = superSequelize.define('User', {
  userId: {
    type: DataTypes.INTEGER,
    primaryKey: true,
    autoIncrement: true,
    field: 'user_id'
  },
  usersTypeId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'users_type_id'
  },
  qrCodeId: {
    type: DataTypes.INTEGER,
    allowNull: false,
    field: 'qr_code_id'
  },
  // customerRandCode: {
  //   type: DataTypes.STRING,
  //   allowNull: false,
  //   field: 'customer_rand_code'
  // },
  firstName: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'first_name'
  },
  lastName: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'last_name'
  },
  userEmail: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'user_email',
      get() {
        const encryptedEmail = this.getDataValue('userEmail');
        return encryptedEmail ? utils.decryptPassWithKey(encryptedEmail,enc_key) : encryptedEmail;
      }
  },
  userPhone: {
    type: DataTypes.STRING,
    allowNull: false,
    field: 'user_phone',
      get() {
        const encryptedPhone = this.getDataValue('userPhone');
        return encryptedPhone ? utils.decryptPassWithKey(encryptedPhone,enc_key) : encryptedPhone;
      }
  },
  // userPassword: {
  //   type: DataTypes.STRING,
  //   allowNull: false,
  //   field: 'user_password',
  //     get() {
  //       const encryptedPassword = this.getDataValue('userPassword');
  //       return encryptedPassword ? utils.decryptPassWithKey(encryptedPassword,enc_key) : encryptedPassword;
  //     }
  // },
  // userStatus: {
  //   type: DataTypes.TINYINT,
  //   allowNull: false,
  //   field: 'user_status'
  // },
  userAddress: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'user_address',
      get() {
        const encryptedAddress = this.getDataValue('userAddress');
        return encryptedAddress ? utils.decryptPassWithKey(encryptedAddress,enc_key) : encryptedAddress;
      }
  },
  userBuildingNo: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'user_building_no',
      get() {
        const encryptedBuildingNo = this.getDataValue('userBuildingNo');
        return encryptedBuildingNo ? utils.decryptPassWithKey(encryptedBuildingNo,enc_key) : encryptedBuildingNo;
      }
  },
  userCity: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'user_city',
      get() {
        const encryptedCity = this.getDataValue('userCity');
        return encryptedCity ? utils.decryptPassWithKey(encryptedCity,enc_key) : encryptedCity;
      }
  },
  userZipcode: {
    type: DataTypes.STRING,
    allowNull: true,
    field: 'user_zipcode',
      get() {
        const encryptedZipcode = this.getDataValue('userZipcode');
        return encryptedZipcode ? utils.decryptPassWithKey(encryptedZipcode,enc_key) : encryptedZipcode;
      }
  },
  // registrationDate: {
  //   type: DataTypes.DATE,
  //   allowNull: false,
  //   field: 'registration_date'
  // },
  // regiVerificationCode: {
  //   type: DataTypes.STRING,
  //   allowNull: true,
  //   field: 'regi_verification_code'
  // },
  // isMobileVerified: {
  //   type: DataTypes.TINYINT,
  //   allowNull: false,
  //   field: 'is_mobile_verified'
  // },
  // accountDeleteDateTime: {
  //   type: DataTypes.DATE,
  //   allowNull: true,
  //   field: 'accountdelete_datetime'
  // },
  // userRegiFrom: {
  //   type: DataTypes.STRING,
  //   allowNull: true,
  //   field: 'user_regi_from'
  // },
  // sendRegistrationEmail: {
  //   type: DataTypes.INTEGER,
  //   allowNull: false,
  //   field: 'send_registration_email'
  // },
  // sendRegistrationSms: {
  //   type: DataTypes.INTEGER,
  //   allowNull: false,
  //   field: 'send_registration_sms'
  // },
  // sendForgetPassEmail: {
  //   type: DataTypes.INTEGER,
  //   allowNull: false,
  //   field: 'send_forget_pass_email'
  // },
  // sendForgetPassSms: {
  //   type: DataTypes.INTEGER,
  //   allowNull: false,
  //   field: 'send_forget_pass_sms'
  // },
  // sendAccountDelEmail: {
  //   type: DataTypes.INTEGER,
  //   allowNull: false,
  //   field: 'send_account_del_email'
  // },
  // sendAccountDelSms: {
  //   type: DataTypes.INTEGER,
  //   allowNull: false,
  //   field: 'send_account_del_sms'
  // },
  // createdOn: {
  //   type: DataTypes.DATE,
  //   allowNull: false,
  //   defaultValue: DataTypes.NOW,
  //   field: 'created_on'
  // }
},

  {
    timestamps: false,
    tableName:"users"
  });
  return User;
};

// module.exports = Admin;