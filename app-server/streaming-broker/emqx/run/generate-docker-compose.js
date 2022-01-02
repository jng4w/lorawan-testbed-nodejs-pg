const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync('./../../../common/emqx.json'));

const content = 
`version: \'3\'

services:
  emqx1:
    image: emqx/emqx:latest
    environment:
    - \"EMQX_NAME=emqx\"
    - \"EMQX_HOST=${common_emqx['SERVER_ADDR']}\"
    - \"EMQX_CLUSTER__DISCOVERY=static\"
    - \"EMQX_CLUSTER__STATIC__SEEDS=emqx@${common_emqx['SERVER_ADDR']}\"
    networks:
      emqx-bridge:
        aliases:
        - ${common_emqx['SERVER_ADDR']}
    ports:
      - \"${common_emqx['MQTT_PORT']}:${common_emqx['MQTT_PORT']}\" 
      - \"8081:8081\" 
      - \"8083:8083\" 
      - \"8883:8883\" 
      - \"8084:8084\" 
      - \"18083:18083\"
      - \"6369:6369\"
      - \"6370:6370\"
      - \"11883:11883\"

networks:
  emqx-bridge:
    driver: bridge
`;


try {
    fs.writeFileSync('./docker-compose.yml', content)
} catch (err) {
    console.error(err)
}

