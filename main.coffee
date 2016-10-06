require "cornerstone"

time = Observable(0)

{Modal} = UI = require "ui"

do applyStyle = ->
  style = document.createElement 'style'
  style.innerHTML = [
    UI.Style.modal
    require "./style"
  ].join("\n")
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

paused = false

Template = require("./template")
document.body.appendChild Template
  canvas: canvas.element()
  run: run
  render: ->
    form = document.createElement "div"
    Modal.show form, (data) ->
      render
        duration: 2
        framerate: 60
  pause: ->
    paused = !paused

  reset: reset
  time: time

aceShim = require("./lib/ace-shim")()

program = PACKAGE.source["program/7.coffee"].content

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
  t += dt unless paused
  requestAnimationFrame step

step()

render = ({duration, framerate}) ->
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

render = ({duration, framerate}) ->
  renderGif = require "./render-gif"

  renderGif
    fn: update
    width: width
    height: height
    duration: duration
    framerate: framerate
  .then (blob) ->
    img = document.createElement "img"
    img.src = URL.createObjectURL(blob)
    document.body.appendChild img
