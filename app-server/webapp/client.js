const nodemailer = require('nodemailer');
const transporter = nodemailer.createTransport({
  service: 'gmail',
  auth: {
    user: 'jingnguyen10@gmail.com',
    pass: 'Zxcvbnm200'
  }
});

const express = require('express')
const bp = require('body-parser')
const session = require('express-session')

const app = express()
const port = 3000

const { Client } = require('pg')
const client = new Client({
  user: 'postgres',
  host: 'localhost',
  database: 'lora_database',
  password: '123',
  port: 5432,
})

//Using session to save account data
app.use(session({
	secret: 'secret',
	resave: true,
	saveUninitialized: true
}));

//To parse data from request
app.use(bp.json())
app.use(bp.urlencoded({ extended: true }))

//File system setting
app.use(express.static('public'))
app.use('/css',express.static(__dirname + 'public/css'))
app.use('/img',express.static(__dirname + 'public/img'))
app.use('/js',express.static(__dirname + 'public/js'))

app.set('views', './views')
app.set('view engine', 'ejs')

//Request handling
app.get('',(client_req, client_res) => {
    client_res.render('home', {login: client_req.session.loggedin})
  })

app.get('/login', ( client_req, client_res) => {
    client_res.render('login', {message: client_req.query.e});
})

app.get('/register',(client_req, client_res) => {
    client_res.render('register', {e: client_req.query.e})
})

app.post('/auth', ( client_req, client_res) => {
    var username = client_req.body.uname;
	var password = client_req.body.psw;
    if (username && password) {
        client.query(
            
            "select * from client inner join profile on client.profile_id = profile.profile_id and client.profile_id = "+ username +";",
            (err, db_res) => {
                try {
                    if (err) throw err;
                    var user_data = db_res.rows[0];
                    console.log(user_data);
                    if(db_res.rowCount == 1 && user_data.password == password) {
                        client_req.session.loggedin = true;
                        client_req.session.username = user_data.profile_id;
                        client_req.session.email = user_data.email;
                        client_req.session.phone = user_data.phone;
                        client_req.session.password = user_data.password;
                        client_req.session.displayname = user_data.displayname;
                        console.log('Client detected!');
                        client_res.redirect('/');
                    }
                    else {
                        client_res.redirect('/login?e=' + encodeURIComponent('Incorrect Username and/or Password!'));

                    }	
                    client.end;
                }
                catch(err){
                    
                    if(err.constraint=='profile_pkey') console.log('Invalid');
                    else if (err.routine == 'errorMissingColumn') console.log('Invalid input');
                    else {
                        console.log(err);
                    }
                    client.end;
                }
            }
        );	
	} 
    else {
        client_res.redirect('/login?e=' + encodeURIComponent('Please enter Username and Password!'));
		client_res.end();
	}

})

app.post('/reg_auth', ( client_req, client_res) => {
    
    var username = client_req.body.uname;
	var password = client_req.body.psw;
    var email =  client_req.body.email;
    var displayname = client_req.body.dname;
    var phone = client_req.body.phone;
    if (username && password && email && displayname && phone) {
        client.query(
            "select * from profile where profile_id = "+ username +" or email = '" + email +"';",
            (err, db_res) => {
                try {
                    
                    var message = '';
                    var i=0;
                    if (err) throw err;
                    
                    
                    
                    for(let cnt = 0; cnt < db_res.rowCount; cnt++){
                        var user_data = db_res.rows[cnt];
                        console.log(user_data);
                        if(user_data.profile_id == username) {
                            message += encodeURIComponent('Username already exists\n');
                            i++;
                        }
                        if(user_data.email == email){
                            message += encodeURIComponent('Email already exists\n');
                            i++;
                        }
                    }
                    if(i) client_res.redirect('/register?e=' + message);
                    else {
                        
                        client_req.session.uname = client_req.body.uname;
                        client_req.session.psw = client_req.body.psw;
                        client_req.session.email =  client_req.body.email;
                        client_req.session.dname = client_req.body.dname;
                        client_req.session.phone = client_req.body.phone;
                        console.log(client_req.session);
                        client_res.redirect('/verify');
                    }
                    
                    client.end;
                }
                catch(err){
                    
                    if(err.constraint=='profile_pkey') console.log('Invalid');
                    else if (err.routine == 'errorMissingColumn') console.log('Invalid input');
                    else {
                        console.log(err);
                    }
                    client.end;
                }
            }
        );	
	} 
    else {
        client_res.redirect('/login?e=' + encodeURIComponent('Please enter all infomation!'));
		client_res.end();
	}

})

