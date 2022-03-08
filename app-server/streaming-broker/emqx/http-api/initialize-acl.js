const { emqx_http } = require('./http-client.js');
const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname}/../../../common/emqx.json`));

emqx_http.post('api/v4/acl', [
    /* ALL */
    {
        topic: `#`,
        action: `pubsub`,
        access: `deny`
    },

    /* DB CONNECTOR */
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

    /* PREPROCESSOR */
    {
        clientid: `${common_emqx["PREPROCESSOR_CLIENT_ID"]}`,
        topic: `devices/+/up/raw`,
        action: `sub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["PREPROCESSOR_CLIENT_ID"]}`,
        topic: `devices/+/join`,
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
    },
    {
        clientid: `${common_emqx["PREPROCESSOR_CLIENT_ID"]}`,
        topic: `devices/+/down/push`,
        action: `pub`,
        access: `allow`
    },

    /* TTS BRIDGE */
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/up/raw`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/join`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/down/ack`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/down/nack`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/down/sent`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/down/failed`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/down/queued`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/location/solved`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/service/data`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/down/push`,
        action: `sub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_BRIDGE_CLIENT_ID"]}`,
        topic: `devices/+/down/replace`,
        action: `sub`,
        access: `allow`
    },

    /* TTS CLIENT */
    /*
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/up`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/join`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/down/ack`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/down/nack`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/down/sent`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/down/failed`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/down/queued`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/location/solved`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/service/data`,
        action: `pub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/down/push`,
        action: `sub`,
        access: `allow`
    },
    {
        clientid: `${common_emqx["TTS_CLIENT_CLIENT_ID"]}`,
        topic: `devices/all/down/replace`,
        action: `sub`,
        access: `allow`
    },
    */
])
.then((res) => {
    console.log(res);
})
.catch((err) => {
    console.log(err);
});

emqx_http.post('api/v4/auth_username', [
    {
        username: common_emqx['ENDUSER_USERNAME'],
        password: common_emqx['ENDUSER_PASSWORD'],
    },

    {
        username: common_emqx['SYSTEM_USERNAME'],
        password: common_emqx['SYSTEM_PASSWORD'],
    },
])
.then((res) => {
    console.log(res);
})
.catch((err) => {
    console.log(err);
});
