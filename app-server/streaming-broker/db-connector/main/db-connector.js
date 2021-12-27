const mqtt = require('mqtt');
const fs = require('fs');

const common = JSON.parse(fs.readFileSync('./../../../common.json'));

const streaming_broker_options = {
    clientId: "db-connector",
    clean: true
}

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common['emqx']['SERVER_ADDR'];
const streaming_broker_port = common['emqx']['SERVER_PORT'];

//topics levels of streaming brokers
const dev_topic_levels = {
    'DEVICES': common['emqx']['TOPIC_LEVEL_DEVICES'],
    'UP': common['emqx']['TOPIC_LEVEL_UP'],
    'METADATA': common['emqx']['TOPIC_LEVEL_METADATA'],
    'PAYLOAD': common['emqx']['TOPIC_LEVEL_PAYLOAD']
};

//get topics of all devices
const dev_topics = {
    'metadata': `${dev_topic_levels['DEVICES']}/+/${dev_topic_levels['UP']}/${dev_topic_levels['METADATA']}`,
    'payload': `${dev_topic_levels['DEVICES']}/+/${dev_topic_levels['UP']}/${dev_topic_levels['PAYLOAD']}`
};

/* ==============CONNECT TO STREAMING BROKER============== */
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
    streaming_broker_mqttclient.subscribe(Object.values(dev_topics));
    
}

//STORE TO DB
function streaming_broker_message_handler(topic, message, packet)
{
    console.log(topic);
    console.log(message.toString());
}

// handle error
function streaming_broker_error_handler(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}