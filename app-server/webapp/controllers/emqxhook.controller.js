const common_emqx = JSON.parse(fs.readFileSync(`${__dirname}/../common/emqx.json`));
const emqx_http = require(`${__dirname}/../../streaming-broker/emqx/http-api/http-api.js`);

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

        if (req.body.action == 'session_terminated')
        {
            if (req.body.clientid.slice(0, 3) == 'uid') {
                let acl_list = await get_acl_list_one_clientid(req.body.clientid, 1000);

                //extract distinct topic from acl_list
                let unique_topics_list = [...Set(acl_list.data.data.map((acl) => {
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
