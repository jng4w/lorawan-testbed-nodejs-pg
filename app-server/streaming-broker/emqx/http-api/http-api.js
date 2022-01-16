const { emqx_http } = require('./http-client.js');

async function add_client_acl_on_dev_topic(client_id, dev_list) {
    const acl_batch = [];
    dev_list.forEach((dev_id) => {
        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/up/payload`,
            action: `sub`,
            access: `allow`
        });
    });
    // console.log('acl_batch ', acl_batch);
    await emqx_http.post('api/v4/acl', acl_batch)
        .then((res) => {
            //console.log(res);
        })  
        .catch((err) => {
            // console.log(err);
        });
}

async function del_client_acl_on_dev_topic(client_id, dev_list) {
    await dev_list.forEach(async (dev_id) => {
        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/up/payload`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        })
    });
}

async function kick_client(client_id) {
    await emqx_http.delete(`/api/v4/clients/${encodeURIComponent(client_id)}`)
    .then((res) => {
        console.log(res);
    })
    .catch((err) => {
        console.log(err);
    })
}

module.exports = {
    add_client_acl_on_dev_topic,
    del_client_acl_on_dev_topic,
    kick_client
}


