const {GraphQLServer} = require("graphql-yoga")
const resolvers = require("./resolvers")

const getSolrClient = () => {
  const solr = require("solr-client")
  return solr.createClient({
    host: "localhost",
    port: "8983",
    core: "timelines"
  })
}

// for node-dev only to watch for changes in the file
if(process.send) {
  process.send({cmd: 'NODE_DEV', required: 'schema.graphql'})
}

const server = new GraphQLServer({
  typeDefs: 'schema.graphql',
  resolvers,
  context: req => ({
    ...req,
    solr: getSolrClient()
  })

})

server.start(({port}) => console.log(`Server is running on http://localhost:${port}`))
