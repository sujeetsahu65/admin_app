const jwt = require('jsonwebtoken');
const { AdminLogin } = require('../models/super_admin');
const validator = require('validator');

module.exports = async (req, res, next) =>
{
  const token = req.header('x-auth-token');
  const lang_code = req.header('lang-code');


  if (!token) return res.status(401).json({ status_code: 401, status: false, message: 'No token, authorization denied' });





  if (lang_code)
  {
    const sanitized_lang_code = validator.escape(lang_code);
    console.log("sanitizedInput:" + sanitized_lang_code);

    if (sanitized_lang_code === 'en')
    {
      lang_id = 1;
    }

    else if (sanitized_lang_code === 'es')
    {
      lang_id = 3;

    }
    else 
    {
      lang_id = 2;

    }

    req.lang_id = lang_id;
  } else
  {
    req.lang_id = 2;
  }



  try
  {
    const decoded = jwt.verify(token, process.env.JWT_SECRET);

    const { login_id, loc_id } = decoded;
    console.log(decoded);

    // const admin = await Admin.findByPk(client_id);
    // const admin = await Admin.findOne({ where: { login_id },
    const admin = await AdminLogin.findOne({
      where: { client_login_id: login_id, loc_id },

    });
    console.log("login_id" + login_id);
    if (!admin) return res.status(404).json({ status_code: 404, status: false, message: 'Admin not found' });

    req.admin = decoded;
    console.log("this is authmid:" + JSON.stringify(req.admin));

    next();
  } catch (error)
  {
    console.log(error);
    res.status(400).json({ status_code: 400, status: false, message: 'Token is not valid' });
  }
};
