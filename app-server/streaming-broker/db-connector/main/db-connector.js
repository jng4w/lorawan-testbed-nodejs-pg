const mqtt = require('mqtt');
const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname  }/../../../common/emqx.json`));
const common_pg = JSON.parse(fs.readFileSync(`${__dirname  }/../../../common/pg.json`));

const streaming_broker_options = {
    clientId: common_emqx["DB_CONNECTOR_CLIENT_ID"],
    keepalive: 120,
    protocolVersion: 5,
    clean: false,
    properties: {  // MQTT 5.0
        sessionExpiryInterval: 300,
        //receiveMaximum: 100
    },
    resubscribe: false
}

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common_emqx['SERVER_ADDR'];
const streaming_broker_port = common_emqx['SERVER_PORT'];

//topics levels of streaming brokers
const dev_topic_levels = {
    'DEVICES': common_emqx['TOPIC_LEVEL_DEVICES'],
    'UP': common_emqx['TOPIC_LEVEL_UP'],
    'MIXED': common_emqx['TOPIC_LEVEL_MIXED']
};

//get topics of all devices
const sub_topics = [
    {
        'topic': `${dev_topic_levels['DEVICES']}/+/${dev_topic_levels['UP']}/${dev_topic_levels['MIXED']}`,
        'options': {
            'qos': 0
        }
    }
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
function streaming_broker_connect_handler(connack)
{
    console.log(`streaming broker connected? ${streaming_broker_mqttclient.connected}`);
    if (connack.sessionPresent == false) {
        sub_topics.forEach((topic) => {
            streaming_broker_mqttclient.subscribe(topic['topic'], topic['options']);
        });
    }
}

//STORE TO DB
async function streaming_broker_message_handler(topic, message, packet)
{
    const parsed_message = JSON.parse(message);

    try {
        await db_pool.query(
            "CALL public.process_new_payload($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)",
            [
                parsed_message['payload']['recv_timestamp'],
                parsed_message['payload']['payload_data'],
                parsed_message['metadata']['dev_identifiers']['dev_id'],
                parsed_message['metadata']['dev_identifiers']['dev_eui'],
                parsed_message['metadata']['dev_identifiers']['dev_addr'],
                parsed_message['metadata']['dev_identifiers']['join_eui'],
                parsed_message['metadata']['dev_version']['dev_type'],
                parsed_message['metadata']['dev_version']['dev_brand'],
                parsed_message['metadata']['dev_version']['dev_model'],
                parsed_message['metadata']['dev_version']['dev_band']
            ]
        );
    } catch (err) {
        console.log(err.stack);
    }

    /*
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
    */
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
    user: common_pg["POSTGRES_USER"],
    password: common_pg["POSTGRES_PASSWORD"],
    host: common_pg["SERVER_ADDR"],
    port: common_pg["SERVER_PORT"],
    database: common_pg["DATABASE_NAME"]
})

