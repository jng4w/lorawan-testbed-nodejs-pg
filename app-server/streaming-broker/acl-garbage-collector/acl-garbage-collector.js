process.title = "acl-garbage-collector";

/* ============================= */
const fs = require('fs');
const emqx_http = require(`${__dirname}/../emqx/http-api/http-api.js`);
const common_emqx = JSON.parse(fs.readFileSync(`${__dirname  }/../../common/emqx.json`));

const PERIOD = 10000; //ms
const LIST_LIMIT = 2000;
let i = 0;
async function collect_garbage() {
    try {
        //get client list currently have session and ACL list
        let client_list = await emqx_http.get_client_list_with_username(common_emqx['ENDUSER_USERNAME'], LIST_LIMIT);
        let acl_list = await emqx_http.get_acl_list_all_clientid(LIST_LIMIT);

        //extract client list into clientid array
        let clientid_list = client_list.data.data.map((client) => {
            return client.clientid;
        }); //[<clientid1>, <clientid2>]

        //fiter garbage acl by client that do not currently have session and are end-user
        let garbage_acl_list = acl_list.data.data.filter((acl) => {
            return !clientid_list.includes(acl.clientid) && (acl.clientid.slice(0, 3) == 'uid');
        });

        garbage_acl_list.forEach(async (acl) => {
            await emqx_http.delete_acl_clientid_on_topic(acl.clientid, acl.topic);
        });
	i = i + 1;
	console.log(`${i * LIST_LIMIT} have been deleted`);
    } catch (err) {
        console.log(err);
    }
}
  
setInterval(collect_garbage, PERIOD);
