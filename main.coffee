require "cornerstone"

do applyStyle = ->
  style = document.createElement 'style'
  style.innerHTML = require "./style"
  document.head.appendChild style

TouchCanvas = require "touch-canvas"

canvas = TouchCanvas()

run = ->
  program = CoffeeScript.compile editor.getValue(), bare: true
  execWithContext program,
    module: canvas

Template = require("./template")
document.body.appendChild Template
  canvas: canvas.element()
  run: run

aceShim = require("./lib/ace-shim")()

program = PACKAGE.source["program/1.coffee"].content

global.editor = aceShim.aceEditor()
editor.setSession aceShim.initSession program, "coffee"
editor.focus()

execWithContext = (program, context={}) ->
  module = context.module ? {}

  args = Object.keys(context)
  values = args.map (name) -> context[name]

  Function(args..., program).apply(module, values)

run()
