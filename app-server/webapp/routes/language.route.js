var express = require('express');
var router = express.Router();
const languageController = require('../controllers/language.controller');

// GET language option
router.get('/:lang', languageController.languageProcessing);

module.exports = router;