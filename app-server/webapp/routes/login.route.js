var express = require('express');
var router = express.Router();
const loginController = require('../controllers/login.controller');
const { check, validationResult } = require('express-validator');
const { validator } = require('../controllers/validator.controller');

/* GET home page. */
router.get('/', function(req, res, next) {
  
    // Show form dang nhap => loginProcessing
    let message = "";
    res.render('main/login', {message: message});
    //res.render('index', {result: result});
});

router.post('/', 
    validator.validateLogin(),
    loginController.loginProcessing); 

module.exports = router;
