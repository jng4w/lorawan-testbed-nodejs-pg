process.title = "auth";

/* ============================= */

const mqtt = require('mqtt');
const { Pool } = require('pg');
const fs = require('fs');
const emqx_http = require(`${__dirname}/../emqx/http-api/http-api.js`);

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname  }/../../common/emqx.json`));
const common_pg = JSON.parse(fs.readFileSync(`${__dirname  }/../../common/pg.json`));

const db_pool = new Pool({
    user: common_pg["POSTGRES_USER"],
    password: common_pg["POSTGRES_PASSWORD"],
    host: common_pg["SERVER_ADDR"],
    port: common_pg["SERVER_PORT"],
    database: common_pg["DATABASE_NAME"]
})

const streaming_broker_options = {
    clientId: common_emqx["AUTH_CLIENT_ID"],
    username: common_emqx["SYSTEM_USERNAME"],
    password: common_emqx["SYSTEM_PASSWORD"],
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

const sub_topics = [
    {
        'topic': `$SYS/brokers/+/clients/+/disconnected`,
        'options': {
            'qos': 0
        }
    }
];

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

function streaming_broker_message_handler(topic, message, packet)
{
    //parse msg
    let parsed_message = JSON.parse(message);
    //is enduser?
    if (parsed_message['username'] == common_emqx['ENDUSER_USERNAME']) {
        let client_info = parsed_message['clientid'].split('-');
        db_pool.query(
            `SELECT dev_id 
            FROM public."ENDDEV"
            WHERE _id IN (SELECT enddev_id
                        FROM public."OWN"
                        WHERE profile_id = $1)
            `,
            [
                client_info[1]
            ]
        )
        .then((result) => {
            let dev_list = [];
                result.rows.forEach((item)=>{
                dev_list.push(item.dev_id);
            });
            emqx_http.del_client_acl_on_dev_topic(parsed_message['clientid'], dev_list);
        })
        .catch((err) => {
            console.log(err);
        });
    }
    
}

// handle error
function streaming_broker_error_handler(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}