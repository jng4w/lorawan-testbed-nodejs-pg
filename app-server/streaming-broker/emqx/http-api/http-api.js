const { emqx_http } = require('./http-client.js');

function add_client_acl_on_dev_topic(client_id, dev_list) {
    const acl_batch = [];
    dev_list.forEach((dev_id) => {
        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/up/payload`,
            action: `sub`,
            access: `allow`
        });
        
        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/join`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/down/ack`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/down/nack`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/down/failed`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/down/queued`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/down/sent`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/service/data`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/location/solved`,
            action: `sub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/down/push`,
            action: `pub`,
            access: `allow`
        });

        acl_batch.push({
            clientid: `${client_id}`,
            topic: `devices/${dev_id}/down/replace`,
            action: `pub`,
            access: `allow`
        });
    });
    // console.log('acl_batch ', acl_batch);
    return emqx_http.post('api/v4/acl', acl_batch)
        .then((res) => {
            return res;
        })  
        .catch((err) => {
            return err;
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
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/join`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/down/ack`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/down/nack`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/down/failed`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/down/queued`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/down/push`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/service/data`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });

        await emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(client_id)}/topic/${encodeURIComponent(`devices/${dev_id}/location/solved`)}`)
        .then((res) => {
            console.log(res);
        })
        .catch((err) => {
            console.log(err);
        });
    });
}

function kick_client(client_id) {
    return emqx_http.delete(`/api/v4/clients/${encodeURIComponent(client_id)}`)
    .then((res) => {
        return res;
    })
    .catch((err) => {
        return err;
    })
}

function get_client_list_with_username(username, limit) {
    return emqx_http.get(`api/v4/clients/username/${encodeURIComponent(username)}/?_page=1&_limit=${encodeURIComponent(limit)}`)
    .then((res) => {
        return res;
    })
    .catch((err) => {
        return err;
    })
}

function get_acl_list_all_clientid(limit) {
    return emqx_http.get(`/api/v4/acl/clientid/?_page=1&_limit=${encodeURIComponent(limit)}`)
    .then((res) => {
        return res;
    })
    .catch((err) => {
        return err;
    })
}

function delete_acl_clientid_on_topic(clientid, topic) {
    return emqx_http.delete(`api/v4/acl/clientid/${encodeURIComponent(clientid)}/topic/${encodeURIComponent(topic)}`)
    .then((res) => {
        return res;
    })
    .catch((err) => {
        return err;
    })
}

function get_acl_list_one_clientid(clientid, limit) {
    return emqx_http.get(`/api/v4/acl/clientid/${clientid}?_page=1&_limit=${encodeURIComponent(limit)}`)
    .then((res) => {
        return res;
    })
    .catch((err) => {
        return err;
    })
}

module.exports = {
    add_client_acl_on_dev_topic,
    del_client_acl_on_dev_topic,
    kick_client,
    get_client_list_with_username,
    get_acl_list_all_clientid,
    get_acl_list_one_clientid,
    delete_acl_clientid_on_topic
}


