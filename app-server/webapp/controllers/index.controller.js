const Index = require('../models/index.model');

exports.indexProcessing = async (req, res, next) => {
    // if(client_req.session.login){
    //     res.redirect('/dashboard');
    // }
    // else res.redirect('/login');    
    res.redirect('/dashboard');
}



