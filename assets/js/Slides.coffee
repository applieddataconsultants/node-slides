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
   keyboardEnabled: true # this can be disabled by default if set false

   initialize: (options = {}) ->
      { @slides, @socket } = options
      $(window).keydown (e) =>
         action = @keys[e.which]
         if action
            e.preventDefault()
            e.stopPropagation()
            if @keyboardEnabled then action.call(@)
      $("#keyboard-enable").click (e) => @keyboardEnabled = true
      $('.clicker_url').html "<a href='//#{location.host}/clicker'>#{location.host}/clicker"
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

      # attempt to make the transitions more natural  
      if((Math.floor(Math.random()*100) % 3) ==0)
        @slides.addClass("animateX")  
        @slides.removeClass("animateY") 
      else if((Math.floor(Math.random()*100) % 2) ==0)
        @slides.addClass("animateY")  
        @slides.removeClass("animateX")
      else
        @slides.removeClass("animateX")
        @slides.removeClass("animateY")
         
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
