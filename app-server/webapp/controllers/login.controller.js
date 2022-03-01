const Index = require('../models/index.model');
const emqxHttp = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`)
let client_list;

function generateClientBrokerId(id){
    return (`uid-${id}-${(new Date()).getTime()}`);
}

exports.loginProcessing = async (req, res, next) => {
    try {
        let db_res = await Index.checkProfileExist(req.body.uname, req.body.psw);
        
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
            
            req.session.dev.new_dev_id = null;

            var sensorQuery = (await Index.selectDeviceSensorFromCustomer(db_res.rows[0]._id)).rows;
            req.session.sensor = sensorQuery;
            // console.log(req.session.sensor[0]['sensor_arr']);
            req.session.dev.client_id = (await generateClientBrokerId(req.session.user.id));
            
            let dev_list = []
            req.session.sensor.forEach((item)=>{
                dev_list.push(item.dev_id);
            });
            
            await emqxHttp.add_client_acl_on_dev_topic(req.session.dev.client_id, dev_list );
            
            
            res.redirect('/dashboard');
        }
        else {
            res.render('main/login', {error_flag: 1})
        }
    } catch (error) {
        console.log(error);
    }
}





