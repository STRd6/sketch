return (t, canvas) ->
  {abs, sin, cos, PI, min} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2

  τ = PI * 2
  rot = t * τ

  canvas.fill("black")

  n = 180
  rate = 4
  dx = width / n

  [1...n].forEach (i) ->
    r = 0
    g = 255
    b = 128

    phi = i * τ / 360 * t

    canvas.drawLine
      start:
        x: i * dx * sin(phi) + halfWidth
        y: i * dx * cos(phi) + halfWidth
      end:
        x: i * dx * cos(phi) + halfWidth
        y: i * dx * -sin(phi) + halfWidth
      color: "hsl(#{i * 5}, 100%, 60%)"
