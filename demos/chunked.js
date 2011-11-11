// Chunked HTTP example

var http = require('http');
http.createServer(function (req, res) {
  res.writeHead(200, {'Content-Type': 'text/plain' });

  res.write('Hello\n');

  setTimeout(function() {
    res.end('World\n');
  }, 2000);

}).listen(8000);
console.log('Server started on port 8000');
