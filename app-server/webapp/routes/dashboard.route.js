var express = require('express');
var router = express.Router();
const dashboardController = require('../controllers/dashboard.controller');
// const Diary = require('../models/diary.model');

/* GET home page. */
router.get('/', dashboardController.dashboardProcessing);
router.post('/add-board', dashboardController.addBoardDashboardProcessing);
router.post('/delete-board', dashboardController.deleteBoardDashboardProcessing);
router.post('/config-board', dashboardController.configBoardDashboardProcessing);
router.post('/add-widget', dashboardController.addWidgetDashboardProcessing);
router.post('/delete-widget', dashboardController.deleteWidgetDashboardProcessing);


module.exports = router;
