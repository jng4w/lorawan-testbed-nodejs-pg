const Index = require('../models/index.model');

exports.dashboardProcessing = async (req, res, next) => {
    
    if(req.session.login){
        res.render('main/dashboard', {
            devices: 1
        });
    }
    else {
        res.render('main/login', {error_flag: 1})
    }
    
    
    

}





