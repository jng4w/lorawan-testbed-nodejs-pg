var express = require('express');
var router = express.Router();
const loginController = require('../controllers/login.controller');

/* GET home page. */
router.get('/', function(req, res, next) {
  
    // Show form dang nhap => loginProcessing

    res.render('login');
    //res.render('index', {result: result});
});

router.post('/', loginController.loginProcessing);  

module.exports = router;
