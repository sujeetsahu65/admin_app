// const { Sequelize, DataTypes,Op } = require('sequelize');
const { superSequelize, Sequelize, DataTypes,Op } = require('../super_admin');
const order = require('./order');
const user = require('./user');
const deliveryType = require('./deliveryType');
const paymentMode = require('./paymentMode');
const categoryVariantType = require('./categoryVariantType');
const masterFoodCategory = require('./masterFoodCategory');
const masterFoodItems = require('./masterFoodItems');
// const config = require('../../config/config').development;


module.exports = {
  DataTypes,
  Op,
  superSequelize,
  Sequelize,
  order,
  user,
  deliveryType,
  paymentMode,
  categoryVariantType,
  masterFoodCategory,
  masterFoodItems,
  //   Abc
};
