@param "RD",
  type: "number"
  value: 1
  step: 0.25

# NOTE: This TD param is equivalent to Whitney's TD + 1
@param "TD",
  type: "number"
  value: 1
  step: 0.25

return (t, canvas, params) ->
  {RD, TD} = params
  {abs, sin, cos, PI, min, max, floor} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2.1

  τ = PI * 2

  canvas.fill("black")

  n = 800
  phi = τ / n # Angular Unit

  [0...n].forEach (i) ->
    theta = TD * i * phi
    # TODO: Explore generalizing this sin fn as a complex exponential
    r = -sin(RD * i * phi) * halfWidth

    p = Point.fromAngle(theta).scale(r).add(center)
    canvas.drawCircle
      x: p.x
      y: p.y
      radius: 2
      color: "blue"
