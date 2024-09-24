const jwt = require('jsonwebtoken');
const bcrypt = require('bcryptjs');
const { Admin, AdminLogin, Client } = require('../models/super_admin');
const shopDbMiddleware = require('../middlewares/shopDbMiddleware');
const utils = require('../utils');
const nodemailer = require('nodemailer');
const { body, validationResult } = require('express-validator');
const crypto = require('crypto');
const { format, add } = require('date-fns');

// exports.login = async (req, res) =>
// {
// res.json({ status: true, ...Admin });
// };


exports.login = async (req, res) =>
{

  const { username, password } = req.body;
  try
  {
    if (!username && !password) return res.status(400).json({ status_code: 400, status: false, message: 'Missing username or password' });
    console.log(username);
    const admin = await AdminLogin.findOne({
      where: { username },
      // include: [{
      //   model: Admin,
      //   // attributes: [ //to select specific columns
      //   //   'client_id',
      //   //   ['name', 'login_name'], // Alias for conflicting name attribute
      //   // ],
      //   // You can add where conditions here if needed
      // }]
    });
    console.log(admin);
    if (!admin) return res.status(404).json({ status_code: 404, status: false, message: 'Admin not found' });

    // const isMatch = await bcrypt.compare(login_password, admin.login_password);
    const isMatch = `${password}` == `${admin.password}`;
    if (!isMatch) return res.status(400).json({ status_code: 400, status: false, message: 'Invalid credentials' });
    // console.log(admin);
    console.log({ login_id: admin.login_id, client_id: admin.client_id, role: admin.role, loc_id: admin.loc_id });
    const token = jwt.sign({ login_id: admin.login_id, client_id: admin.client_id, role: admin.role, loc_id: admin.loc_id }, process.env.JWT_SECRET);
    // const token = jwt.sign({ client_id: admin.Admin.client_id, role: admin.role }, process.env.JWT_SECRET, { expiresIn: '3h' });

    res.json({ status_code: 200, status: true, token, role: admin.role });
  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};




// ======== VERIFY TOKEN=========
exports.verifyToken = async (req, res) =>
{

  const { loc_id, role } = req.admin;

  try
  {
    if (loc_id)
    {
      return res.status(200).json({ status_code: 200, status: true, role });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};


exports.forgotPassword = async (req, res, next) =>
{
  const { username, role } = req.body;

  if (!username || !role)
  {
    return res.status(400).json({ status_code: 400, status: false, message: 'Missing username or role.' });
  }

  try
  {
    // Find the admin
    const admin = await AdminLogin.findOne({
      where: { username, role },
      include: [{ model: Client }]
    });

    if (!admin)
    {
      return res.status(404).json({ status_code: 404, status: false, message: 'Admin not found' });
    }

    req.admin = {
      client_id: admin.Client.clientId,
      loc_id: admin.loc_id,
    };


    next();

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
  }
};

exports.sendPasswordResetOtp = async (req, res) =>
{

  const { username, role } = req.body;
  const { shopSequelize, loc_id } = req;
  const { EmailSettings } = req.models;
  const mail_type = 'password_reset_otp';


  try
  {
    const email_settings = await EmailSettings.findOne({
      where: { locId: loc_id },

    });


    const admin = await AdminLogin.findOne({
      where: { username, role },
    });


    const to_mail = email_settings.contactFormMail;
    // Generate OTP and expiration time
    const otp = crypto.randomInt(100000, 999999).toString();

    // Add 5 minutes to the current date
    const otpExpiresAt = add(new Date(), { minutes: 50 });
    const formattedDate = format(otpExpiresAt, 'yyyy-MM-dd HH:mm:ss');

    // Hash the OTP before storing
    const hashedOtp = await bcrypt.hash(otp, 10);
    await admin.update({ otp: hashedOtp, otp_expires_at: formattedDate });

    let mail_body = `Your OTP code is: ${otp}`;
    let mail_res = await utils.mailTo(shopSequelize, loc_id, mail_body, mail_type, email_settings);
    if (mail_res.status)
    {

      return res.json({ status_code: 200, status: true, mail_response: mail_res.mail_response, message: `OTP sent to email: ${to_mail.replace(/^(.)(.*)(.@.*)$/, "$1***$3")}` });

    }
    else
    {

      return res.json({ status_code: mail_res.status_code, status: true, message: mail_res.mail_response });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: 'Server error1' });
  }
};



// ======== VERIFY OTP FOR PASSWORD RESET=========
exports.verifyResetPasswordOtp = [
  body('username').notEmpty().withMessage('Username is required'),
  body('otp').isLength({ min: 6, max: 6 }).withMessage('OTP must be 6 digits'),

  async (req, res) =>
  {
    const errors = validationResult(req);
    if (!errors.isEmpty())
    {
      return res.status(400).json({ status_code: 400, status: false, message: 'Bad request', errors: errors.array() });
    }

    const { username, otp } = req.body;


    try
    {

      // Find admin by username
      const admin = await AdminLogin.findOne({ where: { username } });
      if (!admin)
      {

        return res.status(404).json({ status_code: 404, status: false, message: 'Admin not found' });
      }
      const currentTime = new Date();
      const otpExpiresAt = new Date(admin.otp_expires_at); // Convert the stored expiration string to a Date object

      // Compare if the current time is after the OTP expiration time
      if (currentTime > otpExpiresAt)
      {
        return res.status(400).json({ status_code: 400, status: false, message: 'OTP has expired' });
      }

      const otpString = otp.toString();
      const isOtpValid = await bcrypt.compare(otpString, admin.otp);
      if (!isOtpValid)
      {
        return res.status(400).json({ status_code: 400, status: false, message: 'Invalid OTP' });
      }

      // Generate a temporary JWT token (valid for 5 minutes)
      const token = jwt.sign(
        { username: admin.username, purpose: 'reset_password' },
        process.env.JWT_SECRET,
        { expiresIn: '5m' }
      );

      return res.status(200).json({ status_code: 200, status: true, token });


    }
    catch (error)
    {
      console.log(error);
      return res.status(500).json({ status_code: 500, status: false, message: 'Server error' });
    }

  }];



// ======== PROCEED PASSWORD RESET=========
exports.verifyPasswordReset = [
  body('token').notEmpty().withMessage('Token is required'),
  body('new_password').isLength({ min: 8 }).withMessage('Password must be at least 8 characters long'),
  body('confirm_password').custom((value, { req }) =>
  {
    if (value !== req.body.new_password)
    {
      throw new Error('Passwords do not match');
    }
    return true;
  }),

  async (req, res) =>
  {
    const errors = validationResult(req);
    if (!errors.isEmpty())
    {
      return res.status(400).json({ status_code: 400, status: false, message: 'Bad request', errors: errors.array() });
    }

    const { token, new_password } = req.body;

    // Verify JWT token
    let payload;
    try
    {
      payload = jwt.verify(token, process.env.JWT_SECRET);
    } catch (err)
    {
      return res.status(400).json({ status_code: 400, status: false, message: 'Invalid or expired token' });
    }

    const { username, purpose } = payload;

    // Ensure the token is for resetting password
    if (purpose !== 'reset_password')
    {
      return res.status(400).json({ status_code: 400, status: false, message: 'Invalid token purpose' });
    }

    // Find admin by username
    const admin = await AdminLogin.findOne({ where: { username } });
    if (!admin)
    {
      return res.status(404).json({ status_code: 404, status: false, message: 'Admin not found' });
    }

    // Hash and update the new password
    // const hashedPassword = await bcrypt.hash(newPassword, 10);
    await admin.update({ password: new_password, otp: null, otpExpiresAt: null });

    return res.status(200).json({ status_code: 200, status: true });
  }];