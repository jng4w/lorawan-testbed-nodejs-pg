process.title = "tts-bridge";

/* ============================= */

const mqtt = require('mqtt');
const fs = require('fs');

const common_tts = JSON.parse(fs.readFileSync(`${__dirname  }/../../../common/tts.json`));
const common_emqx = JSON.parse(fs.readFileSync(`${__dirname  }/../../../common/emqx.json`));

const network_server_mqtt_options = {
    clientId: common_tts['API_KEY_ID'],
    username: `${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}`,
    password: common_tts['API_KEY_PASSWORD'],
    keepalive: 120,
    protocolVersion: 3,
    queueQoSZero: true,
    clean: false,
    resubscribe: false
};

const streaming_broker_options = {
    clientId: common_emqx["TTS_BRIDGE_CLIENT_ID"],
    username: common_emqx["SYSTEM_USERNAME"],
    password: common_emqx["SYSTEM_PASSWORD"],
    keepalive: 120,
    protocolVersion: 5,
    clean: false,
    properties: {  // MQTT 5.0
        sessionExpiryInterval: 300
    },
    resubscribe: false
}

const network_server_mqtt_protocol = "mqtt";
const network_server_mqtt_addr = common_tts['SERVER_ADDR'];
const network_server_mqtt_port = common_tts['SERVER_PORT'];

const streaming_broker_protocol = "mqtt";
const streaming_broker_addr = common_emqx['SERVER_ADDR'];
const streaming_broker_port = common_emqx['SERVER_PORT'];

//get uplink messages of all  from TTS
const tts_sub_topics = [
    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/up`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/join`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/queued`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/sent`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/ack`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/nack`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/failed`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/service/data`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/location/solved`,
        'options': {
            'qos': 0
        }
    }
];

//sub topic emqx
const emqx_sub_topics = [
    {
        'topic': `devices/+/down/push`,
        'options': {
            'qos': 0
        }
    },

    {
        'topic': `devices/+/down/replace`,
        'options': {
            'qos': 0
        }
    }
]

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
        tts_sub_topics.forEach((topic) => {
            network_server_mqttclient.subscribe(topic['topic'], topic['options']);
        });
    }
}

//FORWARD UPLINK
function network_server_mqtt_message_handler(topic, message, packet)
{
    //split topic
    let topic_levels = topic.split('/');

    if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/up`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/up`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/join`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/join`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/down/sent`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/down/sent`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/down/ack`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/down/ack`, message, {
                qos: 0,
                dup: false,
                retain: true
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/down/nack`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/down/nack`, message, {
                qos: 0,
                dup: false,
                retain: true
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/down/queued`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/down/queued`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/down/failed`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/down/failed`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/service/data`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/service/data`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[4]}/location/solved`) {
        //try..catch in case cannot connect to app server
        try {
            streaming_broker_mqttclient.publish(`devices/${topic_levels[4]}/location/solved`, message, {
                qos: 0,
                dup: false,
                retain: true
            });
        } catch (err) {
            console.log(err);
        }
    }

    else {
        console.log('out of topic');
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
        emqx_sub_topics.forEach((topic) => {
            streaming_broker_mqttclient.subscribe(topic['topic'], topic['options']);
        });
    }
}

//CONTROL DOWNLINK
function streaming_broker_message_handler(topic, message, packet)
{
    //split topic
    let topic_levels = topic.split('/');
  
    if (topic == `devices/${topic_levels[1]}/down/push`) {
        //try..catch in case cannot connect to app server
        try {
            network_server_mqttclient.publish(`v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[1]}/down/push`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else if (topic == `devices/${topic_levels[1]}/down/replace`) {
        //try..catch in case cannot connect to app server
        try {
            network_server_mqttclient.publish(`v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/${topic_levels[1]}/down/replace`, message, {
                qos: 0,
                dup: false,
                retain: false
            });
        } catch (err) {
            console.log(err);
        }
    }

    else {
        console.log('out of topic');
    }
}

// handle error
function streaming_broker_error_handler(error)
{
    console.log("Can't connect to streaming broker" + error);
    process.exit(1);
}