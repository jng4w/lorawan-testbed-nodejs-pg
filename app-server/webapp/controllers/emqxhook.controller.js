const fs = require('fs');

const common_emqx = JSON.parse(fs.readFileSync(`${__dirname}/../../common/emqx.json`));
const emqx_http = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`);

const hook_action =  {
    SESSION_TERMINATED: 'session_terminated'
}

const LIST_LIMIT = 1000;

exports.hookProcessing = async (req, res, next) => {
    try {
        if (!req.body.hasOwnProperty('node')) {
            res.status(400).end();
            return;
        }

        else if (req.body.node != `emqx@${common_emqx['SERVER_ADDR']}`) {
            res.status(400).end();
            return;
        }

        if (req.body.action == hook_action['SESSION_TERMINATED'])
        {
            if (req.body.username == common_emqx['ENDUSER_USERNAME']) {
                let acl_list = await emqx_http.get_acl_list_one_clientid(req.body.clientid, LIST_LIMIT);

                //extract distinct topic from acl_list
                let unique_topics_list = [...new Set(acl_list.data.data.map((acl) => {
                    return acl.topic;
                }))]; //return a datatype array [<topic1>, <topic2>]
    
                unique_topics_list.forEach(async (topic) => {
                    await emqx_http.delete_acl_clientid_on_topic(req.body.clientid, topic);
                });
    
                res.status(200).end();
            }
        }
    } catch (err) {
        console.log(err);
    }
}
