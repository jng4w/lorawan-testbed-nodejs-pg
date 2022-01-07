const Index = require('../models/index.model');

exports.deviceProcessing = async (req, res, next) => {

    if(req.session.login){
        console.log(req.session.sensor);
        res.render('main/device', {
            // device: req.session.dev,
            user: req.session.user,
            sensor: req.session.sensor
        });
    }
    else {
        res.redirect('login');
    }
    

}

exports.addDeviceProcessing = async (req, res, next) => {

    
    

}





