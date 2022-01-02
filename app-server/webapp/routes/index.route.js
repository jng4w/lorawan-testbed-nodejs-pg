var express = require('express');
var router = express.Router();
const indexController = require('../controllers/index.controller');

/* GET home page. */
router.get('/', indexController.indexProcessing);

module.exports = router;


