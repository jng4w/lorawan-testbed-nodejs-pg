const mqtt = require('mqtt');
const fs = require('fs');

const common = JSON.parse(fs.readFileSync('./../../../common.json'));

const streaming_broker_options = {
    clientId: "db-connector",
    clean: true
}

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common['emqx']['SERVER_ADDR'];
const streaming_broker_port = common['emqx']['SERVER_PORT'];

//topics levels of streaming brokers
const dev_topic_levels = {
    'DEVICES': common['emqx']['TOPIC_LEVEL_DEVICES'],
    'UP': common['emqx']['TOPIC_LEVEL_UP'],
    'MIXED': common['emqx']['TOPIC_LEVEL_MIXED']
};

//get topics of all devices
const sub_topics = [
    `${dev_topic_levels['DEVICES']}/+/${dev_topic_levels['UP']}/${dev_topic_levels['MIXED']}`
];

/* ==============CONNECT TO STREAMING BROKER============== */
const streaming_broker_mqttclient = mqtt.connect(
    `${streaming_broker_protocol}://${streaming_broker_addr}:${streaming_broker_port}`, 
    streaming_broker_options
);

streaming_broker_mqttclient.on('connect', streaming_broker_connect_handler);
streaming_broker_mqttclient.on('error', streaming_broker_error_handler);
streaming_broker_mqttclient.on('message', streaming_broker_message_handler);

//handle incoming connect
function streaming_broker_connect_handler()
{
    console.log(`streaming broker connected? ${streaming_broker_mqttclient.connected}`);
    streaming_broker_mqttclient.subscribe(sub_topics);
    
}

//STORE TO DB
async function streaming_broker_message_handler(topic, message, packet)
{
    const parsed_message = JSON.parse(message);
    try {
        //insert enddev payload
        await db_pool.query(
            "INSERT INTO public.\"ENDDEV_PAYLOAD\" (recv_timestamp, payload_data, enddev_id)\
            VALUES ($1, $2, (SELECT _id FROM public.\"ENDDEV\" WHERE dev_id = $3) )",
            [
                parsed_message['payload']['recv_timestamp'],
                parsed_message['payload']['payload_data'],
                parsed_message['metadata']['dev_identifiers']['dev_id']
            ]
        );
    }
    catch (err) {
        //console.log(err.stack);
        //if insert payload failed -> not exist enddev, then insert enddev
        let res = await db_pool.query(
            "INSERT INTO public.\"ENDDEV\" (display_name, dev_id, dev_addr, join_eui, dev_eui, dev_type, dev_brand, dev_model, dev_band)\
            VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9) RETURNING _id",
            [
                parsed_message['metadata']['dev_identifiers']['dev_id'],
                parsed_message['metadata']['dev_identifiers']['dev_id'],
                parsed_message['metadata']['dev_identifiers']['dev_addr'],
                parsed_message['metadata']['dev_identifiers']['join_eui'],
                parsed_message['metadata']['dev_identifiers']['dev_eui'],
                parsed_message['metadata']['dev_version']['dev_type'],
                parsed_message['metadata']['dev_version']['dev_brand'],
                parsed_message['metadata']['dev_version']['dev_model'],
                parsed_message['metadata']['dev_version']['dev_band']
            ]
        );
        //get enddev_id for later used
        const enddev_id = res.rows[0]['_id'];

        //insert sensor_key
        Object.keys(parsed_message['payload']['payload_data'])
        .forEach(async (sensor_key) => {
            await db_pool.query(
                "INSERT INTO public.\"SENSOR\" (sensor_key, enddev_id)\
                VALUES ($1, $2)",
                [sensor_key, enddev_id]
            );
        });

        //map appropriate unit to sensor

        //insert payload again
        await db_pool.query(
            "INSERT INTO public.\"ENDDEV_PAYLOAD\" (recv_timestamp, payload_data, enddev_id)\
            VALUES ($1, $2, (SELECT _id FROM public.\"ENDDEV\" WHERE dev_id = $3) )",
            [
                parsed_message['payload']['recv_timestamp'],
                parsed_message['payload']['payload_data'],
                parsed_message['metadata']['dev_identifiers']['dev_id']
            ]
        );
    }
}

// handle error
function streaming_broker_error_handler(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}

/* ==============CONNECT TO PG============== */
const {Pool} = require("pg");


const db_pool = new Pool({
    user: common["pg"]["POSTGRES_USER"],
    password: common["pg"]["POSTGRES_PASSWORD"],
    host: common["pg"]["SERVER_ADDR"],
    port: common["pg"]["SERVER_PORT"],
    database: common["pg"]["DATABASE_NAME"]
})

