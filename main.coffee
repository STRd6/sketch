require "cornerstone"

time = Observable(0)

do applyStyle = ->
  style = document.createElement 'style'
  style.innerHTML = require "./style"
  document.head.appendChild style

TouchCanvas = require "touch-canvas"

width = height = 360
t = 0
dt = 1/60

canvas = TouchCanvas
  width: 360
  height: 360

run = ->
  program = CoffeeScript.compile editor.getValue(), bare: true
  execWithContext program,
    module: canvas

reset = ->
  t = 0

Template = require("./template")
document.body.appendChild Template
  canvas: canvas.element()
  run: run
  render: ->
    renderWebm 2.9999
  reset: reset
  time: time

aceShim = require("./lib/ace-shim")()

program = PACKAGE.source["program/5.coffee"].content

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

step = ->
  time t.toFixed(2)
  update.call(canvas, t, canvas)
  t += dt
  requestAnimationFrame step

step()

render ({duration, framerate}) ->
  renderWebm = require "./render-webm"

  renderWebm
    fn: update
    width: width
    height: height
    duration: duration
    framerate: framerate
  .then (blob) ->
    video = document.createElement "video"
    video.loop = true
    video.autoplay = true
    video.src = URL.createObjectURL(blob)
    document.body.appendChild video

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
