var socketio = io.connect(document.domain + ':8080');
socketio.emit('connected');
socketio.on('log', function(data){
    var logArea = document.getElementById('logs');
    var domLog = document.createElement('p');
    domLog.innerHTML = data.value;
    logArea.appendChild(domLog);
    $('body').delay(100).animate({
        scrollTop: $(document).height()
    },1500);
});
socketio.on('users', function(data){
    var userArea = document.getElementById('users');
    while(userArea.firstChild) userArea.removeChild(userArea.firstChild);
    var domUser = document.createElement('li');
    data.value.forEach(function(val, i){
        //domUser.innerHTM = "<img src='https://mcapi.ca/avatar/3d/" + val + "/30'> " + val;
        //userArea.appendChild(domUser);
        $li = "<li><img src='https://mcapi.ca/avatar/3d/" + val + "/30'> " + val + "</li>";
        $('#users').append($li);
    });
    var numArea = document.getElementById('num');
    numArea.textContent = data.value.length;
});
