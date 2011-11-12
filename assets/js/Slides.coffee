#= require lib/jquery
#= require lib/underscore
#= require lib/backbone

SlideRouter = Backbone.Router.extend
   routes:
      "/slide/:id": "activate"

   keys:
      # Home
      "36": -> @navigate "/slide/1", true
      # End
      "35": -> @navigate "/slide/#{@slides.length}", true
      # Page Up
      "33": -> @navigate "/slide/#{ if @slideId > 1 then @slideId - 1 else 1 }", true
      # Left arrow
      "37": -> @navigate "/slide/#{ if @slideId > 1 then @slideId - 1 else 1 }", true
      # Up arrow
      "38": -> @navigate "/slide/#{ if @slideId > 1 then @slideId - 1 else 1 }", true
      # Page Down
      "34": -> @navigate "/slide/#{ if @slideId < @slides.size() then @slideId + 1 else @slides.size() }", true
      # Right arrow
      "39": -> @navigate "/slide/#{ if @slideId < @slides.size() then @slideId + 1 else @slides.size() }", true
      # Down arrow
      "40": -> @navigate "/slide/#{ if @slideId < @slides.size() then @slideId + 1 else @slides.size() }", true
      # Space
      "32": -> @navigate "/slide/#{ if @slideId < @slides.size() then @slideId + 1 else @slides.size() }", true

   allowEmit: true
   keyboardEnabled: false

   initialize: (options = {}) ->
      { @slides, @socket } = options
      $(window).keydown (e) =>
         action = @keys[e.which]
         if action
            e.preventDefault()
            e.stopPropagation()
            if @keyboardEnabled then action.call(@)
      $("#keyboard-enable").click (e) => alert('Enabled Keyboard'); @keyboardEnabled = true
      @_bindSocket()

   _bindSocket: ->
      @socket.on 'changeto', (id) => @allowEmit = false; @navigate "/slide/#{id}", true
      @socket.on 'startfrom', (id) => @allowEmit = false; @navigate "/slide/#{id}", true

      @socket.on "connect", ->
         $("#connect").hide()
      @socket.on "disconnect", ->
         $("#connect").show()

   activate: (id) ->
      @slideId = parseInt(id)
      if @allowEmit and @keyboardEnabled
         @socket.emit("changeto", @slideId)
      @allowEmit = true

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
