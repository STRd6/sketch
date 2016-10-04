TouchCanvas = require "touch-canvas"

GIF = require "./lib/gif"

console.log GIF

workerURL = URL.createObjectURL(new Blob([PACKAGE.source["lib/gif-worker.js"].content]))

module.exports = (options={}) ->
  {fn, dt, duration, width, height} = options

  t = 0
  dt ?= 1000/60
  width ?= 400
  height ?= 400
  duration ?= 1

  canvas = TouchCanvas
    width: width
    height: height

  new Promise (resolve, reject) ->
    gif = new GIF
      workers: 2
      quality: 10
      workerScript: workerURL

    # add an image element
    # gif.addFrame(imageElement);

    # or a canvas element
    # gif.addFrame(canvasElement, {delay: 200});

    # or copy the pixels from a canvas context
    # gif.addFrame(ctx, {copy: true});

    gif.on 'finished', (blob) ->
      resolve blob

    doFrame = ->
      if t >= duration
        gif.render()
      else
        fn.call(canvas, t, canvas)
        gif.addFrame(canvas.context(), delay: dt)

        t += dt
        requestAnimationFrame doFrame

    doFrame()

    return
