const Index = require('../models/index.model');

exports.indexProcessing = async (req, res, next) => {
    try {
        res.redirect('/dashboard');
    } catch (error) {
        console.log(error);
    }
}



