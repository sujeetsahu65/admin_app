const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const shopDbMiddleware = require('../middlewares/shopDbMiddleware');
const basicDataController = require('../controllers/basicDataController');

router.get('/general-data',authMiddleware,shopDbMiddleware, basicDataController.getGeneralData);
router.get('/language-data', basicDataController.getLanguageData);
router.get('/version', basicDataController.getAppVersion);

module.exports = router;
