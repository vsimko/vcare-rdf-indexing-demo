#!/usr/bin/env node

const mqtt = require('mqtt')
//const client = mqtt.connect('mqtt://test.mosquitto.org/')
const client = mqtt.connect('mqtt://localhost:1883/')
const axios = require('axios')
const url = "http://localhost:4000"

client.on('message', async (topicname, message) => {
    const jsonmsg = JSON.parse(message.toString())
    console.log(`got mqtt message from topic: ${topicname}`)

    const data = {
        "query": `mutation {solrInsert(topic:"${topicname}",data:"${jsonmsg.rndnum}\")}`
    }

    await axios.post(url, data)
    console.log("sent:" + JSON.stringify(data))
})

client.on('connect', function () {
    console.log("connected to mqtt, now sending messages")

    client.subscribe('vcare')
    console.log("subscribed to topic")
})

