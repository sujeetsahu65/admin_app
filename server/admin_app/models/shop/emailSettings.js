const utils = require('../../utils');


module.exports = (superSequelize, DataTypes, enc_key) =>
{

// console.log("ttttt: "+utils.decryptPassWithKey('il99Vb/nP8yjphQ2hpAhox37MKcqkW24zjcoHFXXH6U=',enc_key));

    // console.log('enc_key');
    // console.log(enc_key);
    const EmailSettings = superSequelize.define('EmailSettings', {

        locId: {
            type: DataTypes.INTEGER,
            field: 'loc_id',
            allowNull: false,
            defaultValue: 0
        },
        port: {
            type: DataTypes.INTEGER,
            allowNull: true
        },
        mailServer: {
            type: DataTypes.STRING(255),
            field: 'mail_server',
            allowNull: false,
            get ()
            {
                const encryptedMailServer = this.getDataValue('mailServer');
                return encryptedMailServer ? utils.decryptPassWithKey(encryptedMailServer, enc_key) : encryptedMailServer;
            }
        },
        systemMailId: {
            type: DataTypes.STRING(255),
            field: 'system_mail_id',
            allowNull: false
            ,
            get ()
            {
                const encryptedSystemMailId = this.getDataValue('systemMailId');
                return encryptedSystemMailId ? utils.decryptPassWithKey(encryptedSystemMailId, enc_key) : encryptedSystemMailId;
            }
        },
        password: {
            type: DataTypes.STRING(255),
            allowNull: false,
            get ()
            {
                const encryptedPassword = this.getDataValue('password');
                return encryptedPassword ? utils.decryptPassWithKey(encryptedPassword, enc_key) : encryptedPassword;
            }
        },
        email: {
            type: DataTypes.STRING(255),
            allowNull: false
        },
        email2: {
            type: DataTypes.STRING(255),
            allowNull: true
        },
        email3: {
            type: DataTypes.STRING(200),
            allowNull: true
        },
        reportEmail: {
            type: DataTypes.STRING(100),
            field: 'report_email',
            allowNull: true
        },
        ccEmail: {
            type: DataTypes.STRING(255),
            field: 'cc_email',
            allowNull: true
        },
        contactFormMail: {
            type: DataTypes.STRING(100),
            field: 'contact_form_mail',
            allowNull: true
        },
        emailHost: {
            type: DataTypes.STRING(100),
            field: 'email_host',
            allowNull: true,
            get ()
            {
                const encryptedEmailHost = this.getDataValue('emailHost');
                return encryptedEmailHost ? utils.decryptPassWithKey(encryptedEmailHost, enc_key) : encryptedEmailHost;
            }
        }

    }, {
        timestamps: false,
        tableName: "email_settings"
    });
    return EmailSettings;
};