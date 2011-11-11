// TCP chat server

var net = require('net');
var sockets = [];

var server = net.createServer(function(socket){
    socket.write('Welcome to Chat Server\n');
    sockets.push(socket);

    socket.on('data',function(data){
        sockets.forEach(function(s){
            if(s != socket){
                s.write(data);
            }
        });
    });

    socket.on('end',function(){
        sockets.forEach(function(s,i){
            if(s == socket){
                sockets.splice(i,1);
            }
        });
    });
});

server.listen(8000);
console.log('Server started on port 8000');
