const mqtt = require('mqtt');
const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname  }/../../../common/emqx.json`));

const streaming_broker_options = {
    clientId: common_emqx["PREPROCESSOR_CLIENT_ID"],
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
    'PAYLOAD': common_emqx['TOPIC_LEVEL_PAYLOAD'],
    'MIXED': common_emqx['TOPIC_LEVEL_MIXED']
};

//get raw topic of all devices
const sub_topics = [
    {
        'topic': `${dev_topic_levels['DEVICES']}/+/${dev_topic_levels['UP']}/raw`,
        'options': {
            'qos': 0
        }
    }
];

/* ==============MESSAGE EXTRACTORS============== */
function extract_dev_data(json_pkg) {
    /*
    extract metadata + payload data
    parameter: JSON
    return: JSON
    */
    let metadata_json_pkg = {
        "dev_identifiers" : {
            "dev_id" : json_pkg["end_device_ids"]["device_id"],
            "dev_eui" : json_pkg["end_device_ids"]["dev_eui"],
            "dev_addr" : json_pkg["end_device_ids"]["dev_addr"],
            "join_eui" : json_pkg["end_device_ids"]["join_eui"]
        },

        "dev_version" : {
            "dev_type" : json_pkg["uplink_message"]["decoded_payload"]["dev_type"],
            "dev_brand" : json_pkg["uplink_message"]["version_ids"]["brand_id"],
            "dev_model" : json_pkg["uplink_message"]["version_ids"]["model_id"],
            "dev_band" : json_pkg["uplink_message"]["version_ids"]["band_id"]
        }
    };

    delete json_pkg["uplink_message"]["decoded_payload"]["dev_type"];

    let payload_json_pkg = {
        "recv_timestamp" : json_pkg["received_at"],
        "payload_data" : json_pkg["uplink_message"]["decoded_payload"]
    };

    let dev_data = {
        'metadata': metadata_json_pkg,
        'payload': payload_json_pkg
    };
    return dev_data;
}

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

//EXTRACT
function streaming_broker_message_handler(topic, message, packet)
{
    //parse msg
    let parsed_message = JSON.parse(message);
    //extract
    let dev_data = extract_dev_data(parsed_message);

    let pub_topics = [
        {
            //for db cache
            'topic': `${dev_topic_levels['DEVICES']}/${parsed_message['end_device_ids']['device_id']}/${dev_topic_levels['UP']}/${dev_topic_levels['MIXED']}`,
            'msg': JSON.stringify(dev_data),
            'options': {
                qos: 0,
                dup: false,
                retain: false,
                /*
                properties: {
                    messageExpiryInterval: 300
                }
                */
            }
        },

        {
            //for customer
            'topic': `${dev_topic_levels['DEVICES']}/${parsed_message['end_device_ids']['device_id']}/${dev_topic_levels['UP']}/${dev_topic_levels['PAYLOAD']}`,
            'msg': JSON.stringify(dev_data["payload"]),
            'options': {
                qos: 2,
                dup: false,
                retain: true,
                /*
                properties: {
                    messageExpiryInterval: 300
                }
                */
            }
        }
    ];

    //publish extracted data to 2 different topics
    try {
        pub_topics.forEach((topic) => {
            streaming_broker_mqttclient.publish(topic['topic'], topic['msg'], topic['options']);
        });
    } catch (err) {
        console.log(err);
    }
}

// handle error
function streaming_broker_error_handler(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}