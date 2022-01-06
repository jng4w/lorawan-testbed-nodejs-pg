const Index = require('../models/index.model');

exports.indexProcessing = async (req, res, next) => {
    res.redirect('/dashboard');
    // res.render('main/stream2');
    // res.redirect('/login'); 
    // if(req.session.login){
    //     res.redirect('/dashboard');
    // }
    // else res.redirect('/login');    
}