app.get('/verify', ( client_req, client_res) => {
    console.log(client_req.body);

    client_req.session.generate_code = generate_code(5);
    var mailOptions = {
        to: client_req.session.email, //to: client_req.session.email,
        from: 'jingnuyen10@gmail.com',
        subject: 'BKLORAWAN: EMAIL VERIFICATION',
        text: 'Your code is: ' + client_req.session.generate_code
        };
        
    transporter.sendMail(mailOptions, function(error, info){
    if (error) {
        console.log(error);
    } else {
        console.log('Email sent: ' + info.response);
    }
    });
    client_res.render('verify', {register: false, message: ''});
    
    

})

app.post('/verify', ( client_req, client_res) => {
    console.log(client_req.body);
    if(client_req.body.request_code) {
        if(client_req.body.request_code == client_req.session.generate_code){
            client_res.render('verify', {register: true});
            client.query(
                "insert into profile (profile_id, email, password, phone) values (" +
                    client_req.session.uname + ",'" +
                    client_req.session.email + "','" + 
                    client_req.session.psw + "'," + 
                    client_req.session.phone +
                "); insert into client (profile_id, displayname) values (" +
                    client_req.session.uname + ",'" +
                    client_req.session.dname + "'" + 
                ");",
                (err, db_res) => {
                    try {
                        if (err) throw err;
                        console.log('One client inserted');
                        
                        client.end;
                    }
                    catch(err){
                        
                        if(err.constraint=='profile_pkey') console.log('Invalid');
                        else if (err.routine == 'errorMissingColumn') console.log('Invalid input');
                        else {
                            console.log(err);
                        }
                        client.end;
                    }
                }
            );	
        }
        else {
            client_res.render('verify', {register: false, message: 'Wrong code!'});
        }
    }
    
    

})

app.get('/profile', ( client_req, client_res) => {
    client_res.render('profile', {
        displayname: client_req.session.displayname,
        username: client_req.session.username,
        email: client_req.session.email,
        phone: client_req.session.phone,
        password: client_req.session.password
    });
})

app.post('/signout', ( client_req, client_res) => {
    client_req.session.destroy(function(err){
        client_res.redirect('/');
    });
    
})

client.connect(function(err) {
    try {
        if (err) throw err;
        console.log("Successfully connect to postgreSQL!");  
        
        app.listen(port, () => {
            console.log(`Example app listening at http://localhost:${port}`)
        })
    }
    catch(err){
        console.log(err);
        client.end;
    }
});

function generate_code(length) {
    var result           = '';
    var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    var charactersLength = characters.length;
    for ( var i = 0; i < length; i++ ) {
      result += characters.charAt(Math.floor(Math.random() * 
 charactersLength));
   }
   return result;
}

// client.query(
//     "insert into profile (profile_id, email, password, phone) values (0, 'tinh.nguyen9@hcmut.edu.vn', '123456st', 0907418036)",
//     (err, res) => {
//         try {
//             if (err) throw err;
//             console.log("One row inserted!");
//             client.end;
//         }
//         catch(err){
            
//             if(err.constraint=='profile_pkey') console.log('Invalid');
//             else {
//                 console.log(err);
//             }
//             client.end;
//         }
//     }
// );


