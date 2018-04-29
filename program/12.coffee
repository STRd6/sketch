@param "n",
  type: "number"
  value: 3000
  step: 1

@param "Y",
  type: "number"
  value: 72
  step: 0.1

@param "r",
  type: "number"
  value: 1
  step: 0.5

@param "p",
  type: "number"
  value: 12000
  step: 1

@param "s",
  type: "number"
  value: 36
  step: 1

return (t, canvas, {n, Y, r, p, s}) ->
  {abs, sin, cos, PI, min} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2

  τ = PI * 2
  
  # t = sin(t * τ / 20) * 4
  w = t * τ

  canvas.fill("black")

  dx = halfWidth / n

  [1...n].forEach (i) ->
    g = ((i % s) * 255 / s)|0
    
    color = "rgb(#{g}, #{g}, 255)"
    
    canvas.drawCircle
      x: i * dx * sin(i * w / p) + halfWidth
      y: i * dx * cos(i * τ / Y) + halfWidth
      radius: r
      color: color
