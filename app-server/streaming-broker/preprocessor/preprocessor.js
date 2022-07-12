process.title = "preprocessor";

/* ============================= */

const mqtt = require('mqtt');
const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname  }/../../common/emqx.json`));

const streaming_broker_options = {
    clientId: common_emqx["PREPROCESSOR_CLIENT_ID"],
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

//get raw topic of all devices
const sub_topics = [
    {
        'topic': `devices/+/up/raw`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `devices/+/join`,
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
            "dev_type" : json_pkg["uplink_message"]["decoded_payload"]["meta"]["dev_type"],
            "dev_brand" : json_pkg["uplink_message"]["version_ids"]["brand_id"],
            "dev_model" : json_pkg["uplink_message"]["version_ids"]["model_id"],
            "dev_band" : json_pkg["uplink_message"]["version_ids"]["band_id"]
        }
    };

    let payload_json_pkg = {
        "recv_timestamp" : json_pkg["received_at"],
        "payload_data" : json_pkg["uplink_message"]["decoded_payload"]["data"]
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
    try {
        console.log(`streaming broker connected? ${streaming_broker_mqttclient.connected}`);
        if (connack.sessionPresent == false) {
            sub_topics.forEach((topic) => {
                streaming_broker_mqttclient.subscribe(topic['topic'], topic['options']);
            });
        }
    } catch (err) {
         console.log(err);
    }
}

function streaming_broker_message_handler(topic, message, packet)
{   
    try {
        let topic_levels = topic.split('/');

        //EXTRACT UPLINK
        if (topic == `devices/${topic_levels[1]}/up/raw`) {
            //parse msg
            let parsed_message = JSON.parse(message);
            
            if (!parsed_message.uplink_message.hasOwnProperty("decoded_payload")) return;

            //extract
            let dev_data = extract_dev_data(parsed_message);
            
            let pub_topics = [
                {
                    //for db cache
                    'topic': `devices/${topic_levels[1]}/up/mixed`,
                    'msg': JSON.stringify(dev_data),
                    'options': {
                        qos: 0,
                        dup: false,
                        retain: false
                    }
                },
        
                {
                    //for customer
                    'topic': `devices/${topic_levels[1]}/up/payload`,
                    'msg': JSON.stringify(dev_data["payload"]),
                    'options': {
                        qos: 0,
                        dup: false,
                        retain: true
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

        //INITIAL CONFIG DEV VIA DOWNLINK WHEN DEV JOINING
        else if (topic == `devices/${topic_levels[1]}/join`) {
            let join_msg = JSON.parse(message);
            if (topic_levels[1] == "eui-a8404111e1832b1c") {
                let downlink_payload = 
                {
                    "downlinks": [
                        {
                            "f_port": 1,
                            "frm_payload": "AwEA",
                            "priority": "HIGHEST",
                            "confirmed": true
                        }
                    ]
                };
            
                let pub_topics = [
                    {
                        'topic': `devices/${topic_levels[1]}/down/push`,
                        'msg': JSON.stringify(downlink_payload),
                        'options': {
                            qos: 0,
                            dup: false,
                            retain: false
                        }
                    }
                ];
            
                try {
                    pub_topics.forEach((topic) => {
                        streaming_broker_mqttclient.publish(topic['topic'], topic['msg'], topic['options']);
                    });
                } catch (err) {
                    console.log(err);
                }
            }
        }

    } catch (err) {
        console.log(err);
    }
}

// handle error
function streaming_broker_error_handler(error)
{
    try {
        console.log("Can't connect to streaming broker" + error);
        process.exit(1);
    } catch (err) {
        console.log(err);
    }
}