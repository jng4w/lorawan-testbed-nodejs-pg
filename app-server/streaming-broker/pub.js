const mqtt = require('mqtt');

mqtt_options={
    clientId:"puber",
    username: 'bz7AaQzqSnfWeicreBQz',
    password: 'YuBnmreoWUUtZK5j1o1w',
    keepalive: 120,
    protocolVersion: 5,
    clean: false,
    properties: {  // MQTT 5.0
        sessionExpiryInterval: 300,
        receiveMaximum: 100
    }
};

mqttclient = mqtt.connect("mqtt://127.0.0.1:1883", mqtt_options)

var i = 0;
function pub()
{
    mqttclient.publish( "devices/up",`{"val":"${i}"}`, {
        qos: 0,
        dup: false,
        retain: true,
        /*
        properties: {
            messageExpiryInterval: 300
        } 
        */ 
    }, (err) => {
        console.log(err);
    });

    console.log(i);
    i++;   
}

setInterval(pub, 5000);

//handle incoming connect
function mqtt_connect_handler()
{
    console.log("connected  " + mqttclient.connected)
}

mqttclient.on('connect', mqtt_connect_handler);

//handle incoming message
function mqtt_message_handler(topic, message, packet)
{
    console.log("topic: " + topic)
    console.log("message: " + message)
    console.log("packet: " + packet)

    //ADD TO DATABASE
    //DO HERE
}

mqttclient.on('message', mqtt_message_handler);

//handle error
function mqtt_error_handler(error)
{
    console.log("Can't connect" + error);
    process.exit(1);
}

mqttclient.on('error', mqtt_error_handler);

mqttclient.on('disconnect', (packet) => {
    console.log(packet);
});

mqttclient.on('close', () => {
    console.log('close');
});