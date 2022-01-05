const Index = require('../models/index.model');

exports.userProcessing = async (req, res, next) => {
    // console.log(req.body.uname, req.body.psw);
    // console.log(Index.checkProfileExist(req.body.uname, req.body.psw));

    if(req.session.login){

        res.render('main/user', {
            error_flag: 0,
            message: "",
            user: req.session
        })
    }
    else {
        res.redirect('login');
    }
    
    

}





