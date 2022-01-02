const mqtt = require('mqtt');
const fs = require('fs');

const common = JSON.parse(fs.readFileSync('./../../../common.json'));

const network_server_mqtt_options = {
    clientId: common['tts']['API_KEY_ID'],
    username: `${common['tts']['APPLICATION_ID']}@${common['tts']['TENANT_ID']}`,
    password: common['tts']['API_KEY_PASSWORD'],
    keepalive: 120,
    protocolVersion: 3,
    queueQoSZero: true,
    clean: false,
    resubscribe: false
};

const streaming_broker_options = {
    clientId: "tts-bridge",
    keepalive: 120,
    protocolVersion: 5,
    clean: false,
    properties: {  // MQTT 5.0
        sessionExpiryInterval: 300
    },
    resubscribe: false
}

const network_server_mqtt_protocol = "mqtt";
const network_server_mqtt_addr = common['tts']['SERVER_ADDR'];
const network_server_mqtt_port = common['tts']['SERVER_PORT'];

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common['emqx']['SERVER_ADDR'];
const streaming_broker_port = common['emqx']['SERVER_PORT'];

//get uplink messages of all devices
const sub_topics = [
    {
        'topic': `v3/${common['tts']['APPLICATION_ID']}@${common['tts']['TENANT_ID']}/devices/+/up`,
        'options': {
            'qos': 0
        }
    }
];

//topics levels of streaming brokers
const dev_topic_levels = {
    'DEVICES': common['emqx']['TOPIC_LEVEL_DEVICES'],
    'UP': common['emqx']['TOPIC_LEVEL_UP']
};

/* ==============CONNECT TO NETWORK SERVER============== */
const network_server_mqttclient = mqtt.connect(
    `${network_server_mqtt_protocol}://${network_server_mqtt_addr}:${network_server_mqtt_port}`, 
    network_server_mqtt_options
);

network_server_mqttclient.on('connect',network_server_mqtt_connect_handler);
network_server_mqttclient.on('error',network_server_mqtt_error_handler);
network_server_mqttclient.on('message', network_server_mqtt_message_handler);


//handle incoming connect
function network_server_mqtt_connect_handler(connack)
{
    console.log(`network server mqtt connected? ${network_server_mqttclient.connected}`);
    if (connack.sessionPresent == false) {
        sub_topics.forEach((topic) => {
            network_server_mqttclient.subscribe(topic['topic'], topic['options']);
        });
    }
}

//FORWARD UPLINK
function network_server_mqtt_message_handler(topic, message, packet)
{
    //parse msg
    let parsed_message = JSON.parse(message);
    //publish
    let pub_topic = `${dev_topic_levels['DEVICES']}/${parsed_message['end_device_ids']['device_id']}/${dev_topic_levels['UP']}/raw`;
    //try..catch in case cannot connect to app server
    try {
        streaming_broker_mqttclient.publish(pub_topic, message, {
            qos: 0,
            dup: false,
            retain: false,
            /*
            properties: {
                messageExpiryInterval: 300
            }
            */
        });
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
function streaming_broker_connect_handler(connack)
{
    console.log(`streaming broker connected? ${streaming_broker_mqttclient.connected}`);
    if (connack.sessionPresent == false) {
        //subscribe
    }
    
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