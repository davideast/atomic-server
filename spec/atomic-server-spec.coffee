{WorkspaceView} = require 'atom'
AtomicServer = require '../lib/atomic-server'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "AtomicServer", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('atomic-server')

  describe "when the atomic-server:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.atomic-server')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.workspaceView.trigger 'atomic-server:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.atomic-server')).toExist()
        atom.workspaceView.trigger 'atomic-server:toggle'
        expect(atom.workspaceView.find('.atomic-server')).not.toExist()
