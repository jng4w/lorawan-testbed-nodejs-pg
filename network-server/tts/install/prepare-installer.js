const fs = require('fs');

const common_tts = JSON.parse(fs.readFileSync(`${__dirname}/../../../app-server/common/tts.json`));
const common_pg = JSON.parse(fs.readFileSync(`${__dirname}/../../../app-server/common/pg.json`));

const content = {}

/* generate docker-compose.yml */
content.compose = 
`version: '3.7'
services:

  # If using CockroachDB:
  #cockroach:
  #  # In production, replace 'latest' with tag from https://hub.docker.com/r/cockroachdb/cockroach/tags
  #  image: cockroachdb/cockroach:latest
  #  command: start-single-node --http-port 26256 --insecure
  #  restart: unless-stopped
  #  volumes:
  #    - \${DEV_DATA_DIR:-.env/data}/cockroach:/cockroach/cockroach-data
  #  ports:
  #    - "127.0.0.1:26257:26257" # Cockroach
  #    - "127.0.0.1:26256:26256" # WebUI

  # If using PostgreSQL:
  # postgres:
  #   image: postgres
  #   restart: unless-stopped
  #   environment:
  #     - POSTGRES_PASSWORD=root
  #     - POSTGRES_USER=root
  #     - POSTGRES_DB=ttn_lorawan
  #   volumes:
  #     - \${DEV_DATA_DIR:-.env/data}/postgres:/var/lib/postgresql/data
  #   ports:
  #     - "127.0.0.1:5432:5432"

  redis:
    # In production, replace 'latest' with tag from https://hub.docker.com/_/redis?tab=tags
    image: redis:7.0-rc1-bullseye
    command: redis-server --appendonly yes
    restart: unless-stopped
    volumes:
      - \${DEV_DATA_DIR:-.env/data}/redis:/data
    ports:
      - "127.0.0.1:6379:6379"

  stack:
    # In production, replace 'latest' with tag from https://hub.docker.com/r/thethingsnetwork/lorawan-stack/tags
    image: thethingsnetwork/lorawan-stack:3.17.2
    entrypoint: ttn-lw-stack -c /config/ttn-lw-stack-docker.yml
    command: start
    restart: unless-stopped
    depends_on:
      - redis
      # If using CockroachDB:
      # - cockroach
      # If using PostgreSQL:
      # - postgres
    volumes:
      - ./blob:/srv/ttn-lorawan/public/blob
      - ./config/stack:/config:ro
      # If using Let's Encrypt:
      #- ./acme:/var/lib/acme
    environment:
      TTN_LW_BLOB_LOCAL_DIRECTORY: /srv/ttn-lorawan/public/blob
      TTN_LW_REDIS_ADDRESS: redis:6379
      # If using CockroachDB:
      #TTN_LW_IS_DATABASE_URI: postgres://root@cockroach:26257/ttn_lorawan?sslmode=disable
      # # If using PostgreSQL:
      TTN_LW_IS_DATABASE_URI: postgres://${common_pg['POSTGRES_USER']}:${common_pg['POSTGRES_PASSWORD']}@${common_pg['SERVER_ADDR']}:${common_pg['SERVER_PORT']}/${common_pg['DB_NAME']['TTS']}?sslmode=disable

    ports:
      # If deploying on a public server:
      - "${common_tts['SERVER_PORT']['HTTP']}:1885"
      - "${common_tts['SERVER_PORT']['HTTPS']}:8885"
      - "${common_tts['SERVER_PORT']['GS_MQTT_V2']}:1881"
      - "${common_tts['SERVER_PORT']['GS_MQTTS_V2']}:8881"
      - "${common_tts['SERVER_PORT']['GS_MQTT']}:1882"
      - "${common_tts['SERVER_PORT']['GS_MQTTS']}:8882"
      - "${common_tts['SERVER_PORT']['AS_MQTT']}:1883"
      - "${common_tts['SERVER_PORT']['AS_MQTTS']}:8883"
      - "21884:1884"
      - "28884:8884"
      - "${common_tts['SERVER_PORT']['AS_WEBHOOK']}:1885"
      - "${common_tts['SERVER_PORT']['AS_WEBHOOKS']}:8885"
      - "${common_tts['SERVER_PORT']['GCS_LNS']}:1887"
      - "${common_tts['SERVER_PORT']['GCS_LNSS']}:8887"
      - "${common_tts['SERVER_PORT']['SEMTECH_UDP']}:1700/udp"

    # If using custom certificates:
    # secrets:
    #   - ca.pem
    #   - cert.pem
    #   - key.pem

# If using custom certificates:
# secrets:
#   ca.pem:
#     file: ./ca.pem
#   cert.pem:
#     file: ./cert.pem
#   key.pem:
#     file: ./key.pem
`;


try {
    fs.writeFileSync(`${__dirname}/docker-compose.yml`, content.compose)
} catch (err) {
    console.error(err)
}



