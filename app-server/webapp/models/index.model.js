const { Pool } = require('pg')
const fs = require('fs');


const common = JSON.parse(fs.readFileSync('./../common/pg.json'));

const client = new Pool({
  user: common["POSTGRES_USER"],
  host: common["SERVER_ADDR"],
  database: common["DATABASE_NAME"],
  password: common["POSTGRES_PASSWORD"],
  port: common["SERVER_PORT"]
})

client.connect(function(err) {
    try {
        if (err) throw err;
        console.log("Successfully connect to postgreSQL!");  
        
        // app.listen(port, () => {
        //     console.log(`Example app listening at http://localhost:${port}`)
        // })
    }
    catch(err){
        console.log(err);
        client.end;
    }
});

function checkProfileExist(){
    let message = '';
    const query = {
        // give the query a unique name
        text: `select * from profile where _id = $1 or email = '$2';`,
        values: [username, email],
    }

    client.query(
        query,
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

function customerAdd(username, email){

    const query = {
        // give the query a unique name
        text: `select * from profile where _id = $1 or email = '$2';`,
        values: [username, email],
    }

    client.query(
        query,
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

function retriveData(){
    const query = {
        // give the query a unique name
        text: `select * from profile where _id = $1 or email = '$2';`,
        values: [username, email],
    }

    client.query(
        query,
        (err, db_res) => {
            console.log(err);
        }
    );
}
module.exports = {
    customerAdd
}