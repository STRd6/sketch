TouchCanvas = require "touch-canvas"

GIF = require "./lib/gif"

console.log GIF

workerURL = URL.createObjectURL(new Blob([PACKAGE.source["lib/gif-worker.js"].content]))

module.exports = (options={}) ->
  {fn, dt, duration, width, height} = options

  t = 0
  dt ?= 1/60
  width ?= 400
  height ?= 400
  duration ?= 1

  canvas = TouchCanvas
    width: width
    height: height

  new Promise (resolve, reject) ->
    gif = new GIF
      workers: 4
      quality: 100
      workerScript: workerURL
      width: width
      height: height

    # add an image element
    # gif.addFrame(imageElement);

    # or a canvas element
    # gif.addFrame(canvasElement, {delay: 200});

    # or copy the pixels from a canvas context
    # gif.addFrame(ctx, {copy: true});

    gif.on 'finished', (blob) ->
      resolve blob

    i = 0
    doFrame = ->
      console.log "frame: ", i, t

      fn.call(canvas, t, canvas)
      # TODO: delay accumulates rounding errors here
      gif.addFrame(canvas.context(), copy: true, delay: dt * 1000)

      t += dt
      if t >= duration
        gif.render()
      else
        requestAnimationFrame doFrame

      i += 1

    doFrame()

    return
