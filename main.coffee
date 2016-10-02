do applyStyle = ->
  style = document.createElement 'style'
  style.innerHTML = require "./style"
  document.head.appendChild style

Postmaster = require 'postmaster'

consoleWindow = (url, handlers, options={}) ->
  frame = document.createElement 'iframe'
  frame.src = url

  postmaster = Postmaster(handlers)
  postmaster.remoteTarget = -> 
    frame.contentWindow

  # Return a proxy for easy Postmastering
  proxy = new Proxy postmaster,
    get: (target, property, receiver) ->
      target[property] or
      (args...) ->
        target.invokeRemote property, args...

  proxy.element = frame

  return proxy

c = consoleWindow "https://danielx.net/coffee-console",
  ready: ->
    console.log 'ready'

document.body.appendChild c.element

TouchCanvas = require "touch-canvas"

canvas = TouchCanvas()
canvas.fill("blue")

document.body.appendChild canvas.element()
