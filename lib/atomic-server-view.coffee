{View, EditorView} = require 'atom'
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
      @subview 'miniEditor', new EditorView(mini: true)
      @div class: 'message', outlet: 'message'
      #@div "The AtomicServer package is Alive! It's ALIVE!", class: "message"

  initialize: (serializeState) ->
    atom.workspaceView.command "atomic-server:toggle", => @toggle()
    atom.workspaceView.command "atomic-server:start", => @start()
    atom.workspaceView.command "atomic-server:close", => @close()

    @miniEditor.hiddenInput.on 'focusout', => @detach() unless @detaching
    @on 'core:confirm', => @start()
    @on 'core:cancel', => @detach()

    @miniEditor.preempt 'textInput', (e) =>
      true
      #false unless e.originalEvent.data.match(/[0-9\-]/)

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
    serverPort = @miniEditor.getText()

    serve = (req, res) -> res.redirect "/index.html"

    app.get "/", serve

    app.use methodOverride
    app.use bodyParser.json

    app.use bodyParser.urlencoded
      extended: true

    #app.use express.static __dirname + '/public'
    projectPath = atom.project.getPath()

    #console.log projectPath
    app.use express.static(projectPath)

    app.use errorHandler
      dummyExceptions: true
      showStack: true

    console.log "Simple static server listening at http://localhost:#{serverPort}"
    app.listen serverPort

  close: ->
    console.log "Shutting down!"
    app.close
