return (t, canvas) ->
  {abs, sin, cos, PI, min} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2

  τ = PI * 2
  w = t * τ

  canvas.fill("white")

  n = 25
  rate = 4
  dx = width / n

  [1...n].forEach (i) ->
    phi = (i / n) * τ * abs(sin(w / 2 - τ / 8)) * 2

    canvas.drawLine
      start:
        x: i * dx
        y: halfWidth
      end:
        x: i * dx
        y: cos(phi + w / 2) * halfWidth + halfWidth
      color: "black"
