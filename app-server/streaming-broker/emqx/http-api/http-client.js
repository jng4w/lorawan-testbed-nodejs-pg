const fs = require('fs');
const axios = require('axios');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname}/../../../common/emqx.json`));

const emqx_http = axios.create({
    baseURL: `http://${common_emqx['SERVER_ADDR']}:${common_emqx['HTTP_API_PORT']}/`,
    auth: {
        username: `${common_emqx['ADMIN_USERNAME']}`,
        password:`${common_emqx['ADMIN_PASSWORD']}`
      },
});

module.exports = {
    emqx_http
}