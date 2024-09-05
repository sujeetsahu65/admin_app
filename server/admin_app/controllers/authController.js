const jwt = require('jsonwebtoken');
// const bcrypt = require('bcryptjs');
const { Admin,AdminLogin } = require('../models/super_admin');

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

    res.json({ status_code: 200, status: true, token,role: admin.role });
  } catch (error)
  {
    console.log(error);
    res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};

exports.forgotPassword = async (req, res) =>
{
  const { email, phone } = req.body;
  // Validate that at least one of email or phone is provided
  if (!email && !phone)
  {
    return res.status(400).json({ status_code: 400, status: false, error: 'Please provide either email or phone.' });
  }

  try
  {

    // Send OTP to the provided email or phone
    if (email)
    {
      // Example: Sending OTP to email
      const admin = await Admin.findOne({ where: { status: true, loc_client_email: email } });
      if (!admin) return res.status(404).json({ status_code: 404, status: false, message: 'Admin not found' });
      // await sendOtpToEmail(email, otp);
      return res.json({ status_code: 200, status: true, message: 'OTP sent to email.' });
    } else
    {
      // Example: Sending OTP to phone
      const admin = await Admin.findOne({ where: { loc_client_phone: phone } });
      if (!admin) return res.status(404).json({ status_code: 404, status: false, message: 'Admin not found' });
      // await sendOtpToPhone(phone, otp);
      return res.json({ status_code: 200, status: true, message: 'OTP sent to phone.' });
    }
  } catch (error)
  {
    console.log(error);
    res.status(500).json({ status_code: 500, status: false, message: error.message });
  }

};


// ======== VERIFY TOKEN=========
exports.verifyToken = async (req, res) =>
{

  const { loc_id,role } = req.admin;

  try
  {
    if (loc_id)
    {
      return res.status(200).json({ status_code: 200, status: true, role });
    }

  } catch (error)
  {
    console.log(error);
    return res.status(500).json({ status_code: 500, status: false, message: error.message });
  }
};