// Non-blocking I/O example

var count = 0,
    stdout = process.stdout,
    stdin = process.openStdin();

stdout.write("Type your name: ");

stdin.setEncoding('utf8');

stdin.on('data',function(chunk){
    var name = chunk.replace('\n','');
    stdout.write("Entered " + name + " while counting to " + count + "\n");
    process.exit(0);
});

setInterval(function(){
    count++;
},1000);
