const {GraphQLServer} = require("graphql-yoga")
const axios = require("axios")
const url = require("url")

const resolvers = {
  Query: {
    info: () => "Timeline API for vCare as a GraphQL endpoint",
    solrSelect: async (parent, args) => {
      const solrQueryUrl = url.format({
        protocol: "http",
        hostname: "localhost",
        pathname: "solr/timelines/select",
        port: 8983,
        query: {
          ...args
        }
      })
      //console.log(solrQueryUrl)
      const resp = await axios(solrQueryUrl)
      return resp.data
    }
  },
  Mutation: {
    solrInsert: async (parent, args) => {
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
    },
  }
}

const server = new GraphQLServer({
  typeDefs: 'schema.graphql',
  resolvers,
  debug: true
})

server.start(() => console.log(`Server is running on http://localhost:4000`))
