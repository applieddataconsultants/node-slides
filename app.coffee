express    = require("express")
global.app = express.createServer()
io         = require('socket.io').listen(app)
assets     = require('connect-assets')
port       = 3000

app.set 'views', __dirname + '/views'

app.configure 'development', -> app.use assets()
app.configure 'production',  -> port = 8501; app.use assets( build: true, buildDir: false, src: __dirname + '/assets', detectChanges: false )

app.use express.static(__dirname + '/assets')

app.get '/', (req,res) -> res.render 'slides.jade'
app.get '/clicker', (req,res) -> res.render 'clicker.jade'

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

app.listen port
console.log "Listening on http://localhost:#{port}/"
