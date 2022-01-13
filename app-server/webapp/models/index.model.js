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

async function selectDeviceFromCustomer(id){

    const res = await client.query(
        `select dev_id
        public."OWN" as O, public."ENDDEV" as E
        where
        O.enddev_id = E._id and
        O.profile_id = $1
        group by
        dev_id;    
        `,
        [id]
    );
    return res;
}

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

async function selectBoardFromCustomer(id){

    const res = await client.query(
        `select B._id as key, B.display_name as value 
        from
        public."BOARD" as B
        where
		B.profile_id = $1;  
        `,
        [id]
    );
    return res;
}

async function selectBoardWidgetFromCustomer(id){

    const res = await client.query(
        `select E.dev_id as e_dev_id, W.display_name as w_display_name, B.display_name as b_display_name, *
        from
        public."BOARD" as B, public."WIDGET" as W, 
		public."BELONG_TO" as BT, public."SENSOR" as S, public."ENDDEV" as E
        where
        B._id = W.board_id and
        W._id = BT.widget_id and
        BT.sensor_id = S._id and
		E._id = S.enddev_id and
		B.profile_id = $1;  
        `,
        [id]
    );
    return res;
}

async function insertDeviceToCustomer(id, dev_id){

    const res = await client.query(
        `CALL public.insert_device_to_customer(
            $1, 
            $2
        );  
        `,
        [id, dev_id]
    );
    return res;
}

async function insertBoardToCustomer(id, board_name){
    console.log(id, board_name);
    const res = await client.query(
        `INSERT INTO public."BOARD"(
            display_name, profile_id)
           VALUES ( $2, $1);  
        `,
        [id, board_name]
    );
    return res;
}

async function selectWidgetType(id){
    if(id){
        const res = await client.query(
            `select *
            from
            public."WIDGET_TYPE" as WT
            where _id = $1;  
            `,
            [id]
        );
        return res;
    }
    else {
        const res = await client.query(
            `select *
            from
            public."WIDGET_TYPE" as WT;  
            `
        );
        return res;
    }
    
    
}

module.exports = {
    checkProfileExist: checkProfileExist,
    checkProfileExistRegister: checkProfileExistRegister,
    insertProfile: insertProfile,
    selectDeviceFromCustomer: selectDeviceFromCustomer,
    selectDeviceSensorFromCustomer: selectDeviceSensorFromCustomer,
    selectBoardFromCustomer: selectBoardFromCustomer,
    selectBoardWidgetFromCustomer: selectBoardWidgetFromCustomer,
    insertDeviceToCustomer: insertDeviceToCustomer,
    insertBoardToCustomer: insertBoardToCustomer,
    selectWidgetType: selectWidgetType
}