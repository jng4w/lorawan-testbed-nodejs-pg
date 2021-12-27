const mqtt = require('mqtt');
const fs = require('fs');

const common = JSON.parse(fs.readFileSync('./../../common.json'));

const network_server_mqtt_options = {
    clientId: common['tts']['API_KEY_ID'],
    username: common['tts']['API_KEY_USERNAME'],
    password: common['tts']['API_KEY_PASSWORD'],
    clean: true
};

const streaming_broker_options = {
    clientId: "multicaster",
    clean: true
}

const network_server_mqtt_protocol = "mqtt";
const network_server_mqtt_addr = common['tts']['SERVER_ADDR'];
const network_server_mqtt_port = common['tts']['SERVER_PORT'];

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common['emqx']['SERVER_ADDR'];
const streaming_broker_port = common['emqx']['SERVER_PORT'];

//get uplink messages of all devices
const sub_mqtt_topic = `v3/${common['tts']['APPLICATION_ID']}@ttn/devices/+/up`;

//topics levels of streaming brokers
const dev_topic_levels = {
    'DEVICES': common['emqx']['TOPIC_LEVEL_DEVICES'],
    'UP': common['emqx']['TOPIC_LEVEL_UP'],
    'METADATA': common['emqx']['TOPIC_LEVEL_METADATA'],
    'PAYLOAD': common['emqx']['TOPIC_LEVEL_PAYLOAD']
};


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
            "dev_type" : null,
            "dev_brand" : json_pkg["uplink_message"]["version_ids"]["brand_id"],
            "dev_model" : json_pkg["uplink_message"]["version_ids"]["model_id"],
            "dev_band" : json_pkg["uplink_message"]["version_ids"]["band_id"]
        }
    };

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

/* ==============CONNECT TO NETWORK SERVER============== */
const network_server_mqttclient = mqtt.connect(
    `${network_server_mqtt_protocol}://${network_server_mqtt_addr}:${network_server_mqtt_port}`, 
    network_server_mqtt_options
);

network_server_mqttclient.on('connect',network_server_mqtt_connect_handler);
network_server_mqttclient.on('error',network_server_mqtt_error_handler);
network_server_mqttclient.on('message', network_server_mqtt_message_handler);


//handle incoming connect
function network_server_mqtt_connect_handler()
{
    console.log(`network server mqtt connected? ${network_server_mqttclient.connected}`);
    network_server_mqttclient.subscribe(sub_mqtt_topic);
}

//CONTROL UPLINK
function network_server_mqtt_message_handler(topic, message, packet)
{
    /*
    extract message into payload and metadata
    forward to appropriate topics at app MQTT broker
    */

    //parse msg
    let parsed_message = JSON.parse(message);
    //extract
    let dev_data = extract_dev_data(parsed_message);
    //publish
    let dev_topics = {
        'metadata': `${dev_topic_levels['DEVICES']}/${parsed_message['end_device_ids']['device_id']}/${dev_topic_levels['UP']}/${dev_topic_levels['METADATA']}`,
        'payload': `${dev_topic_levels['DEVICES']}/${parsed_message['end_device_ids']['device_id']}/${dev_topic_levels['UP']}/${dev_topic_levels['PAYLOAD']}`
    };

    //try..catch in case cannot connect to app server
    try {
        streaming_broker_mqttclient.publish(dev_topics['metadata'], JSON.stringify(dev_data['metadata']));
        streaming_broker_mqttclient.publish(dev_topics['payload'], JSON.stringify(dev_data['payload']));
    } catch (err) {
        console.log(err);
    }
}

// handle error
function network_server_mqtt_error_handler(error)
{
    console.log("Can't connect to network server" + error);
    process.exit(1);
}

/* ==============CONNECT TO APP SERVER (STREAMING BROKER)============== */
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
    
}

//CONTROL DOWNLINK
function streaming_broker_message_handler(topic, message, packet)
{
    //NOT BE USED YET
}

// handle error
function streaming_broker_error_handler(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}