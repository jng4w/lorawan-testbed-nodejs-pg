var express = require('express');
var router = express.Router();
const userController = require('../controllers/user.controller');

/* GET users listing. */
router.get('/', function(req, res, next) {
  
    // Show user

    res.render('main/user');
    //res.render('index', {result: result});
});

router.post('/edit', userController.userProcessing);

module.exports = router;
