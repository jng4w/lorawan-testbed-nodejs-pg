process.title = "downlinktesting";

/* ============================= */

const mqtt = require('mqtt');
const fs = require('fs');

const common_tts = JSON.parse(fs.readFileSync(`${__dirname  }/../common/tts.json`));
const common_pg = JSON.parse(fs.readFileSync(`${__dirname  }/../common/pg.json`));

const streaming_broker_options = {
    clientId: common_tts["API_KEY_ID"],
    username: `${common_tts["APPLICATION_ID"]}@${common_tts["TENANT_ID"]}`,
    password: common_tts["API_KEY_PASSWORD"]
}

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common_tts['SERVER_ADDR'];
const streaming_broker_port = common_tts['SERVER_PORT']['AS_MQTT'];

//get topics of all devices
const sub_topics = [
    {
        'topic': `v3/bkiotlab-lorawtestbed@ttn/devices/+/up`,
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
            `INSERT INTO public."DOWNLINK_TESTING"(
                message)
                VALUES ($1)`,
            [
                parsed_message
            ]
        );
    } catch (err) {
        console.log(err.stack);
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
    user: common_pg["POSTGRES_USER"],
    password: common_pg["POSTGRES_PASSWORD"],
    host: common_pg["SERVER_ADDR"],
    port: common_pg["SERVER_PORT"],
    database: common_pg["DB_NAME"]["APP"]
})

