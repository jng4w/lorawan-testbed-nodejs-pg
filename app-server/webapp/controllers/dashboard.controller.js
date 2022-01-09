const { CommandCompleteMessage } = require('pg-protocol/dist/messages');
const Index = require('../models/index.model');
const fs = require('fs');
const emqx_data = JSON.parse(fs.readFileSync(`./../common/emqx.json`));

exports.dashboardProcessing = async (req, res, next) => {
    
    
    if(req.session.login){
        // console.log((await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows);
        // console.log(req);
        // console.log(req.sessionStore._events.disconnect);
        let dev_list = []
        req.session.sensor.forEach((item)=>{
            dev_list.push(item.dev_id);
        });
        var broker = {};
        broker.id = emqx_data["ENDUSER_USERNAME"];
        broker.psw = emqx_data["ENDUSER_PASSWORD"];
        console.log((await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows);
        res.render('main/dashboard', {
            
            user: req.session.user,
            boardWidget: (await Index.selectBoardWidgetFromCustomer(req.session.user.id)).rows,
            dev_list: dev_list,
            client_id: req.session.dev.client_id,
            broker: broker
        });
    }
    else {
        res.redirect('login');
    }
    
    
    

}





