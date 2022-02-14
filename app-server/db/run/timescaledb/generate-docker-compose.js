const fs = require('fs');

const common_pg = JSON.parse(fs.readFileSync(`${__dirname}/../../../common/pg.json`));

const content = 
`version: \'3.8\'

services:
 timescaledb:
  container_name: timescaledb_container
  image: timescale/timescaledb:latest-pg12
  restart: always
  environment:
   POSTGRES_USER: ${common_pg['POSTGRES_USER']}
   POSTGRES_PASSWORD: ${common_pg['POSTGRES_PASSWORD']}
  ports:
   - \"${common_pg['SERVER_PORT']}:${common_pg['SERVER_PORT']}\"
`;


try {
    fs.writeFileSync(`${__dirname}/docker-compose.yml`, content)
} catch (err) {
    console.error(err)
}

