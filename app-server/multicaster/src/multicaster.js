const mqtt = require('mqtt');
const fs = require('fs');

const common = JSON.parse(fs.readFileSync('./../../common.json'));

const network_server_mqtt_options = {
    clientId: common['tts']['API_KEY_ID'],
    username: common['tts']['API_KEY_USERNAME'],
    password: common['tts']['API_KEY_PASSWORD'],
    clean: true
};

const app_server_mqtt_options = {
    clientId: "multicaster",
    clean: true
}

const network_server_mqtt_protocol = "mqtt";
const network_server_mqtt_addr = common['tts']['SERVER_ADDR'];
const network_server_mqtt_port = 1883;

const app_server_mqtt_protocol = "mqtt";
const app_server_mqtt_addr = "127.0.0.1";
const app_server_mqtt_port = 1883;

//get uplink messages of all devices
const sub_mqtt_topic = "v3/bkiotlab-lorawtestbed@ttn/devices/+/up";

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
var network_server_mqttclient = mqtt.connect(
    network_server_mqtt_protocol + "://" + network_server_mqtt_addr + ":" + network_server_mqtt_port.toString(), 
    network_server_mqtt_options
);

network_server_mqttclient.on('connect',network_server_mqtt_connect_handler);
network_server_mqttclient.on('error',network_server_mqtt_error_handler);
network_server_mqttclient.on('message', network_server_mqtt_message_handler);


//handle incoming connect
function network_server_mqtt_connect_handler()
{
    console.log("network server mqtt connected? " + network_server_mqttclient.connected);
    network_server_mqttclient.subscribe(sub_mqtt_topic);
}

//handle incoming message
function network_server_mqtt_message_handler(topic, message, packet)
{
    //extract message into payload and metadata
    //forward to appropriate topics at app MQTT broker
    let parsed_message = JSON.parse(message);
    let dev_topics = {
        'metadata': 'devices/' + parsed_message['end_device_ids']['device_id'].toString() + '/up/metadata',
        'payload': 'devices/' + parsed_message['end_device_ids']['device_id'].toString() + '/up/payload'
    };
    
    let dev_data = extract_dev_data(parsed_message);
    //try..catch in case cannot connect to app server
    try {
        app_server_mqttclient.publish(dev_topics['metadata'], JSON.stringify(dev_data['metadata']));
        app_server_mqttclient.publish(dev_topics['payload'], JSON.stringify(dev_data['payload']));
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
var app_server_mqttclient = mqtt.connect(
    app_server_mqtt_protocol + "://" + app_server_mqtt_addr + ":" + app_server_mqtt_port.toString(), 
    app_server_mqtt_options
);

app_server_mqttclient.on('connect', app_server_mqtt_connect_handler);
app_server_mqttclient.on('error', app_server_mqtt_error_handler);
app_server_mqttclient.on('message', app_server_mqtt_message_handler);

//handle incoming connect
function app_server_mqtt_connect_handler()
{
    console.log("app server mqtt connected? " + app_server_mqttclient.connected);
    //app_server_mqttclient.subscribe(['devices/+/up/metadata', 'devices/+/up/payload']);
    
}

//handle incoming message
function app_server_mqtt_message_handler(topic, message, packet)
{
    //NOT BE USED YET
    console.log(topic);
    //console.log(message.toString());
}

// handle error
function app_server_mqtt_error_handler(error)
{
    console.log("Can't connect to app server" + error);
    process.exit(1);
}