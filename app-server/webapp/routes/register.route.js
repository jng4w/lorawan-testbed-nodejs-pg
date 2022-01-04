var express = require('express');
var router = express.Router();
const registerController = require('../controllers/register.controller');
const { check, validationResult } = require('express-validator');
const { validator } = require('../controllers/validator.controller');

/* GET home page. */
router.get('/', function(req, res, next) {
  
    // Show form dang nhap => loginProcessing
    let message = "";
    res.render('main/register', {message: message});
    //res.render('index', {result: result});
});

router.post('/', 
    validator.validateRegister(),
    registerController.registerProcessing); 

module.exports = router;
