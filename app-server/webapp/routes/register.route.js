var express = require('express');
var router = express.Router();
const registerController = require('../controllers/register.controller');
const { check, validationResult } = require('express-validator');
const { validator } = require('../controllers/validator.controller');

/* GET home page. */
router.get('/', function(req, res, next) {
  
    // Show form dang nhap => loginProcessing
    
    res.render('main/register', {
        error_flag: 0,
        message: ""
    });
    //res.render('index', {result: result});
});

router.post('/', 
    validator.validateRegisterPhone(),
    registerController.registerProcessing); 

    router.post('/verify', 
    registerController.verifyProcessing); 

module.exports = router;
