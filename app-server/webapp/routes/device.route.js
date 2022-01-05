var express = require('express');
var router = express.Router();
// const Diary = require('../models/diary.model');
const deviceController = require('../controllers/device.controller');
/* GET home page. */
router.get('/', function(req, res, next) {
  
    // Show device & modify

    res.render('main/device');
    //res.render('index', {result: result});
});

router.post('/add', deviceController.addDeviceProcessing);

module.exports = router;
