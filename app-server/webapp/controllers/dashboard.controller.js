const { CommandCompleteMessage } = require('pg-protocol/dist/messages');
const Index = require('../models/index.model');
const fs = require('fs');
const emqx_data = JSON.parse(fs.readFileSync(`./../common/emqx.json`));
const emqxHttp = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`)

function uniqueByKey(array, key, value) {
    return [...new Map(array.map((x) => [x[key], {
        key: x[key], 
        value: x[value]
    }])).values()];
  }

exports.dashboardProcessing = async (req, res, next) => {
    
    
    if(req.session.login){
        // console.log((await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows);
        // console.log(req);
        // console.log(req.sessionStore._events.disconnect);
        let dev_list = [];
        req.session.sensor.forEach((item)=>{
            dev_list.push(item.dev_id);
        });
        
        await emqxHttp.add_client_acl_on_dev_topic(req.session.dev.client_id, dev_list );
        
        var broker = {};
        broker.id = emqx_data["ENDUSER_USERNAME"];
        broker.psw = emqx_data["ENDUSER_PASSWORD"];
        broker.addr = emqx_data["SERVER_ADDR"];
        broker.port = emqx_data["WEBSOCKET_PORT"];

        var boardWidget = (await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows;
        // console.log((await Index.selectBoardFromCustomer(req.session.user.id)).rows.length);
        res.render('main/dashboard', {
            
            user: req.session.user,
            board: (await Index.selectBoardFromCustomer(req.session.user.id)).rows,
            boardWidget: boardWidget,
            widgetType: (await Index.selectWidgetType()).rows,
            sensor: req.session.sensor,
            dev_list: JSON.stringify(dev_list),
            client_id: req.session.dev.client_id,
            broker: broker,
            title: "Dashboard"
        });
    }
    else {
        res.redirect('../login');
    }
    
    
    

}

exports.addBoardDashboardProcessing = async (req, res, next) => {
    
    if(req.session.login){
        try {
            (await Index.insertBoardToCustomer(req.session.user.id, req.body.board_name));
            res.redirect('../dashboard');
        }
        catch(err) {
            console.log(err.detail);
            res.redirect('../dashboard');
        }
    }
    else {
        res.redirect('../login');
    }
}

exports.addWidgetDashboardProcessing = async (req, res, next) => {
    
    if(req.session.login){
        console.log('data', JSON.stringify(req.body) );
        let body = req.body;
        let no_sensor_data = body.no_sensor_data;

        //List device, sensor
        let device = [];
        let sensor = [];
        for(let i=0; i < no_sensor_data; i++){
            device.push(JSON.parse(body[`DeviceData-${i}`]).dev_id);
            sensor.push(body[`SensorData-${i}`]);
            body[`DeviceData-${i}`] = null;
            body[`SensorData-${i}`] = null;
        }

        //UI_CONFIG col
        
        let w_type = body.WidgetType.split('-')[0];
        let ui_config = (await Index.selectWidgetType(w_type)).rows[0].ui_config;
        for(let i in body){
            if(i.startsWith(`addWidgetType-${w_type}`)){
                let data = i.split('-');

                if(ui_config.view[data[2]]){
                    ui_config.view[data[2]] = body[i].toLowerCase();         
                }
                else ui_config.view[data[2]] = null;

                ui_config.numberOfDataSource.number = parseInt(body.no_sensor_data);
                
            }
        }

        console.log('data', device.toString(), sensor.toString() );
        await Index.insertWidgetToBoard(body.widget_name, ui_config, body.board_id, w_type, device.toString(), sensor.toString());
        
        // try {
        //     (await Index.insertBoardToCustomer(req.session.user.id, req.body.board_name));
             res.redirect('../dashboard');
        // }
        // catch(err) {
        //     console.log(err.detail);
        //     res.redirect('../dashboard');
        // }
    }
    else {
        res.redirect('../login');
    }

}





