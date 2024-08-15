const {superSequelize, Sequelize } = require('../models');
const utils = require('../utils');

module.exports = async (req, res, next) =>
{
    const { client_id, role, loc_id } = req.admin;
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
                console.log('Connection has been established successfully.');
                req.shopSequelize = shopSequelize;
                req.loc_id = loc_id;
                req.enc_key = shopDb[0].enc_key;
                req.data_entry_type = shopDb[0].dataentryType;
                req.superSequelize = superSequelize;
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
