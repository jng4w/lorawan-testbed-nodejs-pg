const mqtt = require('mqtt');

const fs = require('fs');

const common = JSON.parse(fs.readFileSync('./../common/emqx.json'));

const streaming_broker1_options = {
    clientId: "test1",
    protocolVersion: 5,
    clean: false,
    properties: {
        sessionExpiryInterval: 120,
        receiveMaximum: 100
    }
}

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common['SERVER_ADDR'];
const streaming_broker_port = common['SERVER_PORT'];

//topics levels of streaming brokers
const dev_topic_levels = {
    'DEVICES': common['TOPIC_LEVEL_DEVICES'],
    'UP': common['TOPIC_LEVEL_UP'],
    'PAYLOAD': common['TOPIC_LEVEL_PAYLOAD'],
    'MIXED': common['TOPIC_LEVEL_MIXED']
};

//get raw topic of all devices
const sub_topics = [
    `${dev_topic_levels['DEVICES']}/eui-a84041a54182a79f/${dev_topic_levels['UP']}/payload`
];

const streaming_broker_mqttclient = mqtt.connect(
    `${streaming_broker_protocol}://${streaming_broker_addr}:${streaming_broker_port}`, 
    streaming_broker1_options
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

var intervalID = setInterval(myCallback, 500);

function myCallback(a, b)
{
 // Your code here
 // Parameters are purely optional.
 streaming_broker_mqttclient.publish(`${dev_topic_levels['DEVICES']}/eui-a84041a54182a79f/${dev_topic_levels['UP']}/payload`, "kaka");
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







/*
const streaming_broker2_options = {
    clientId: "test",
    protocolVersion: 5,
    clean: false,
    properties: {
        sessionExpiryInterval: 120,
        receiveMaximum: 100
    }
}

//get raw topic of all devices
const sub_topics2 = [
    `${dev_topic_levels['DEVICES']}/eui-a84041739182dd05/${dev_topic_levels['UP']}/payload`
];

const streaming_broker_mqttclient2 = mqtt.connect(
    `${streaming_broker_protocol}://${streaming_broker_addr}:${streaming_broker_port}`, 
    streaming_broker2_options
);

streaming_broker_mqttclient2.on('connect', streaming_broker_connect_handler2);
streaming_broker_mqttclient2.on('error', streaming_broker_error_handler2);
streaming_broker_mqttclient2.on('message', streaming_broker_message_handler2);

//handle incoming connect
function streaming_broker_connect_handler2()
{
    console.log(`streaming broker 2 connected? ${streaming_broker_mqttclient2.connected}`);
    streaming_broker_mqttclient2.subscribe(sub_topics2, {
        'qos': 2
    });
    
}

//EXTRACT
function streaming_broker_message_handler2(topic, message, packet)
{
    //parse msg
    let parsed_message = JSON.parse(message);
    console.log(topic);
    console.log(parsed_message);
}

// handle error
function streaming_broker_error_handler2(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}
*/
