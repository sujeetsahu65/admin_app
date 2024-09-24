
module.exports = (superSequelize, DataTypes) => {
  const AdminLogin = superSequelize.define('AdminLogin', {
    client_login_id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    client_id: {
      type: DataTypes.INTEGER,
    },
    username: {
      type: DataTypes.STRING,
      allowNull: true,
      unique: true
    },
    password: {
      type: DataTypes.STRING,
      allowNull: true
    },
    loc_id: {
      type: DataTypes.INTEGER,
      allowNull: true
    },
    role: {
      type: DataTypes.ENUM('admin', 'super_admin'),
      defaultValue: 'admin'
    },
        otp: {
      type: DataTypes.STRING, // store hashed OTP
    },
    otp_expires_at: {
      type: DataTypes.DATE, // OTP expiration time
    },
  },

  {
    timestamps: false,
    tableName:"client_role_based_login",
      getterMethods: {
    login_id() {
      return this.client_login_id;
    }}
  });
  return AdminLogin;
};

// module.exports = Admin;