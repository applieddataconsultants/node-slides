// Hello World HTTP Server example

var http = require('http');

var s = http.createServer(function(req,res){
    res.writeHead(200,{ 'Content-Type': 'text/plain' });
    res.end('Hello World');
});

s.listen(8000);
console.log('Server started on port 8000');
