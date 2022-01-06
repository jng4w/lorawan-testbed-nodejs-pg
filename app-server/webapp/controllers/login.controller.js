const Index = require('../models/index.model');
const {validationResult } = require('express-validator');

exports.loginProcessing = async (req, res, next) => {
    // console.log(req.body.uname, req.body.psw);
    // console.log(Index.checkProfileExist(req.body.uname, req.body.psw));

    var db_res = await Index.checkProfileExist(req.body.uname, req.body.psw);
    if(db_res.rowCount){
        
        //retrive user data
        req.session.login = 1;
        req.session.id = db_res.rows[0]._id;
        req.session.display_name = db_res.rows[0].display_name;
        req.session.phone_number = db_res.rows[0].phone_number;
        req.session.email = db_res.rows[0].email;
        req.session.type = db_res.rows[0].type;

        //retrive enddev metadata
        var data = (await Index.selectDevicesFromCustomer(req.session.id)).rows;
        var dev_id = [];
        data.forEach((item) => {
            // console.log(item.dev_id);
            dev_id.push(item.dev_id)
        })
        req.session.dev_id = dev_id;

        res.redirect('/dashboard');
    }
    else {
        res.render('main/login', {error_flag: 1})
    }
    
    

}





