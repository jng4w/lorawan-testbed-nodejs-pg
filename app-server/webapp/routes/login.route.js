var express = require('express');
var router = express.Router();
const loginController = require('../controllers/login.controller');
const { check, validationResult } = require('express-validator');
const { validator } = require('../controllers/validator.controller');

/* GET home page. */
router.get('/', function(req, res, next) {
    // if(!req.session.login){
        // Show form dang nhap => loginProcessing
        
        res.render('main/login', {error_flag: 0});
        //res.render('index', {result: result});
    // }
    

});

router.post('/', 
    validator.validateLogin(),
    loginController.loginProcessing); 

module.exports = router;
