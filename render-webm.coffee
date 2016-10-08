TouchCanvas = require "touch-canvas"
Whammy = require "./lib/whammy"

console.log Whammy

module.exports = (options={}) ->
  {fn, framerate, duration, width, height} = options

  t = 0
  width ?= 400
  height ?= 400
  duration ?= 1
  framerate ?= 30
  dt = 1/framerate

  canvas = TouchCanvas
    width: width
    height: height

  new Promise (resolve, reject) ->
    encoder = new Whammy.Video(framerate)

    i = 0
    doFrame = ->
      console.log "frame: ", i, t

      fn.call(canvas, t, canvas)
      encoder.add(canvas.context())

      i += 1
      t = i / framerate

      if t >= duration
        encoder.compile false, (output) ->
          resolve(output)
      else
        setTimeout doFrame, 0

    doFrame()

    return