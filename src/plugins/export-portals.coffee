module.exports = 

    onBootstrap: (callback) ->

        if argv.export
            bootstrap ->
                callback 'end'
        else
            callback()

bootstrap = (callback) ->

    cursor = Database.db.collection('Portals').find().toArray (err, portals) ->

        if err
            logger.error '[Export] %s', err.message
            return callback()

        lines = []

        for po in portals

            line = []
            line.push po.title.replace(/,/g, '-').trim() if argv.title or argv.t
            line.push po.latE6 / 1e6 if argv.latlng or argv.l
            line.push po.lngE6 / 1e6 if argv.latlng or argv.l
            line.push po.image if argv.image or argv.I
            line.push po._id if argv.id or argv.i
            line.push po.capturedTime or '' if argv.time or argv.T
            line.push po.owner or '' if argv.owner or argv.o

            lines.push line.join(',')

        if argv.output
            fs = require 'fs'
            fs.writeFileSync argv.output, lines.join('\n')
            logger.info '[Export] Exported %d portals', lines.length
        else
            console.log lines.join('\n')

        callback()
