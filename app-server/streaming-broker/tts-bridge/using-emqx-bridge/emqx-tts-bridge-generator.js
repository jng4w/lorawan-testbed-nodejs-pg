const fs = require('fs');

const common_tts = JSON.parse(fs.readFileSync('./../../../common/tts.json'));

const content = 
`##--------------------------------------------------------------------
## Bridges to tts
##--------------------------------------------------------------------
bridge.mqtt.tts.address = ${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']}
bridge.mqtt.tts.proto_ver = mqttv4
bridge.mqtt.tts.clientid = bridge_tts
bridge.mqtt.tts.bridge_mode = false
bridge.mqtt.tts.start_type = manual
bridge.mqtt.tts.username = ${common_tts['API_KEY_USERNAME']}
bridge.mqtt.tts.password = ${common_tts['API_KEY_PASSWORD']}
bridge.mqtt.tts.keepalive = 60s
bridge.mqtt.tts.clean_start = true
bridge.mqtt.tts.reconnect_interval = 30s
bridge.mqtt.tts.ssl = off
bridge.mqtt.tts.retry_interval = 20s
bridge.mqtt.tts.max_inflight_size = 32
bridge.mqtt.tts.subscription.1.topic = v3/${common_tts['API_KEY_USERNAME']}/devices/+/up
bridge.mqtt.tts.subscription.1.qos = 1
bridge.mqtt.tts.queue.max_total_size = 5GB
bridge.mqtt.tts.queue.replayq_dir = data/tts_bridge/
bridge.mqtt.tts.queue.replayq_seg_bytes = 10MB
`;


try {
    fs.writeFileSync('./emqx_bridge_mqtt.conf', content)
} catch (err) {
    console.error(err)
}