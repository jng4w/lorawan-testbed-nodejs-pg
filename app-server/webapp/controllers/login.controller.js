const Index = require('../models/index.model');
const {validationResult } = require('express-validator');
let client_id = 1000;

function generateClientBrokerId(){
    return (`uid-${(client_id++).toString(16)}-${(new Date()).getTime()}`);
}

exports.loginProcessing = async (req, res, next) => {
    // console.log(req.body.uname, req.body.psw);
    // console.log(Index.checkProfileExist(req.body.uname, req.body.psw));
    console.log(generateClientBrokerId());
    var db_res = await Index.checkProfileExist(req.body.uname, req.body.psw);
    
    if(db_res.rowCount){
        
        //retrive user data
        req.session.login = 1;
        req.session.user = {};
        req.session.user.id = db_res.rows[0]._id;
        req.session.user.display_name = db_res.rows[0].display_name;
        req.session.user.phone_number = db_res.rows[0].phone_number;
        req.session.user.email = db_res.rows[0].email;
        req.session.user.type = db_res.rows[0].type;
        req.session.dev = {};
        req.session.dev.id = generateClientBrokerId();
        // console.log(req.session.user);

        //retrive enddev metadata
        // var deviceQuery = (await Index.selectDeviceFromCustomer(db_res.rows[0]._id)).rows;
        // var dev = [];
        // deviceQuery.forEach((item) => {
        //     // console.log(item.dev_id);
        //     dev.push({
        //         dev_id: item.dev_id,
        //         no_sensor: item.no_sensor
        //     })
        // })
        // req.session.dev = dev;

        var sensorQuery = (await Index.selectDeviceSensorFromCustomer(db_res.rows[0]._id)).rows;
        req.session.sensor = sensorQuery;
        
        res.redirect('/dashboard');
    }
    else {
        res.render('main/login', {error_flag: 1})
    }
    
    

}





