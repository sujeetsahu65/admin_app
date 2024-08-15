const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const authController = require('../controllers/authController');
router.post('/login', authController.login);
router.post('/forgot-password', authController.forgotPassword);

router.get('/verify-token',authMiddleware,authController.verifyToken);
module.exports = router;
