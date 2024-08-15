require('dotenv').config();
const utils = require('./admin_app/utils');
// const session = require('express-session');
const express = require('express');
// const path = require('path');
const bodyParser = require('body-parser');
const adminAppRoute = require('./admin_app/index');

const app = express();
const PORT = process.env.PORT || 8000;
app.use(bodyParser.json());


app.use('/admin-app', adminAppRoute);
app.get("/test", (req, res) =>
{
// order.grandemargherita@foodzone.fi

//  let key = utils.encryptPasswithkey();
//  let key = utils.generateEncKey();

// Example usage
const plainText = 'your_plain_text_here';
const salt = '20adeb83e85f03cfc84d0fb7e5f4d290';
// const encryptedText = utils.encryptString(plainText, key, salt);
// console.log('Encrypted Text:', encryptedText);

// Example usage
// const decryptedText = utils.decryptString(encryptedText, key, salt);
// console.log('Decrypted Text:', decryptedText);
  
  // res.status(200).json({ status: false, message: "error" });
  // let tti = utils.encryptPasswithkey("sujeet");
  // let tti = utils.decryptWithKey("1OzWnXe6i+I015+IYXXTjg==","1cfc2f590d717319ac15a07d92ee2046");
  // let tti = utils.decryptWithKey("JBE6zte3smcpRt4XRGvDQA==","fc9653ebf224379c42031073acbc2a03");
  // let tti = utils.decryptWithKey("JBE6zte3smcpRt4XRGvDQA==","fc9653ebf224379c42031073acbc2a03");
  // console.log(tti);
  
  // res.send(utils.decryptPass("KJv0DVsIy1hEis2hIsaNHA=="));
});

  app.listen(PORT, () =>
    {
      console.log(`Server running on port ${PORT}`);
    });

