const Index = require('../models/index.model');

exports.userProcessing = async (req, res, next) => {
    try {
        if(req.session.login){

            res.render('main/user', {
                error_flag: 0,
                message: "",
                user: req.session.user,
                title: "User"
            })
        }
        else {
            res.redirect('login');
        }
    } catch (error) {
        console.log(error);
    }
}


exports.editProfileProcessing = async (req, res, next) => {
    try {

    } catch (error) {
        console.log(error);
    }

}


