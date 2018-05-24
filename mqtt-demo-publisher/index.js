#!/usr/bin/env node

const mqtt = require('mqtt')

//const client  = mqtt.connect('mqtt://test.mosquitto.org/')
const client  = mqtt.connect('mqtt://localhost:1883/') // our docker instance

client.on('connect', function () {

	const INTERVAL = 1000
	const TOPIC = "vcare"

  console.log("connected to mqtt, now sending messages")

  setInterval(() => {

    const msg = JSON.stringify({
      rndnum: Math.floor(Math.random() * 100)
    })

    console.log("sending message: " + msg)
    client.publish(TOPIC, msg, {retain: true})
  }, INTERVAL)

})
