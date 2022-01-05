var mqtt_server_ip = "127.0.0.1";
var mqtt_server_port = 8083;
var client_id = "enduser-1";

const devices = [
    "eui-a84041a54182a79f"
];
var mqtt_topic_prefix = "devices/";
var mqtt_topics_list = [];
options = {
    clientId: "enduser-1",
    clean: true
}

//handle incoming message
function mqtt_message_handler(topic, message, packet)
{
    var data = JSON.parse(message).payload_data;
    // console.log(Object.keys(data));

    for(var k in data) {
        // console.log(k, data[k]);
        document.getElementById(k).innerHTML = data[k];
     }
    
}

//handle incoming connect
function mqtt_connect_handler()
{
    console.log("user mqtt connected  " + mqtt_client.connected);
}

//handle error
function mqtt_error_handler()
{
    console.log("Can't connect to broker" + error);
}
