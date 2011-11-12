#= require lib/jquery
#= require lib/underscore
#= require lib/backbone

Clicker = Backbone.View.extend
   el: 'body'
   events:
      "click #previous": 'prevSlide'
      'click #next': 'nextSlide'
   allowEmit: true

   initialize: (options = {}) ->
      { @socket, @slides } = options
      @slideId = 1
      $("#current").text @slideId
      $("#max").text @slides.size()

      @_bindSocket()

   _bindSocket: ->
      @socket.on 'changeto', (id) =>
         @slideId = id
         @allowEmit = false
         @update()

      @socket.on 'startfrom', (id) =>
         @slideId = id
         @allowEmit = false
         @update()

      @socket.on "connect", ->
         $("#connect").hide()
      @socket.on "disconnect", ->
         $("#connect").show()

   prevSlide: ->
      if @slideId > 1
         @slideId--
         @update()

   nextSlide: ->
      if @slideId < @slides.size()
         @slideId++
         @update()

   update: () ->
      if @allowEmit
         @socket.emit("changeto", @slideId)
      @allowEmit = true

      $('#current').text @slideId
      localStorage.currentSlideId = @slideId

      current = $(@slides.get(@slideId-1))
      next = $(@slides.get(@slideId))
      $("#slide-title").text(current.find("h1").text())
      $("#speaker-note").html(current.find(".speaker").html())
      $("#next-slide-title").html(next.find("h1").html() || "")

$ ->
   connection = io.connect()
   $.get "/", (data) ->
      slides = $(".slide", data)
      new Clicker
         socket: connection.socket.of("/clicker")
         slides: slides
