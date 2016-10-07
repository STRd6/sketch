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

RenderTemplate = require "./templates/render"

renderOptions =
  duration: Observable(2)
  framerate: Observable(30)
  format: Observable "gif"
  formatOptions: Observable [
    "gif"
    "webm"
  ]
  submit: (e) ->
    e.preventDefault()
    Modal.hide(renderOptions)
    # TODO: Display progress bar
    # TODO: Cancellable render

Template = require("./template")
document.body.appendChild Template
  canvas: canvas.element()
  run: run
  render: ->
    form = RenderTemplate renderOptions
    Modal.show form, (data) ->
      if data
        render[data.format()]
          duration: data.duration()
          framerate: data.framerate()
      else
        console.log "cancelled"

  pause: ->
    paused = !paused

  reset: reset
  time: time

aceShim = require("./lib/ace-shim")()

program = PACKAGE.source["program/8.coffee"].content

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
  try
    update.call(canvas, t, canvas)
  t += dt unless paused
  requestAnimationFrame step

step()

render = 
  webm: ({duration, framerate}) ->
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

  gif: ({duration, framerate}) ->
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
