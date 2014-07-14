{View} = require 'atom'
{allowUnsafeEval} = require 'loophole'
express = allowUnsafeEval -> require 'express'
app = express()
bodyParser = allowUnsafeEval -> require 'body-parser'
errorHandler = allowUnsafeEval -> require 'errorhandler'
methodOverride = allowUnsafeEval -> require 'method-override'
port = parseInt 3000

module.exports =
class AtomicServerView extends View
  @content: ->
    @div class: 'atomic-server overlay from-top', =>
      @div "The AtomicServer package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
        atom.workspaceView.command "express-server:toggle", => @toggle()
        atom.workspaceView.command "express-server:start", => @start()
        atom.workspaceView.command "express-server:close", => @close()

      # Returns an object that can be retrieved when package is activated
      serialize: ->

      # Tear down any state and detach
      destroy: ->
        @close()
        @detach()

      toggle: ->
        console.log "Express Server was toggled!"
        #console.log server
        if @hasParent()
          @detach()
        else
          atom.workspaceView.append(this)

      start: ->
        console.log "Starting!"

        serve = (req, res) -> res.redirect "/index.html"

        app.get "/", serve

        app.use methodOverride
        app.use bodyParser.json
        # app.use bodyParser.urlEncoded {
        #   extended: true
        # }
        app.use express.static __dirname + '/public'

        # app.use(errorHandler({
        #   dumpExceptions: true,
        #   showStack: true
        # }));

        console.log "Simple static server listening at http://localhost:" + port
        app.listen port

      close: ->
        console.log "Shutting down!"
        app.close
