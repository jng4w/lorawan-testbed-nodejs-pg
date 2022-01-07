const http = require('http');

/*
let data = "";
let req = http.request({
    'method': 'GET',
    'hostname': 'localhost',
    'port': 8081,
    'path': "/api/v4/acl/$all",
    'auth': 'admin:public'
}, (response) => {
    console.log('STATUS: ' + response.statusCode);
        console.log('HEADERS: ' + JSON.stringify(response.headers));
        response.setEncoding('utf8');
        response.on('data', function (chunk) {
            data += chunk;
            console.log(data);
        });
});

req.end();
*/

/*
const data = JSON.stringify({
    "clientid": "test",
    "topic":"devices/ss/up",
    "action":"pubsub",
    "access": "deny"
  });

let req = http.request({
    'method': 'POST',
    'hostname': 'localhost',
    'port': 8081,
    'path': "/api/v4/acl",
    'auth': 'admin:public'
}, (response) => {
    console.log(`statusCode: ${response.statusCode}`);
});

req.write(data);
req.end();
*/


let data = "";
let req = http.request({
    'method': 'DELETE',
    'hostname': 'localhost',
    'port': 8081,
    'path': `/api/v4/acl/clientid/test/topic/${encodeURIComponent('devices/ss/up')}`,
    'auth': 'admin:public'
}, (response) => {
    console.log('STATUS: ' + response.statusCode);
        console.log('HEADERS: ' + JSON.stringify(response.headers));
        response.setEncoding('utf8');
        response.on('data', function (chunk) {
            data += chunk;
            console.log(data);
        });
});
req.end();
