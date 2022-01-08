var express = require('express');
var router = express.Router();
const userController = require('../controllers/user.controller');

/* GET users listing. */
router.get('/', userController.userProcessing);

router.post('user/edit', userController.editProfileProcessing);

module.exports = router;
