const Index = require('../models/index.model');
const {validationResult } = require('express-validator');

exports.loginProcessing = async (req, res, next) => {
    // console.log(req.body.uname, req.body.psw);
    // console.log(Index.checkProfileExist(req.body.uname, req.body.psw));

    var db_res = await Index.checkProfileExist(req.body.uname, req.body.psw);
    if(db_res.rowCount){
        
        req.session.login = 1;
        req.session.id = db_res.rows[0]._id;
        req.session.display_name = db_res.rows[0].display_name;
        req.session.phone_number = db_res.rows[0].phone_number;
        req.session.email = db_res.rows[0].email;
        req.session.type = db_res.rows[0].type;

        res.redirect('/dashboard');
    }
    else {
        res.render('main/login', {error_flag: 1})
    }
    
    

}





