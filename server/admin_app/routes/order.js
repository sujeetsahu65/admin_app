const express = require('express');
const router = express.Router();
const authMiddleware = require('../middlewares/authMiddleware');
const shopDbMiddleware = require('../middlewares/shopDbMiddleware');
const orderController = require('../controllers/orderController');

router.get('/new-orders',authMiddleware,shopDbMiddleware, orderController.getNewOrders);
router.get('/cancelled-orders',authMiddleware,shopDbMiddleware, orderController.getCancelledOrders);
router.get('/received-orders',authMiddleware,shopDbMiddleware, orderController.getReceivedOrders);
router.get('/failed-orders',authMiddleware,shopDbMiddleware, orderController.getFailedOrders);
router.get('/pre-orders',authMiddleware,shopDbMiddleware, orderController.getPreOrders);
router.get('/order-details',authMiddleware,shopDbMiddleware, orderController.getOrderDetails);
router.put('/pre-order/alert-time',authMiddleware,shopDbMiddleware, orderController.setPreOrderResponseAlertTime);
// router.put('/pre-order/to-current-order',authMiddleware,shopDbMiddleware, orderController.setPreOrderToCurrentOrder);
router.put('/delivery-time',authMiddleware,shopDbMiddleware, orderController.setOrderDeliveryTime);
router.put('/conclude',authMiddleware,shopDbMiddleware, orderController.concludeOrder);
router.put('/cancel',authMiddleware,shopDbMiddleware, orderController.cancelOrder);
router.get('/order-items',authMiddleware,shopDbMiddleware, orderController.orderItems);
router.get('/order-toppings',authMiddleware,shopDbMiddleware, orderController.orderItemToppings);
router.get('/combo-offer-items',authMiddleware,shopDbMiddleware, orderController.orderComboOfferItems);
router.get('/combo-offer',authMiddleware,shopDbMiddleware, orderController.comboOfferById);
router.get('/report',authMiddleware,shopDbMiddleware, orderController.getReports);

module.exports = router;
