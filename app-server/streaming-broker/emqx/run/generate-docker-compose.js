const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname}/../../../common/emqx.json`));

const content = 
`version: '3'

services:
  emqx1:
    image: emqx/emqx:4.4.0
    environment:
    - "EMQX_NAME=emqx"
    - "EMQX_HOST=127.0.0.1"
    - "EMQX_CLUSTER__DISCOVERY=static"
    - "EMQX_CLUSTER__STATIC__SEEDS=emqx@${common_emqx['SERVER_ADDR']}"
    networks:
      emqx-bridge:
        aliases:
        - ${common_emqx['SERVER_ADDR']}
    ports:
      - "${common_emqx['MQTT_PORT']}:${common_emqx['MQTT_PORT']}" 
      - "${common_emqx['HTTP_API_PORT']}:${common_emqx['HTTP_API_PORT']}" 
      - "${common_emqx['WEBSOCKET_PORT']}:${common_emqx['WEBSOCKET_PORT']}" 
      - "8883:8883" 
      - "8084:8084" 
      - "8080:8080" 
      - "11883:11883"
      - "18083:18083"
    volumes:
      - vol-emqx-data:/opt/emqx/data
      - vol-emqx-etc:/opt/emqx/etc
      - vol-emqx-log:/opt/emqx/log

networks:
  emqx-bridge:
    driver: bridge

volumes:
  vol-emqx-data:
    name: vol-emqx-data
  vol-emqx-etc:
    name: vol-emqx-etc
  vol-emqx-log:
    name: vol-emqx-log
`;


try {
    fs.writeFileSync(`${__dirname}/docker-compose.yml`, content)
} catch (err) {
    console.error(err)
}

