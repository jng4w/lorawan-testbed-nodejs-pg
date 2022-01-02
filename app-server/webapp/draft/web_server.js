const express = require('express')
const app = express()
const port = 3000

const MongoClient = require('mongodb').MongoClient;
const assert = require('assert');

// Connection URL
const url = 'mongodb://localhost:27017';


// Database Name
const dbName = 'lora_wan';

// Create a new MongoClient
const client = new MongoClient(url);

app.set('views', './views')
app.set('view engine', 'ejs')

app.get('/sensor_data', (req,res) => {
  //let device_list = [{'name': 'asdasd'}, {'name': 'tmp36'}]
  const db = client.db(dbName);
  // Get the documents collection
  const collection = db.collection('sensor_data');
  collection.find({}).toArray(function(err, device_list) {
    //assert.strictEqual(err, null);
    res.render('sensor_data', {'sensor_data': device_list})
  });
})

// Use connect method to connect to the Server
client.connect(function(err) {
  //assert.strictEqual(null, err);
  console.log("Connected successfully to mongo database");

  app.listen(port, () => {
    console.log(`Example app listening at http://localhost:${port}`)
  })
});