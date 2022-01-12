        // var payload_data = JSON.parse(window.localStorage.getItem('payload-data')) ;
            
            //     for(var i in payload_data){
            //         for(var j in payload_data[i]){
            //             document.getElementById(`payload-data-${i}-${j}`).innerHTML = payload_data[i][j];
            //         }
                    
            //     }
            
            const streaming_broker_protocol = "ws"; //pass from server
            const streaming_broker_addr = '<%= broker.addr %>'; //pass from server
            const streaming_broker_port = '<%= broker.port %>'; //pass from server

            //pass from server
            // const devices = [
            //     "eui-a84041a54182a79f"
            // ];
            const devices = '<%= dev_list %>'.split(",");
            console.log(devices);
            //pass from server
            const streaming_broker_options = {
                clientId: '<%= client_id %>',
                username: '<%= broker.id %>',
                password: '<%= broker.psw %>',
                keepalive: 120,
                protocolVersion: 5,
                clean: false,
                properties: {  // MQTT 5.0
                    sessionExpiryInterval: 300
                }
                // resubscribe: false
            }

            const sub_topics = [];
            devices.forEach((device_id) => {
                sub_topics.push({
                    'topic': `devices/${device_id}/up/payload`,
                    'options': {
                        'qos': 0
                    }
                });
            });
                
            const streaming_broker_mqttclient = mqtt.connect(
                `${streaming_broker_protocol}://${streaming_broker_addr}:${streaming_broker_port}/mqtt`, 
                streaming_broker_options
            );

            streaming_broker_mqttclient.on('connect', streaming_broker_connect_handler);
            streaming_broker_mqttclient.on('error', streaming_broker_error_handler);
            streaming_broker_mqttclient.on('message', streaming_broker_message_handler);
            
            //handle incoming connect
            function streaming_broker_connect_handler(connack)
            {
                console.log(`streaming broker connected? ${streaming_broker_mqttclient.connected}`);
                
                // if(connack.sessionPresent==false){
                sub_topics.forEach((topic) => {
                    streaming_broker_mqttclient.subscribe(topic['topic'], topic['options']);
                });
                // }
                
            }
            
            //MESSAGE SEND HERE
            function streaming_broker_message_handler(topic, message, packet)
            {
                //parse msg
                let parsed_message = JSON.parse(message);
                //CONTINUE
                //document.getElementById("payload-data-58").innerHTML = parsed_message;
                console.log(topic);
                console.log('parsed_message', parsed_message.payload_data);
                var recv_topic = topic.split('/')[1];
                // var data = `"${recv_topic}": ${parsed_message.payload_data}`;

                // var data = JSON.parse(window.localStorage.getItem('payload-data'));
                // if(!data) data = {};
                // data[recv_topic] = JSON.stringify(parsed_message.payload_data);
                // window.localStorage.setItem(`payload-data`, JSON.stringify(data));

                for(var i in parsed_message.payload_data){
                    
                    document.getElementById(`payload-data-${recv_topic}-${i}`).innerHTML = parsed_message.payload_data[i];
                }

                // parsed_message.payload_data.forEach((item) => {
                //     document.getElementById(`payload-data-${recv_topic[1]}-${item.key}`).innerHTML = item
                // })
                // parsed_message.recv_payload
            }

            // handle error
            function streaming_broker_error_handler(error)
            {
                console.log("Can't connect to streaming broker" + error);
                process.exit(1);
            }