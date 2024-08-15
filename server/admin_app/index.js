
const express = require('express');
const bodyParser = require('body-parser');
// process.env.TZ = "Europe/Helsinki";
const app = express();
app.use(bodyParser.json());
const router = express.Router();
const authRoutes = require('./routes/auth');
const basicDataRoutes = require('./routes/basic');
const orderRoutes = require('./routes/order');


app.use('/auth', authRoutes);
app.use('/basic', basicDataRoutes);
app.use('/order', orderRoutes);

module.exports = app;