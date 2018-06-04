const Query = {
    info: () => "Timeline API for vCare as a GraphQL endpoint",
    solrSelect: require("./solr-select"),
    lastMessages: require("./last-messages"),
    solrPing: require("./solr-ping")
}

const Mutation = {
    solrInsert: require("./solr-insert"),
}

module.exports = { Query, Mutation }

