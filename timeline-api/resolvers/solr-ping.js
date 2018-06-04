module.exports = async (parent,args,context) => {
    const result = await context.solr.pingAsync()
    return {
        status: result.status,
        qtime: result.responseHeader.QTime,
    }
}