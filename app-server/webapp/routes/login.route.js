var express = require('express');
var router = express.Router();
const loginController = require('../controllers/login.controller');
const emqxHttp = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`)

/* GET home page. */
router.get('/', async function(req, res, next) {
    // if(!req.session.login){
        // Show form dang nhap => loginProcessing
        if(!req.session.login){
            res.render('main/login', {error_flag: 0});
        }
        else res.redirect('/dashboard');
        
        //res.render('index', {result: result});
    // }
    

});

router.post('/', loginController.loginProcessing); 

router.post('/logout', async (req, res, next) => {
    await emqxHttp.kick_client(req.session.dev.client_id);
    req.session.destroy();
    
    res.redirect('/login');
}); 

module.exports = router;
