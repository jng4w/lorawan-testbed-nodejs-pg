const Index = require('../models/index.model');
const {validationResult } = require('express-validator');

exports.loginProcessing = async (req, res, next) => {
    console.log(req.body.uname, req.body.psw);
    // console.log(Index.checkProfileExist(req.body.uname, req.body.psw));

    console.log(await Index.checkProfileExist(req.body.uname, req.body.psw));

}





