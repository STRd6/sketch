return (t, canvas) ->
  {abs, sin, cos, PI, min, max, floor} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2.1

  τ = PI * 2

  canvas.fill("black")

  n = 800
  dt = τ / n

  x = cos(t * τ / 8)

  # See diagram on page 56-57 of Digital Harmony
  # Note: It seems more natural for me to number the TD one greater than Whitney
  # did, but for now I'm keeping it as he numbered it
  # TODO: Can these be generalized to complex values?
  RD = 1 + x
  TD = 0

  [0...n].forEach (i) ->
    theta = (TD + 1) * i * dt
    # TODO: Explore generalizing this sin fn as a complex exponential
    r = -sin(RD * i * dt) * halfWidth

    p = Point.fromAngle(theta).scale(r).add(center)
    canvas.drawCircle
      x: p.x
      y: p.y
      radius: 2
      color: "blue"
