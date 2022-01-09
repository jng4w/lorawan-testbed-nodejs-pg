const Index = require('../models/index.model');

exports.deviceProcessing = async (req, res, next) => {

    if(req.session.login){
        // console.log(req.session.sensor);
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

    if(req.session.login){
        try {
            (await Index.insertDeviceToCustomer(req.session.user.id, req.body.enddev_id)).rows;
            var sensorQuery = (await Index.selectDeviceSensorFromCustomer(db_res.rows[0]._id)).rows;
            req.session.sensor = sensorQuery;
            res.redirect('/device');
        }
        catch(err) {
            console.log(err.detail);
            res.redirect('/device');
        }
    }
    
    

}

exports.configureDeviceProcessing = async (req, res, next) => {

    // if(req.session.login){
    //     try {
    //     }
    //     catch(err) {
    //         console.log(err.detail);
    //     }
    // }

}





