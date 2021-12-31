var express = require('express');
var router = express.Router();
// const Diary = require('../models/diary.model');

/* GET home page. */
router.get('/', function(req, res, next) {
  
    // Neu dang nhap roi: dashboard, chua dang nhap: login
    res.render('index');
    // res.redirect('/dashboard');
    //res.render('index', {result: result});
});

module.exports = router;


