const url = require("url")
const axios = require("axios")

module.exports = async (parent, args) => {
    const solrQueryUrl = url.format({
        protocol: "http",
        hostname: "localhost",
        pathname: "solr/timelines/select",
        port: 8983,
        query: {
            ...args
        }
    })
    const resp = await axios(solrQueryUrl)
    return resp.data
}
