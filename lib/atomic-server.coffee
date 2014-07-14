AtomicServerView = require './atomic-server-view'

module.exports =
  atomicServerView: null

  activate: (state) ->
    @atomicServerView = new AtomicServerView(state.atomicServerViewState)

  deactivate: ->
    @atomicServerView.destroy()

  serialize: ->
    atomicServerViewState: @atomicServerView.serialize()
