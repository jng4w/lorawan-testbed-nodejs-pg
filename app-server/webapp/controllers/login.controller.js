const Index = require('../models/index.model');
const emqxHttp = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`)
let client_list;
// const {validationResult } = require('express-validator');
// let client_id = 1000;

function generateClientBrokerId(id){
    return (`uid-${id}-${(new Date()).getTime()}`);
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
        req.session.dev.client_id = generateClientBrokerId(req.session.user.id);
        
        let dev_list = []
        sensorQuery.forEach((item)=>{
            dev_list.push(item.dev_id);
        });
        // console.log(sensorQuery);
        
        // console.log(client_list[0]);
        // client_list.forEach((item, index)=>{
        //     if(item == null) {
        //         console.log(index, 'NULL');
        //     }
        //     else {
        //         console.log(index, 'Object');
        //     }
        // })
        // emqxHttp.add_client_acl_on_dev_topic(req.session.dev.client_id, dev_list );
        res.redirect('/dashboard');
    }
    else {
        res.render('main/login', {error_flag: 1})
    }
    
    

}





