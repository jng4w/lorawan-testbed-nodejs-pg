var express = require('express');
var router = express.Router();
const dashboardController = require('../controllers/dashboard.controller');
// const Diary = require('../models/diary.model');

/* GET home page. */
router.get('/', dashboardController.dashboardProcessing);
router.post('/add-board', dashboardController.addBoardDashboardProcessing);
router.post('/add-widget', dashboardController.addWidgetDashboardProcessing);

module.exports = router;
