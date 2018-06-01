const url = require("url")
const axios = require("axios")

module.exports = async (parent, args) => {
    const solrQueryUrl = url.format({
        protocol: "http",
        hostname: "localhost",
        pathname: "solr/timelines/update",
        port: 8983,
        query: {
            wt: "json",
            overwrite: true,
            commitWithin: 1000
        }
    })
    //console.log(solrQueryUrl)
    const resp = await axios({
        method: "post",
        url: solrQueryUrl,
        data: [args]
    })

    return resp.data
}
