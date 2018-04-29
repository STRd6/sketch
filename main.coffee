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
t = Observable 0
dt = Observable 1/60

canvas = TouchCanvas
  width: 360
  height: 360

ParamTemplate = require "./templates/param"
paramData = {}
params = Observable []
canvas.param = (name, properties) ->
  console.log name, properties

  properties.name = name
  properties.value = Observable properties.value
  updateParam = (value) ->
    # TODO: Handle non-float values
    paramData[name] = parseFloat value
  updateParam properties.value()
  properties.value.observe updateParam

  params.push ParamTemplate properties

run = ->
  program = CoffeeScript.compile editor.getValue(), bare: true
  execWithContext program,
    module: canvas

reset = ->
  t(0)

paused = false

RenderTemplate = require "./templates/render"

renderOptions =
  startTime: Observable(0)
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
          duration: parseFloat data.duration()
          framerate: parseFloat data.framerate()
          startTime: parseFloat data.startTime()
      else
        console.log "cancelled"

  pause: ->
    paused = !paused

  params: params
  reset: reset
  time: time
  t: t
  dt: dt

aceShim = require("./lib/ace-shim")()

program = PACKAGE.source["program/12.coffee"].content

global.editor = aceShim.aceEditor()
editor.setSession aceShim.initSession program, "coffee"
editor.focus()

update = ->

execWithContext = (program, context={}) ->
  module = context.module ? {}

  args = Object.keys(context)
  values = args.map (name) -> context[name]

  params []
  update = Function(args..., program).apply(module, values)

run()

step = ->
  # Ensure time is a number
  currentTime = parseFloat(t()) or 0
  # Time Display
  time currentTime.toFixed(2)
  try
    update.call(canvas, currentTime, canvas, paramData)
  t(dt() + currentTime) unless paused
  requestAnimationFrame step

step()

render =
  webm: ({duration, framerate, startTime}) ->
    renderWebm = require "./render-webm"

    renderWebm
      fn: update
      width: width
      height: height
      startTime: startTime
      duration: duration
      framerate: framerate
      paramData: paramData
    .then (blob) ->
      video = document.createElement "video"
      video.loop = true
      video.autoplay = true
      video.src = URL.createObjectURL(blob)
      document.body.appendChild video

  gif: ({duration, framerate, startTime}) ->
    renderGif = require "./render-gif"

    renderGif
      fn: update
      width: width
      height: height
      startTime: startTime
      duration: duration
      framerate: framerate
      paramData: paramData
    .then (blob) ->
      img = document.createElement "img"
      img.src = URL.createObjectURL(blob)
      document.body.appendChild img
