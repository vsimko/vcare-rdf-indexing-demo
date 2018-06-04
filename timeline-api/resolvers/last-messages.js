module.exports = async (parent, args, context, info) => {

    const {topic, howmany} = args

    const query = context.solr.createQuery()
        .q(`topic:${topic}`)
        .sort({_version_:"desc"})
        .start(0)
        .rows(howmany)

    const {response} = await context.solr.searchAsync(query)

    return response.docs.map(doc => ({
        data: doc.data[0],
        topic: doc.topic[0]
    }))
}