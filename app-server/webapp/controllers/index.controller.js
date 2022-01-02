const Index = require('../models/index.model');

exports.indexProcessing = (client_req, client_res, next) => {
    if(client_req.session.login){
        res.redirect('/dashboard');
    }
    else res.redirect('/login');    
}



