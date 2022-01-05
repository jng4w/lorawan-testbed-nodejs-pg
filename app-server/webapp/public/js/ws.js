mqtt_client = mqtt.connect("ws://" + mqtt_server_ip + ":" + mqtt_server_port.toString() + "/mqtt", options);
devices.forEach(device => mqtt_topics_list.push(mqtt_topic_prefix + device + "/up/payload"));
mqtt_client.subscribe(mqtt_topics_list);
mqtt_client.on('connect', mqtt_connect_handler);
mqtt_client.on('message', mqtt_message_handler);
mqtt_client.on('error', mqtt_error_handler);