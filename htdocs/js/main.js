var socketio = io.connect(document.domain + ':8080');
socketio.emit('connected');
socketio.on('log', function(data){
    var logArea = document.getElementById('logs');
    var domLog = document.createElement('p');
    domLog.innerHTML = data.value;
    //flag = checkHeight();
    logArea.appendChild(domLog);
    /*
    if(flag) {
        $('body').delay(100).animate({
            scrollTop: $(document).height()
        },1500);
    } else {
        toastr.info(data.value);
    }
    */
});
socketio.on('users', function(data){
    var userArea = document.getElementById('users');
    while(userArea.firstChild) userArea.removeChild(userArea.firstChild);
    var domUser = document.createElement('li');
    data.value.forEach(function(val, i){
        console.log(val);
        domUser.innerHTML = "<img src='https://mcapi.ca/avatar/3d/" + val + "/30'> " + val;
        userArea.appendChild(domUser);
        //$li = "<li><img src='https://mcapi.ca/avatar/3d/" + val + "/30'> " + val + "</li>";
        //$('#users').append($li);
    });
    var numArea = document.getElementById('num');
    numArea.textContent = data.value.length;
});

/*
$(window).on('load scroll resize', function() {
    checkHeight();
});



function checkHeight() {
    var windowHeight = window.innerHeight;
    var logHeight = $(window).height();
    var scrollTop = $(window).scrollTop();
    if(windowHeight + scrollTop >= logHeight - 10) {
        return true;
    } else {
        return false;
    }
};

toastr.options.onclick = function() {
    $('body').delay(100).animate({
        scrollTop: $(document).height()
    },1500);
}
*/
