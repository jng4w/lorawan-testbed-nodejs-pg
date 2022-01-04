const Index = require('../models/index.model');

exports.indexProcessing = async (req, res, next) => {
    res.redirect('/login'); 
    // if(req.session.login){
    //     res.redirect('/dashboard');
    // }
    // else res.redirect('/login');    
}



