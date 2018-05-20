#!/usr/bin/env node

const mqtt = require('mqtt')
const client  = mqtt.connect('mqtt://test.mosquitto.org/')

client.on('connect', function () {

  console.log("connected to mqtt, now sending messages")

  setInterval(() => {

    const msg = JSON.stringify({
      rndnum: Math.floor(Math.random() * 100)
    })

    console.log("sending message: " + msg)
    client.publish('vcare', msg, {retain: true})
  }, 1000)

})
