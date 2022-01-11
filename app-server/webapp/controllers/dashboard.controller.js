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

        var boardWidget = (await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows;
        console.log(boardWidget);
        // console.log(uniqueByKey(boardWidget, 'board_id', 'b_display_name'));
        // console.log((await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows);
        res.render('main/dashboard', {
            
            user: req.session.user,
            board: uniqueByKey(boardWidget, 'board_id', 'b_display_name'),
            boardWidget: boardWidget,
            dev_list: dev_list,
            client_id: req.session.dev.client_id,
            broker: broker,
            title: "Dashboard"
        });
    }
    else {
        res.redirect('login');
    }
    
    
    

}





