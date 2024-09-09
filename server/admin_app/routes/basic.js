const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const shopDbMiddleware = require('../middlewares/shopDbMiddleware');
const basicDataController = require('../controllers/basicDataController');

router.get('/general-data',authMiddleware,shopDbMiddleware, basicDataController.getGeneralData);
router.get('/language-data', basicDataController.getLanguageData);
router.get('/version', basicDataController.getAppVersion);
router.get('/food-display-data',authMiddleware,shopDbMiddleware, basicDataController.getFoodDisplayData);
router.get('/menu/menu-categories',authMiddleware,shopDbMiddleware, basicDataController.getMenuCategories);
router.get('/menu/food-categories',authMiddleware,shopDbMiddleware, basicDataController.getFoodCategories);
router.get('/menu/food-items',authMiddleware,shopDbMiddleware, basicDataController.getFoodItems);
router.put('/menu/food-item-display',authMiddleware,shopDbMiddleware, basicDataController.updateFoodItemDisplayStatus);

module.exports = router;
