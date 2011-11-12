// Odd funky server talking

var net = require('net');
var http = require('http');

var connections = [];

var server = net.createServer(function (c) {
    c.on("data", function(data) {
        connections.forEach(function(other) {
            other.write(data.toString());
        });
    });
});

var httpserver = http.createServer(function (req, res) {
    res.writeHead(200, {'Content-Type': 'text/plain' });
    connections.push(res);
    // connection is never closed
});

server.listen(8001);
httpserver.listen(8000);
