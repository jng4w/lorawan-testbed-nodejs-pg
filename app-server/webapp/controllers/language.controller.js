const Index = require('../models/index.model');

exports.languageProcessing = async (req, res, next) => {
    
    res.cookie('lang', req.params.lang, { maxAge: 900000 });
    res.redirect('back');
}