/* generate ttn-lw-stack-docker.yml */
content.config = 
`# Identity Server configuration
# Email configuration for "${common_tts['SERVER_ADDR']}"
is:
  email:
    sender-name: 'The Things Stack'
    sender-address: 'noreply@${common_tts['SERVER_ADDR']}'
    network:
      name: 'The Things Stack'
      console-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/console'
      identity-server-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth'

    # If sending email with Sendgrid
    # provider: sendgrid
    # sendgrid:
    #   api-key: '...'              # enter Sendgrid API key

    # If sending email with SMTP
    # provider: smtp
    # smtp:
    #   address:  '...'             # enter SMTP server address
    #   username: '...'             # enter SMTP server username
    #   password: '...'             # enter SMTP server password

  # Web UI configuration for "${common_tts['SERVER_ADDR']}":
  oauth:
    ui:
      canonical-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth'
      is:
        base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'

# HTTP server configuration
http:
  cookie:
    block-key: 'a321a09ae5c1f605b34689044d9a7077d7050895cb2b2ff7fc0825a85aaa0e21'                # generate 32 bytes (openssl rand -hex 32)
    hash-key: '81b65891ca64162bbc413c7dcc8e61ef09c015676c36dda202ad402f13bc0d4bd037d2fb8dfb45cabac2d407e6c5643e12870caecbc4da8aa0755ef52dba8905'                 # generate 64 bytes (openssl rand -hex 64)
  metrics:
    password: 'metrics'               # choose a password
  pprof:
    password: 'pprof'                 # choose a password

# If using custom certificates:
# tls:
#   source: file
#   root-ca: /run/secrets/ca.pem
#   certificate: /run/secrets/cert.pem
#   key: /run/secrets/key.pem

# Let's encrypt for "${common_tts['SERVER_ADDR']}"
tls:
  source: 'acme'
  acme:
    dir: '/var/lib/acme'
    email: 'you@${common_tts['SERVER_ADDR']}'
    hosts: ['${common_tts['SERVER_ADDR']}']
    default-host: '${common_tts['SERVER_ADDR']}'

# If Gateway Server enabled, defaults for "${common_tts['SERVER_ADDR']}":
gs:
  mqtt:
    public-address: '${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['GS_MQTT']}'
    public-tls-address: '${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['GS_MQTTS']}'
  mqtt-v2:
    public-address: '${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['GS_MQTT_V2']}'
    public-tls-address: '${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['GS_MQTTS_V2']}'

# If Gateway Configuration Server enabled, defaults for "${common_tts['SERVER_ADDR']}":
gcs:
  basic-station:
    default:
      lns-uri: 'wss://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['GCS_LNSS']}'
  the-things-gateway:
    default:
      mqtt-server: 'mqtts://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['GS_MQTTS_V2']}'

# Web UI configuration for "${common_tts['SERVER_ADDR']}":
console:
  ui:
    canonical-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/console'
    is:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    gs:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    gcs:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    ns:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    as:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    js:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    qrg:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    edtc:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'

  oauth:
    authorize-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth/authorize'
    token-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth/token'
    logout-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth/logout'
    client-id: '${common_tts['CLIENT']['CONSOLE']['ID']}'
    client-secret: '${common_tts['CLIENT']['CONSOLE']['SECRET']}'          # choose or generate a secret

# If Application Server enabled, defaults for "${common_tts['SERVER_ADDR']}":
as:
  mqtt:
    public-address: '${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['AS_MQTT']}'
    public-tls-address: '${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['AS_MQTTS']}'
  webhooks:
    downlink:
      public-address: '${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['AS_WEBHOOK']}/api/v3'

# If Device Claiming Server enabled, defaults for "${common_tts['SERVER_ADDR']}":
dcs:
  oauth:
    authorize-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth/authorize'
    token-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth/token'
    logout-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/oauth/logout'
    client-id: 'device-claiming'
    client-secret: 'device-claiming'          # choose or generate a secret
  ui:
    canonical-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/claim'
    as:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    dcs:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    is:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'
    ns:
      base-url: 'http://${common_tts['SERVER_ADDR']}:${common_tts['SERVER_PORT']['HTTP']}/api/v3'

`;


try {
    fs.writeFileSync(`${__dirname}/config/stack/ttn-lw-stack-docker.yml`, content.config)
} catch (err) {
    console.error(err)
}




/* generate install.sh */
content.install = 
`sudo docker-compose pull
sudo docker-compose run --rm stack is-db init
sudo docker-compose run --rm stack is-db create-admin-user --id ${common_tts['ADMIN_USER']['ID']} --email ${common_tts['ADMIN_USER']['EMAIL']}
sudo docker-compose run --rm stack is-db create-oauth-client --id ${common_tts['CLIENT']['CLI']['ID']} --name "${common_tts['CLIENT']['CLI']['NAME']}" --owner ${common_tts['ADMIN_USER']['ID']} --no-secret --redirect-uri "local-callback" --redirect-uri "code"
sudo docker-compose run --rm stack is-db create-oauth-client --id ${common_tts['CLIENT']['CONSOLE']['ID']} --name "${common_tts['CLIENT']['CONSOLE']['NAME']}" --owner ${common_tts['ADMIN_USER']['ID']} --secret "${common_tts['CLIENT']['CONSOLE']['SECRET']}" --redirect-uri "${common_tts['SERVER_ADDR']}/console/oauth/callback" --redirect-uri "/console/oauth/callback" --logout-redirect-uri "${common_tts['SERVER_ADDR']}/console" --logout-redirect-uri "/console"
`;


try {
    fs.writeFileSync(`${__dirname}/install.sh`, content.install)
} catch (err) {
    console.error(err)
}


