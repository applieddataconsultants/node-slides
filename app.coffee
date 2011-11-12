express    = require("express")
global.app = express.createServer()
io         = require('socket.io').listen(app)
assets     = require('connect-assets')

ip = '192.168.236.169'

app.use assets()
app.use express.static(__dirname + '/assets')

app.get '/', (req,res) -> res.render('slides.jade', { ip: ip })
app.get '/clicker', (req,res) -> res.render('clicker.jade')

slides_io = io.of("/slides")
clicker_io = io.of("/clicker")

slideId = 1 # dangerous for a threaded system to do
clicker_io.on "connection", (socket) ->
   socket.emit("startfrom", slideId)
   socket.on "changeto", (id) ->
      slideId = id
      slides_io.emit("changeto", slideId)
      socket.broadcast.emit("changeto", slideId)

slides_io.on "connection", (socket) ->
   socket.emit("startfrom", slideId)
   socket.on "changeto", (id) ->
      slideId = id
      clicker_io.emit("changeto", slideId)
      socket.broadcast.emit("changeto", slideId)

app.listen(3000)
console.log("Listening on http://localhost:3000/")
