// Pipe example (TCP Echo Server)

var net = require('net');

var server = net.createServer(function (socket) {
  socket.write('Piping!\n');
  socket.pipe(socket);
});

server.listen(8000);
console.log('Echo server started on port 8000');
