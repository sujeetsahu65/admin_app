
module.exports = (superSequelize, DataTypes) => {
  const Admin = superSequelize.define('Admin', {
    client_login_id: {
      type: DataTypes.INTEGER,
      autoIncrement: true,
      primaryKey: true
    },
    client_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
     loc_id: {
      type: DataTypes.INTEGER,
      allowNull: false,
    },
  },

  {
    timestamps: false,
    tableName:"client_restaurant_login"
  });
  return Admin;
};

// module.exports = Admin;