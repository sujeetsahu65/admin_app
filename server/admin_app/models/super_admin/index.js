const { Sequelize, DataTypes,Op,fn,col,literal } = require('sequelize');
const adminModel = require('./admin');
const adminLoginModel = require('./adminLogin');
const client = require('./client');
const paymentGatewayDetails = require('./paymentGatewayDetails');
const paymentGatewayCommission = require('./paymentGatewayCommission');
const config = require('../../config/config').development;
// const abcModel = require('./abc');

// const superSequelize = new Sequelize(
//   process.env.DB_NAME,
//   process.env.DB_USERNAME,
//   process.env.DB_PASSWORD,
//   {
//     host: process.env.DB_HOST,
//     dialect: 'mysql'
//   }
// );

const superSequelize = new Sequelize(config.database, config.username, config.password, {
  host: config.host,
  dialect: config.dialect,
  logging: false,
  dialectOptions: {
    // useUTC:false
    //    dateStrings: true,
    typeCast: function (field, next)
    { // for reading from database
      if (field.type === 'DATETIME')
      {
        return field.string()
      }
      return next()
    },
    decimalNumbers: true,
  },
    timezone: '+05:30',
  pool: {
    max: 50,
    min: 0,
    acquire: 30000,
    idle: 5000
  }
});



superSequelize.authenticate()
  .then(() =>
  {
    console.log('Connection has been established successfully.');

  })
  .catch(err =>
  {
    console.error('Unable to connect to the database:', err);
  });

const Admin = adminModel(superSequelize, DataTypes);
const AdminLogin = adminLoginModel(superSequelize, DataTypes);
const Client = client(superSequelize, DataTypes);
const PaymentGatewayDetails = paymentGatewayDetails(superSequelize, DataTypes);
const PaymentGatewayCommission = paymentGatewayCommission(superSequelize, DataTypes);

// const Abc = abcModel(sequelize, Sequelize);
// const Admin = require('./admin')(superSequelize, DataTypes);

Admin.hasMany(AdminLogin, { foreignKey: 'loc_id', sourceKey: 'loc_id' });
AdminLogin.belongsTo(Admin, { foreignKey: 'loc_id', targetKey: 'loc_id' });
Client.hasMany(AdminLogin, { foreignKey: 'client_id', sourceKey: 'clientId' });
AdminLogin.belongsTo(Client, { foreignKey: 'client_id', targetKey: 'clientId' });

PaymentGatewayDetails.hasMany(PaymentGatewayCommission,{ foreignKey: 'paymentGatewayDetailId', sourceKey: 'paymentGatewayDetailId' })
// Order.belongsTo(DeliveryTypeMaster, { foreignKey: 'delivery_type_id' });
// Order.belongsTo(PaymentModeMaster, { foreignKey: 'payment_mode_id' });
// superSequelize.sync().then(() =>
// {
//   console.log('Database & tables synced!');
// });

module.exports = {
  DataTypes,
  Op,
  fn,
  col,
  literal,
  Admin,
  AdminLogin,
  Client,
  superSequelize,
  Sequelize,
  PaymentGatewayDetails,
  PaymentGatewayCommission
  //   Abc
};
