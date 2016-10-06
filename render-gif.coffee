TouchCanvas = require "touch-canvas"

GIF = require "./lib/gif"

console.log GIF

workerURL = URL.createObjectURL(new Blob([PACKAGE.source["lib/gif-worker.js"].content]))

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
    gif = new GIF
      workers: 4
      quality: 10
      workerScript: workerURL
      width: width
      height: height

    gif.on 'finished', (blob) ->
      resolve blob

    i = 0
    doFrame = ->
      console.log "frame: ", i, t

      fn.call(canvas, t, canvas)
      # TODO: Make sure this dt doesn't accumulate errors
      gif.addFrame(canvas.context(), copy: true, delay: dt * 1000)

      i += 1
      t = i / framerate
      if t >= duration
        gif.render()
      else
        requestAnimationFrame doFrame

    doFrame()

    return
