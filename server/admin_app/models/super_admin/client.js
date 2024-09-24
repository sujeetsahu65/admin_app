
module.exports = (superSequelize, DataTypes) =>
{
    const Client = superSequelize.define('Client', {
        clientId: {
            type: DataTypes.INTEGER,
            field: 'client_id',
            autoIncrement: true,
            primaryKey: true
        },
        clientName: {
            type: DataTypes.STRING,
            field: 'client_name'
        },
        databaseName: {
            type: DataTypes.STRING,
            field: 'database_name'
        },
        dbUsername: {
            type: DataTypes.STRING,
            field: 'db_username'
        },
        dbPassword: {
            type: DataTypes.STRING,
            field: 'db_password'
        },

    },

        {
            timestamps: false,
            tableName: "client_restaurant_detail"
        });
    return Client;
};

// module.exports = Admin;