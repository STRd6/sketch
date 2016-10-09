TouchCanvas = require "touch-canvas"
Whammy = require "./lib/whammy"

console.log Whammy

module.exports = (options={}) ->
  {fn, framerate, startTime, duration, width, height, paramData} = options

  console.log "Start", startTime

  t = startTime
  width ?= 400
  height ?= 400
  duration ?= 1
  endTime = startTime + duration
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

      fn.call(canvas, t, canvas, paramData)
      encoder.add(canvas.context())

      i += 1
      t = i / framerate + startTime

      if t >= endTime
        encoder.compile false, (output) ->
          resolve(output)
      else
        setTimeout doFrame, 0

    doFrame()

    return
