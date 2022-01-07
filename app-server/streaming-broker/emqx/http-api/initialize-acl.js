const { emqx_http } = require('./http-client.js');
const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname}/../../../common/emqx.json`));

emqx_http.post('api/v4/acl', [
    {
        topic: `#`,
        action: `pubsub`,
        access: `deny`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/up/raw`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["DB_CONNECTOR_CLIENT_ID"]}`,
        topic: `devices/+/up/payload`,
        action: `sub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["DB_CONNECTOR_CLIENT_ID"]}`,
        topic: `devices/+/up/mixed`,
        action: `sub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["PREPROCESSOR_CLIENT_ID"]}`,
        topic: `devices/+/up/raw`,
        action: `sub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["PREPROCESSOR_CLIENT_ID"]}`,
        topic: `devices/+/up/mixed`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["PREPROCESSOR_CLIENT_ID"]}`,
        topic: `devices/+/up/payload`,
        action: `pub`,
        access: `allow`
    }
])
.then((res) => {
    console.log(res);
})
.catch((err) => {
    console.log(err);
});
