# Please install socket.io diff

io = require("socket.io").listen(8080)

fs = require 'fs'
jsdiff = require 'diff'

old = ""

io.sockets.on 'connection', (socket) ->
    fs.watch '/minecraft/logs/latest.log', (event, filename) ->
        fs.readFile '/minecraft/logs/latest.log', 'utf8', (err, text) ->
            if err?
                console.log err
            else
                next = text
                #console.log text
                diff = jsdiff.diffChars old, next
                old = text
                if diff[1]?
                    if diff[1]["added"] == true
                        log = diff[1]["value"].replace(/\r?\n/g,"")
                        io.sockets.emit "log", {value:log}
                        console.log "追加: " + log
