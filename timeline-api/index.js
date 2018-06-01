const {GraphQLServer} = require("graphql-yoga")
const resolvers = require("./resolvers")

const server = new GraphQLServer({
  typeDefs: 'schema.graphql',
  resolvers,
  debug: true
})

server.start(({port}) => console.log(`Server is running on http://localhost:${port}`))
