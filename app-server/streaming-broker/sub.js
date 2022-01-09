const mqtt = require('mqtt');

mqtt_options={
    clientId: 'suber',
    username: 'bz7AaQzqSnfWeicreBQz',
    password: 'YuBnmreoWUUtZK5j1o1w',
    keepalive: 120,
    protocolVersion: 5,
    clean: false,
    properties: {  // MQTT 5.0
        sessionExpiryInterval: 300,
        receiveMaximum: 100
    },
    resubsribe: false
};

mqtt_topics_list = [
    "devices/up"
]

mqttclient = mqtt.connect("mqtt://127.0.0.1:1883", mqtt_options)
mqttclient.subscribe(mqtt_topics_list, {
    qos: 0
});

//handle incoming connect
function mqtt_connect_handler()
{
    console.log("connected  " + mqttclient.connected)
}

mqttclient.on('connect', mqtt_connect_handler);

//handle incoming message
function mqtt_message_handler(topic, message, packet)
{
    console.log(topic);
    console.log("message: " + message);
}

mqttclient.on('message', mqtt_message_handler);

//handle error
function mqtt_error_handler(error)
{
    console.log("Can't connect" + error);
    process.exit(1);
}

mqttclient.on('error', mqtt_error_handler);