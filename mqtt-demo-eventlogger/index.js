#!/usr/bin/env node

const mqtt = require('mqtt')
//const client = mqtt.connect('mqtt://test.mosquitto.org/')
const client = mqtt.connect('mqtt://localhost:1883/')
const axios = require('axios')
const url = "http://localhost:4000"

client.on('message', (topicname, message) => {
    const jsonmsg = JSON.parse(message.toString())
    console.log(`got mqtt message from topic: ${topicname}`)
    let data = {"query":`mutation {solrInsert(topic:\"${topicname}\",data:\"${jsonmsg.rndnum}\")}`}

    axios.post(url, data)
.then((response) => {
        console.log(response)
    })
        .catch((error)=>{
            console.log(error)
        })
    const msg = JSON.stringify(jsonmsg)
    console.log(msg)
})


client.on('connect', function () {
    console.log("connected to mqtt, now sending messages")

    client.subscribe('vcare')
    console.log("subscribed to topic")
})

