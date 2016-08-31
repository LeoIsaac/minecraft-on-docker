# Please install socket.io diff

io = require("socket.io").listen(8080)

fs = require 'fs'
jsdiff = require 'diff'

old = ""

io.sockets.on 'connection', (socket) ->
    fs.readFile '/minecraft/logs/latest.log', 'utf8', (err, text) ->
        if !err?
            old = text

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
                        logs = diff[1]["value"].split "\n"
                        for log in logs
                            if log != ""
                                pushLog(log)


pushLog = (log) ->
    loger = log.match /^\[(\d{2}):(\d{2}):(\d{2})\] \[(.*)\/(.*)\]: (.*)/
    if !loger?
        return
    status = loger[5]
    msg = loger[6]
    #if chat
    chat = msg.match /^\<(.*)\> (.*)/
    if chat?
        user = chat[1]
        comment = chat[2]
        msg = avatar(user) + html(comment)
    #if join
    join = msg.match /^(.*) joined the game/
    if join?
        user = join[1]
        msg = user + avatar(user) + "がログインしました"
    #if achievement
    acvm = msg.match /^(.*) has just earned the achievement \[(.*)\]/
    if acvm?
        user = acvm[1]
        achievement = acvm[2]
        msg = user + avatar(user) + "が" + achievement + "を獲得しました"
    #if left
    left = msg.match /^(.*) left the game/
    if left?
        user = left[1]
        msg = user + avatar(user) + "がログアウトしました"
    #else
    io.sockets.emit "log", {value:msg}
    console.log loger


avatar = (user) ->
    return "<img src='https://minotar.net/avatar/" + user + "/30'>"


html = (str) ->
    str = str.replace /&/g, '&amp;'
    str = str.replace /"/g, '&quot;'
    str = str.replace /'/g, '&#039;'
    str = str.replace /</g, '&lt;'
    str = str.replace />/g, '&gt;'
    return str
