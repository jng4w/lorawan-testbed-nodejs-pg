var express = require('express');
var router = express.Router();
// const Diary = require('../models/diary.model');
const deviceController = require('../controllers/device.controller');
/* GET home page. */
router.get('/', deviceController.deviceProcessing);

router.post('/add', deviceController.addDeviceProcessing);

router.post('/configure-device', deviceController.configureDeviceProcessing);

router.post('/delete-device', deviceController.deleteDeviceProcessing);

module.exports = router;
