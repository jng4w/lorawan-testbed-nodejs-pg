const Index = require('../models/index.model');
const fs = require('fs');
const emqx_data = JSON.parse(fs.readFileSync(`./../common/emqx.json`));
const emqxHttp = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`)
exports.deviceProcessing = async (req, res, next) => {

    if(req.session.login){
        // console.log(req.session.sensor);
        let dev_list = []
        req.session.sensor.forEach((item)=>{
            dev_list.push(item.dev_id);
        });
        
        // await emqxHttp.add_client_acl_on_dev_topic(req.session.dev.client_id, dev_list );

        var broker = {};
        broker.id = emqx_data["ENDUSER_USERNAME"];
        broker.psw = emqx_data["ENDUSER_PASSWORD"];
        broker.addr = emqx_data["SERVER_ADDR"];
        broker.port = emqx_data["WEBSOCKET_PORT"];

        res.render('main/device', {
            // device: req.session.dev,
            user: req.session.user,
            sensor: req.session.sensor,
            dev_list: dev_list,
            client_id: req.session.dev.client_id,
            broker: broker,
            title: "Device"
        });
    }
    else {
        res.redirect('login');
    }
    

}

exports.addDeviceProcessing = async (req, res, next) => {

    if(req.session.login){
        try {
            (await Index.insertDeviceToCustomer(req.session.user.id, req.body.enddev_id));
            req.session.sensor = (await Index.selectDeviceSensorFromCustomer(db_res.rows[0]._id)).rows;
            console.log(req.session.sensor)
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





