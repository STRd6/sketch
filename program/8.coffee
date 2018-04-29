return (t, canvas) ->
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

  n = 170
  dx = halfWidth / n

  [1...n].forEach (i) ->
    canvas.drawCircle
      x: i * dx * sin(i * w / 60) + halfWidth
      y: i * dx * cos(i * τ / 17) + halfWidth
      radius: 5
      color: "blue"
