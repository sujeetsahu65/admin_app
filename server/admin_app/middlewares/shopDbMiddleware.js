const { superSequelize, Sequelize, DataTypes, Op, order, user, deliveryType, paymentMode, categoryVariantType, masterFoodCategory, masterFoodItems } = require('../models/shop');
// const utils = require('../utils');


module.exports = async (req, res, next) =>
{
    const { client_id, role, loc_id } = req.admin;
    const { lang_id } = req;
    try
    {

        const shopDb = await superSequelize.query(`SELECT * FROM client_restaurant_detail where client_id =${client_id} `, {
            type: superSequelize.QueryTypes.SELECT
        });

        // const shopSequelize = new Sequelize(shopDb[0].database_name, shopDb[0].db_username, utils.decryptPass(shopDb[0].db_password), {
        const shopSequelize = new Sequelize(shopDb[0].database_name, shopDb[0].db_username, shopDb[0].db_password, {
            host: "localhost",
            dialect: 'mysql',
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
            //  timezone:'+05:30',
            //  timezone:'Asia/Kolkata',

            pool: {
                max: 10,
                min: 0,
                acquire: 30000,
                idle: 10000,
                timezone: 'Z'
            }
            // const shopSequelize = new Sequelize("foodzone", shopDb[0].db_username, shopDb[0].db_password, {
            //     host: "localhost",
            //     dialect: 'mysql'
        });

        shopSequelize.authenticate()
            .then(() =>
            {

                const enc_key = shopDb[0].enc_key;
                const Order = order(shopSequelize, DataTypes, enc_key);
                const User = user(shopSequelize, DataTypes, enc_key);
                const DeliveryType = deliveryType(shopSequelize, DataTypes, lang_id);
                const PaymentMode = paymentMode(shopSequelize, DataTypes, lang_id);
                const CategoryVariantType = categoryVariantType(shopSequelize, DataTypes, lang_id);
                const MasterFoodCategory = masterFoodCategory(shopSequelize, DataTypes, lang_id);
                const MasterFoodItems = masterFoodItems(shopSequelize, DataTypes, lang_id);
                Order.belongsTo(User, { foreignKey: 'userId' });
                Order.belongsTo(DeliveryType, { foreignKey: 'deliveryTypeId' });
                Order.belongsTo(PaymentMode, { foreignKey: 'paymentModeId' });

                // CategoryVariantType.hasMany(MasterFoodCategory, { foreignKey: 'catgVariantTypeId' });
                CategoryVariantType.hasMany(MasterFoodCategory, {
                    foreignKey: 'catgVariantTypeId',
                    sourceKey: 'catgVariantTypeId',//you have to define expicitly in case where your table does not have foreign or primary key defined.
                });
                MasterFoodCategory.hasMany(MasterFoodItems, { foreignKey: 'foodItemCategoryId' });//here we didn't use source key as the both tables has a defined foreign key
                // MasterFoodCategory.belongsTo(CategoryVariantType, { foreignKey: 'catgVariantTypeId', targetKey: 'catgVariantTypeId' });

                // MasterFoodItems.belongsTo(MasterFoodCategory, { foreignKey: 'foodItemCategoryId', targetKey: 'foodItemCategoryId' });

                // MasterFoodCategory.belongsTo(CategoryVariantType, { 
                //   foreignKey: 'catgVariantTypeId',
                //   targetKey: 'catgVariantTypeId',
                //   scope: { locId: shopSequelize.col('CategoryVariantType.loc_id') },
                // });

                // MasterFoodItems.belongsTo(MasterFoodCategory, { 
                //   foreignKey: 'foodItemCategoryId',
                //   targetKey: 'foodItemCategoryId',
                //   scope: { locId: shopSequelize.col('MasterFoodCategory.loc_id') },
                // });

                console.log('Connection has been established successfully.');
                req.shopSequelize = shopSequelize;
                req.loc_id = loc_id;
                req.Op = Op;
                req.enc_key = enc_key;
                req.data_entry_type = shopDb[0].dataentryType;
                req.superSequelize = superSequelize;
                req.models = {
                    User,
                    Order,
                    DeliveryType,
                    PaymentMode,
                    CategoryVariantType,
                    MasterFoodCategory,
                    MasterFoodItems,
                }
                next();
            })
            .catch(err =>
            {
                console.error('Unable to connect to the database:', err);
                return res.status(500).json({ status_code: 500, status: false, message: err });
            });

    } catch (error)
    {
        console.log(error);
        res.status(500).json({ status_code: 500, status: false, message: error.message });
    }

};
