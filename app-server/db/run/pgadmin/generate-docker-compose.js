const fs = require('fs');

const common_pgadmin = JSON.parse(fs.readFileSync(`${__dirname}/../../../common/pgadmin.json`));

const content = 
`version: \'3.8\'

services:
 pgadmin:
  container_name: pgadmin4
  image: dpage/pgadmin4
  restart: always
  environment:
   PGADMIN_DEFAULT_EMAIL: ${common_pgadmin['PGADMIN_DEFAULT_EMAIL']}
   PGADMIN_DEFAULT_PASSWORD: ${common_pgadmin['PGADMIN_DEFAULT_PASSWORD']}
   PGADMIN_LISTEN_ADDRESS: ${common_pgadmin['SERVER_ADDR']}
   PGADMIN_LISTEN_PORT: ${common_pgadmin['SERVER_PORT']}
  ports:
   - \"${common_pgadmin['SERVER_PORT']}:${common_pgadmin['SERVER_PORT']}\"
`;


try {
    fs.writeFileSync(`${__dirname}/docker-compose.yml`, content)
} catch (err) {
    console.error(err)
}

