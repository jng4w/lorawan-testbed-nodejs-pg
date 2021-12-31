var express = require('express');
var router = express.Router();
// const Diary = require('../models/diary.model');

/* GET home page. */
router.get('/', function(req, res, next) {
  
    // Show dashboard & modify

    res.render('main/dashboard', {result: 1});
    //res.render('index', {result: result});
});

module.exports = router;
