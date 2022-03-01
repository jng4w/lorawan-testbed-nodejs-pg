const Index = require('../models/index.model');
const {validationResult } = require('express-validator');
const nodemailer = require('nodemailer');
var smtpTransport = require('nodemailer-smtp-transport');
var handlebars = require('handlebars');
const fs = require('fs');
const mail = JSON.parse(fs.readFileSync('./../common/mail.json'));

const transporter = nodemailer.createTransport({
  service: mail["TRANSPORTER_SERVICE"],
  auth: {
    user: mail["TRANSPORTER_EMAIL"],
    pass: mail["TRANSPORTER_PASSWORD"]
  }
});

function generate_code(length=6) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * 
 charactersLength));
   }
   return result;
}

function sendmail(email, code){
    var readHTMLFile = function(path, callback) {
        fs.readFile(path, {encoding: 'utf-8'}, function (err, html) {
            if (err) {
                throw err;
                callback(err);
            }
            else {
                callback(null, html);
            }
        });
    };
    
    readHTMLFile(mail["PATH"], function(err, html) {
        var template = handlebars.compile(html);
        var replacements = {
            //  username: "John Doe"
            vcode: code
        };
        var htmlToSend = template(replacements);
        var mailOptions = {
            to: email, //to: client_req.session.email,
            from: mail["TRANSPORTER_EMAIL"],
            subject: mail["EMAIL_HEADER"],
            // text: 'Your code is: ' + code
            html: htmlToSend
        };
        transporter.sendMail(mailOptions, function (error, response) {
            if (error) {
                console.log(error);
                callback(error);
            }
        });
    });
}

exports.registerProcessing = async (req, res, next) => {
    try {
        const errors = validationResult(req);

        if (!errors.isEmpty()) {
            res.render('main/register', {
                error_flag: 1,
                message: "Invalid Phone number!"
            })
            return;
        }

        var body = req.body;
        var db_res = (await Index.checkProfileExistRegister(body.email, body.phone_number, body.psw)).rowCount;
        
        if(!db_res){

            req.session.vcode = generate_code();
            sendmail(body.email, req.session.vcode);
            req.session.email = body.email;
            req.session.phone = body.phone;
            req.session.psw = body.psw;
            req.session.name = body.fname + " " + body.lname;
            
            res.render('main/verify', {
                error_flag: 0,
                message: ""
            });
        }
        else {
            res.render('main/register', {
                error_flag: 1,
                message: "Email/Phone number already existed!"
            })
        }
    } catch (error) {
        console.log(error);
    }
}

exports.verifyProcessing = async (req, res, next) => {
    try {
        if(req.body.code == req.session.vcode){
            var body = req.session;
            var db_res = await Index.insertProfile(body.email, body.phone, body.psw, 'CUSTOMER', body.name);
            delete req.session.email;
            delete req.session.phone;
            delete req.session.psw;
            delete req.session.name; 
            res.render('main/noti', {
                error_flag: 0,
                success_flag: 1,
                message: "Register successfully!"
            })
        }
    } catch (error) {
        console.log(error);
    }
}





