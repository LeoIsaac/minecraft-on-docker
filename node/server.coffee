# Please install socket.io diff

io = require("socket.io").listen(8080)

fs = require 'fs'
jsdiff = require 'diff'

old = ""
users = []

fs.readFile '/minecraft/logs/latest.log', 'utf8', (err, text) ->
    if !err?
        old = text


io.sockets.on 'connection', (socket) ->
    socket.on 'connected', () ->
        io.sockets.emit 'users', {value:users}

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
                                pushLog(log, users)


pushLog = (log, users) ->
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
        users.push(user)
        console.log users
        io.sockets.emit 'users', {value:users}
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
        users.splice users.indexOf(user), 1
        console.log users
        io.sockets.emit 'users', {value:users}
    #else
    if status == "WARN"
        msg = "【警告】" + msg
    io.sockets.emit "log", {value:msg}


avatar = (user) ->
    return "<img src='https://mcapi.ca/avatar/3d/" + user + "/50'>"


html = (str) ->
    str = str.replace /&/g, '&amp;'
    str = str.replace /"/g, '&quot;'
    str = str.replace /'/g, '&#039;'
    str = str.replace /</g, '&lt;'
    str = str.replace />/g, '&gt;'
    return str
