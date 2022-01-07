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

async function checkProfileExist(email_or_phone, password){

    const res = await client.query(
        `SELECT _id, display_name, phone_number, email, type FROM public."PROFILE" WHERE (email=$1 OR phone_number = $1) AND password = crypt($2,password)`,
        [email_or_phone, password]
    );
    return res;
}

async function checkProfileExistRegister(email, phone, password){

    const res = await client.query(
        `SELECT _id, display_name, phone_number, email, type FROM public."PROFILE" WHERE (email=$1 OR phone_number = $2) AND password = crypt($3,password)`,
        [email, phone, password]
    );
    return res;
}

async function insertProfile(email, phone, password, type, name){

    const res = await client.query(
        `CALL public.insert_profile($1, $2, $3, $4, $5)`,
        [email, phone, password, type, name]
    );
    return res;
}

// async function selectDeviceFromCustomer(id){

//     const res = await client.query(
//         `select dev_id, count(*) as no_sensor
//         from
//         public."OWN" as O, public."ENDDEV" as E, public."SENSOR" as S
//         where
//         O.enddev_id = E._id and
//         E._id = S.enddev_id and
//         O.profile_id = $1
//         group by
//         profile_id, dev_id;
//         `,
//         [id]
//     );
//     return res;
// }

async function selectDeviceSensorFromCustomer(id){

    const res = await client.query(
        `select dev_id, array_agg(sensor_key) as sensor_key_arr
        from
        public."OWN" as O, public."ENDDEV" as E, public."SENSOR" as S
        where
        O.enddev_id = E._id and
        E._id = S.enddev_id and
        O.profile_id = $1
        group by
        dev_id;    
        `,
        [id]
    );
    return res;
}

async function selectBoardWidgetFromCustomer(id){

    const res = await client.query(
        `select *
        from
        public."BOARD" as B, public."WIDGET" as W, public."BELONG_TO" as BT, public."SENSOR" as S
        where
        B._id = W.board_id and
        W._id = BT.widget_id and
        BT.sensor_id = S._id and
		B.profile_id = $1;  
        `,
        [id]
    );
    return res;
}


async function insertDeviceToCustomer(email, phone, password){

    const res = await client.query(
        `SELECT _id, display_name, phone_number, email, type FROM public."PROFILE" WHERE (email=$1 OR phone_number = $2) AND password = crypt($3,password)`,
        [email, phone, password]
    );
    return res;
}

module.exports = {
    checkProfileExist: checkProfileExist,
    checkProfileExistRegister: checkProfileExistRegister,
    insertProfile: insertProfile,
    // selectDeviceFromCustomer: selectDeviceFromCustomer,
    selectDeviceSensorFromCustomer: selectDeviceSensorFromCustomer,
    selectBoardWidgetFromCustomer: selectBoardWidgetFromCustomer
}