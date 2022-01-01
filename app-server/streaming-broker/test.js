const mqtt = require('mqtt');

const fs = require('fs');

const common = JSON.parse(fs.readFileSync('./../common.json'));

const streaming_broker_options = {
    clientId: "test",
    protocolVersion: 5,
    clean: false,
    properties: {
        sessionExpiryInterval: 120,
        receiveMaximum: 100
    }
}

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common['emqx']['SERVER_ADDR'];
const streaming_broker_port = common['emqx']['SERVER_PORT'];

//topics levels of streaming brokers
const dev_topic_levels = {
    'DEVICES': common['emqx']['TOPIC_LEVEL_DEVICES'],
    'UP': common['emqx']['TOPIC_LEVEL_UP'],
    'PAYLOAD': common['emqx']['TOPIC_LEVEL_PAYLOAD'],
    'MIXED': common['emqx']['TOPIC_LEVEL_MIXED']
};

//get raw topic of all devices
const sub_topics = [
    `${dev_topic_levels['DEVICES']}/eui-a84041a54182a79f/${dev_topic_levels['UP']}/payload`
];

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
    streaming_broker_mqttclient.subscribe(sub_topics, {
        'qos': 2
    });
    
}

//EXTRACT
function streaming_broker_message_handler(topic, message, packet)
{
    //parse msg
    let parsed_message = JSON.parse(message);
    console.log(topic);
    console.log(parsed_message);
}

// handle error
function streaming_broker_error_handler(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}