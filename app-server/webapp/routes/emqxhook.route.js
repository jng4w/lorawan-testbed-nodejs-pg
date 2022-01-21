var express = require('express');
var router = express.Router();
const emqxhookController = require('../controllers/emqxhook.controller');

/* GET home page. */
router.post('/', emqxhookController.hookProcessing);

module.exports = router;
