require "cornerstone"

do applyStyle = ->
  style = document.createElement 'style'
  style.innerHTML = require "./style"
  document.head.appendChild style

TouchCanvas = require "touch-canvas"

width = height = 360

canvas = TouchCanvas
  width: 360
  height: 360

run = ->
  program = CoffeeScript.compile editor.getValue(), bare: true
  execWithContext program,
    module: canvas

Template = require("./template")
document.body.appendChild Template
  canvas: canvas.element()
  run: run

aceShim = require("./lib/ace-shim")()

program = PACKAGE.source["program/3.coffee"].content

global.editor = aceShim.aceEditor()
editor.setSession aceShim.initSession program, "coffee"
editor.focus()

update = ->

execWithContext = (program, context={}) ->
  module = context.module ? {}

  args = Object.keys(context)
  values = args.map (name) -> context[name]

  update = Function(args..., program).apply(module, values)

run()

t = 0
dt = 1/60
step = ->
  update.call(canvas, t, canvas)
  t += dt
  requestAnimationFrame step

step()

-> # TODO: Hook up render gif UI
  renderGif = require "./render-gif"

  renderGif
    fn: update
    width: width
    height: height
    duration: 2.9999
    dt: 1/30
  .then (blob) ->
    img = document.createElement "img"
    img.src = URL.createObjectURL(blob)
    document.body.appendChild img
