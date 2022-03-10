const Index = require('../models/index.model');
const fs = require('fs');
const emqx_data = JSON.parse(fs.readFileSync(`./../common/emqx.json`));
const emqxHttp = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`)
exports.deviceProcessing = async (req, res, next) => {
    try {
        if(req.session.login){
            let dev_list = []
            let dev_type_id = []
            req.session.sensor.forEach((item)=>{
                dev_list.push(item.dev_id);
                dev_type_id.push(item.dev_type_id);
            });
            
            var new_dev_id = req.session.dev.new_dev_id;
            req.session.dev.new_dev_id = null;
            await emqxHttp.add_client_acl_on_dev_topic(req.session.dev.client_id, dev_list );

            var broker = {};
            broker.id = emqx_data["ENDUSER_USERNAME"];
            broker.psw = emqx_data["ENDUSER_PASSWORD"];
            broker.addr = emqx_data["SERVER_ADDR"];
            broker.port = emqx_data["WEBSOCKET_PORT"];
            
            res.render('main/device', {
                user: req.session.user,
                new_dev_id: new_dev_id,
                sensor: req.session.sensor,
                dev_list: JSON.stringify(dev_list),
                dev_type_id: JSON.stringify(dev_type_id),
                client_id: req.session.dev.client_id,
                broker: broker,
                title: "Device"
            });
        }
        else {
            res.redirect('login');
        }
    } catch (error) {
        console.log(error);
    }
}

exports.addDeviceProcessing = async (req, res, next) => {
    try {
        if(req.session.login){
            try {
                (await Index.insertDeviceToCustomer(req.session.user.id, req.body.enddev_id));
                req.session.dev.new_dev_id = req.body.enddev_id;
                req.session.sensor = (await Index.selectDeviceSensorFromCustomer(req.session.user.id)).rows;
                
                console.log(req.session.sensor);
                res.redirect('/device');
            }
            catch(err) {
                console.log(err.detail);
                res.redirect('/device');
            }
        }
    } catch (error) {
        console.log(error);
    }
}

exports.configureDeviceProcessing = async (req, res, next) => {
    try {    
        
    } catch (error) {
        console.log(error);
    }
}

exports.deleteDeviceProcessing = async (req, res, next) => {
    try {
        if(req.session.login){
            console.log(req.session.user.id, req.body.device_id)
            await Index.deleteDeviceFromCustomer(req.session.user.id, req.body.device_id);

            await emqxHttp.unsubscribe_dev_topic_of_clientid(req.session.dev.client_id, [req.body.device_id]);
            await emqxHttp.del_client_acl_on_dev_topic(req.session.dev.client_id, [req.body.device_id]);

            req.session.dev.new_dev_id = req.body.enddev_id;
            req.session.sensor = (await Index.selectDeviceSensorFromCustomer(req.session.user.id)).rows;
            res.redirect('../device');
        }
        else {
            res.redirect('../login');
        }
    }
    catch (error) {
        console.log(error);
    }
}





