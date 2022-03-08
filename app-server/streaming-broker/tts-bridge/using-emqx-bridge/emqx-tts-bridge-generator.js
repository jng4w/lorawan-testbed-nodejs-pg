const fs = require('fs');

const common_tts = JSON.parse(fs.readFileSync(`${__dirname}/../../../common/tts.json`));

let content = 
`##--------------------------------------------------------------------
## Bridges to tts
##--------------------------------------------------------------------
bridge.mqtt.tts.address = ${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['AS_MQTT']}
bridge.mqtt.tts.proto_ver = mqttv3
bridge.mqtt.tts.clientid = tts-bridge
bridge.mqtt.tts.bridge_mode = false
bridge.mqtt.tts.start_type = manual
bridge.mqtt.tts.username = ${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}
bridge.mqtt.tts.password = ${common_tts['API_KEY_PASSWORD']}
bridge.mqtt.tts.keepalive = 60s
bridge.mqtt.tts.clean_start = true
bridge.mqtt.tts.reconnect_interval = 30s
bridge.mqtt.tts.ssl = off
bridge.mqtt.tts.retry_interval = 20s
bridge.mqtt.tts.max_inflight_size = 32

bridge.mqtt.tts.subscription.1.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/up
bridge.mqtt.tts.subscription.1.qos = 0
bridge.mqtt.tts.subscription.2.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/join
bridge.mqtt.tts.subscription.2.qos = 0
bridge.mqtt.tts.subscription.3.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/queued
bridge.mqtt.tts.subscription.3.qos = 0
bridge.mqtt.tts.subscription.4.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/sent
bridge.mqtt.tts.subscription.4.qos = 0
bridge.mqtt.tts.subscription.5.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/ack
bridge.mqtt.tts.subscription.5.qos = 0
bridge.mqtt.tts.subscription.6.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/nack
bridge.mqtt.tts.subscription.6.qos = 0
bridge.mqtt.tts.subscription.7.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/failed
bridge.mqtt.tts.subscription.7.qos = 0
bridge.mqtt.tts.subscription.8.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/service/data
bridge.mqtt.tts.subscription.8.qos = 0
bridge.mqtt.tts.subscription.9.topic = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/location/solved
bridge.mqtt.tts.subscription.9.qos = 0

bridge.mqtt.tts.forwards = v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/push,v3/${common_tts['APPLICATION_ID']}@${common_tts['TENANT_ID']}/devices/+/down/replace

bridge.mqtt.tts.queue.max_total_size = 5GB
bridge.mqtt.tts.queue.replayq_dir = data/tts-bridge/
bridge.mqtt.tts.queue.replayq_seg_bytes = 10MB
`;

if (process.argv[2] == `tts-os`) {
    content = 
`##--------------------------------------------------------------------
## Bridges to tts
##--------------------------------------------------------------------
bridge.mqtt.tts.address = ${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['AS_MQTT']}
bridge.mqtt.tts.proto_ver = mqttv3
bridge.mqtt.tts.clientid = tts-bridge
bridge.mqtt.tts.bridge_mode = false
bridge.mqtt.tts.start_type = manual
bridge.mqtt.tts.username = ${common_tts['APPLICATION_ID']}
bridge.mqtt.tts.password = ${common_tts['API_KEY_PASSWORD']}
bridge.mqtt.tts.keepalive = 60s
bridge.mqtt.tts.clean_start = true
bridge.mqtt.tts.reconnect_interval = 30s
bridge.mqtt.tts.ssl = off
bridge.mqtt.tts.retry_interval = 20s
bridge.mqtt.tts.max_inflight_size = 32

bridge.mqtt.tts.subscription.1.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/up
bridge.mqtt.tts.subscription.1.qos = 0
bridge.mqtt.tts.subscription.2.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/join
bridge.mqtt.tts.subscription.2.qos = 0
bridge.mqtt.tts.subscription.3.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/down/queued
bridge.mqtt.tts.subscription.3.qos = 0
bridge.mqtt.tts.subscription.4.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/down/sent
bridge.mqtt.tts.subscription.4.qos = 0
bridge.mqtt.tts.subscription.5.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/down/ack
bridge.mqtt.tts.subscription.5.qos = 0
bridge.mqtt.tts.subscription.6.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/down/nack
bridge.mqtt.tts.subscription.6.qos = 0
bridge.mqtt.tts.subscription.7.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/down/failed
bridge.mqtt.tts.subscription.7.qos = 0
bridge.mqtt.tts.subscription.8.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/service/data
bridge.mqtt.tts.subscription.8.qos = 0
bridge.mqtt.tts.subscription.9.topic = v3/${common_tts['APPLICATION_ID']}/devices/+/location/solved
bridge.mqtt.tts.subscription.9.qos = 0

bridge.mqtt.tts.forwards = v3/${common_tts['APPLICATION_ID']}/devices/+/down/push,v3/${common_tts['APPLICATION_ID']}/devices/+/down/replace

bridge.mqtt.tts.queue.max_total_size = 5GB
bridge.mqtt.tts.queue.replayq_dir = data/tts-bridge/
bridge.mqtt.tts.queue.replayq_seg_bytes = 10MB
`;
}

try {
    fs.writeFileSync(`${__dirname}/emqx_bridge_mqtt.conf`, content)
} catch (err) {
    console.error(err)
}