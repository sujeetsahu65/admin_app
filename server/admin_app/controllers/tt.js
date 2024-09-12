const express = require('express');
const router = express.Router();
const { VisitingTiming, LunchTiming, DeliveryTiming } = require('../models'); // Sequelize models
const { body, validationResult } = require('express-validator'); // For validation

// Update timing for a specific table (visiting, lunch, delivery)
router.put('/update-timing', [
  body('dayNumber').isInt().withMessage('Day number must be an integer'),
  body('fromTime').matches(/^([01]\d|2[0-3]):([0-5]\d)$/).withMessage('Invalid fromTime format, expected HH:mm'),
  body('toTime').matches(/^([01]\d|2[0-3]):([0-5]\d)$/).withMessage('Invalid toTime format, expected HH:mm'),
  body('closeStatus').isBoolean().withMessage('closeStatus must be a boolean'),
  body('tableName').isString().withMessage('Table name is required'),
], async (req, res) => {
  // Handle validation errors
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    return res.status(400).json({ errors: errors.array() });
  }

  const { dayNumber, fromTime, toTime, closeStatus, tableName } = req.body;

  try {
    let model;

    // Determine the model based on the tableName
    if (tableName === 'visiting') {
      model = VisitingTiming;
    } else if (tableName === 'lunch') {
      model = LunchTiming;
    } else if (tableName === 'delivery') {
      model = DeliveryTiming;
    } else {
      return res.status(400).json({ error: 'Invalid tableName' });
    }

    // Find the timing record by dayNumber
    const timing = await model.findOne({ where: { dayNumber } });

    if (!timing) {
      return res.status(404).json({ error: 'Timing record not found' });
    }

    // Update the timing record
    timing.fromTime = fromTime;
    timing.toTime = toTime;
    timing.closeStatus = closeStatus;

    await timing.save();

    res.json({ message: 'Timing updated successfully', timing });
  } catch (err) {
    res.status(500).json({ error: 'Server error' });
  }
});

module.exports = router;
