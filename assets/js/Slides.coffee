#= require lib/jquery
#= require lib/underscore
#= require lib/backbone

SlideRouter = Backbone.Router.extend
   routes:
      "/slide/:id": "activate"

   keys:
      # Left arrow
      "37": -> @navigate "/slide/#{ if @slideId > 1 then @slideId - 1 else 1 }", true
      # Up arrow
      "38": -> @navigate "/slide/#{ if @slideId > 1 then @slideId - 1 else 1 }", true
      # Right arrow
      "39": -> @navigate "/slide/#{ if @slideId < @slides.size() then @slideId + 1 else @slides.size() }", true
      # Down arrow
      "40": -> @navigate "/slide/#{ if @slideId < @slides.size() then @slideId + 1 else @slides.size() }", true

   initialize: (options = {}) ->
      { @slides, @socket } = options
      $(window).keydown (e) =>
         action = @keys[e.which]
         if action
            e.preventDefault()
            e.stopPropagation()
            action.call(@)
      @_bindSocket()

   _bindSocket: ->
      @socket.on 'changeto', (id) => @navigate "/slide/#{id}", true
      @socket.on 'startfrom', (id) => @navigate "/slide/#{id}", true

      @socket.on "connect", ->
         $("#connect").hide()
      @socket.on "disconnect", ->
         $("#connect").show()

   activate: (id) ->
      @slideId = parseInt(id)
      @socket.emit("changeto", @slideId)
      @slides.removeClass("active")
      slide = @slides.get(id - 1)
      $(slide).addClass("active")
      document.title = $(".active h1").text()

$ ->
   connection = io.connect()
   new SlideRouter
      slides: $(".slide")
      socket: connection.socket.of("/slides")
   Backbone.history.start()
