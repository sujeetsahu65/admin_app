const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const authController = require('../controllers/authController');
const shopDbMiddleware = require('../middlewares/shopDbMiddleware');
router.post('/login', authController.login);
router.get('/verify-token',authMiddleware,authController.verifyToken);

router.post('/forgot-password', authController.forgotPassword,shopDbMiddleware,authController.sendPasswordResetOtp);
router.post('/verify-otp',authController.verifyResetPasswordOtp);
router.post('/reset-password', authController.verifyPasswordReset);

module.exports = router;
