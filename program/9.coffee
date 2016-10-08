return (t, canvas) ->
  {abs, sin, cos, PI, min} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2.1

  τ = PI * 2

  canvas.fill("black")

  n = 800
  dt = τ / n

  x = sin(t * τ / 8 + τ / 4)

  # See diagram on page 56-57 of Digital Harmony
  RD = 3 + x
  TD = 7

  [0...n].forEach (i) ->
    theta = (TD + 1) * i * dt
    r = -sin(RD * i * dt) * halfWidth

    p = Point.fromAngle(theta).scale(r).add(center)
    canvas.drawCircle
      x: p.x
      y: p.y
      radius: 2
      color: "blue"
