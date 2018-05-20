#!/usr/bin/env node

const mqtt = require('mqtt')
const client = mqtt.connect('mqtt://test.mosquitto.org/')

client.on('message', (topic, message) => {
  const jsonmsg = JSON.parse(message.toString())
  console.log(`got mqtt message from topic: ${topic}`)
  // TODO: sent to solr thourgh timeline API (/insert) as HTTP POST request
  const msg = JSON.stringify(jsonmsg)
  console.log(msg)
})


client.on('connect', function () {
  console.log("connected to mqtt, now sending messages")

  client.subscribe('vcare')
  console.log("subscribed to topic")
})

