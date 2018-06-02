#!/usr/bin/env node

const blaze = require("blazegraph")({
    host: "localhost",
    port: 8889,
    namespace: "kb",
})

const solr = require("solr-client").createClient({
    host: "localhost",
    port: "8983",
    core: "knowledgegraph",
    solrVersion: "7.3",
})

async function pipeline() {
    const results = await blaze.querySparql(`
        prefix rdfs: <http://www.w3.org/2000/01/rdf-schema#>
        prefix demo: <http://vcare.eu/demonstrator#>
        select * {
            ?s a demo:State .
            ?s rdfs:label ?label .
        }
    `)

    const convertSingleResult = x => ({
        id: x.s.value,
        label: x.label.value
    })

    const docs = results.map(convertSingleResult)
    console.log(`Found ${docs.length} documents in Blazegraph`)

    solr.add(docs, (err, res) => {
        if (err)
            console.err(err)
        else {
            console.log(res)
            solr.commit()
        }
    })
}

pipeline()
