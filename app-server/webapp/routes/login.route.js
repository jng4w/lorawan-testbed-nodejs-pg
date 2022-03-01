var express = require('express');
var router = express.Router();
const loginController = require('../controllers/login.controller');
const emqxHttp = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`)

/* GET home page. */
router.get('/', async function(req, res, next) {
    try {
        if(!req.session.login){
            res.render('main/login', {error_flag: 0});
        }
        else res.redirect('/dashboard');
    } catch (error) {
        console.log(error);
    }

});

router.post('/', loginController.loginProcessing); 

router.post('/logout', async (req, res, next) => {
    try {
        await emqxHttp.kick_client(req.session.dev.client_id);
        req.session.destroy();
        
        res.redirect('/login');
    } catch (error) {
        console.log(error);
    }
}); 

module.exports = router;
