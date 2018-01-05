@param "RD",
  type: "number"
  value: 1
  step: 0.25

# NOTE: This TD param is equivalent to Whitney's TD + 1
@param "TD",
  type: "number"
  value: 1
  step: 0.25

@param "n",
  type: "number"
  value: 30
  step: 1

return (t, canvas, params) ->
  {RD, TD, n} = params
  {abs, sin, cos, PI, min, max, floor} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2.1

  τ = PI * 2

  canvas.fill("black")
  canvas.fill("rgba(255, 0, 0, 0.75)")

  phi = τ / n # Angular Unit
  f = 0.5
  alpha = (t % f) / f

  [0...6].forEach (q) ->
    theta = q * τ / 6 + (τ * t / 3)

    [0..n].forEach (v) ->
      r = (v + alpha) * 7.75
      p = Point.fromAngle(theta).scale(r).add(center)

      opacity = 0.5 - (0.5 * (v + alpha) / n)

      canvas.drawCircle
        x: p.x
        y: p.y
        radius: (v + alpha) * 3.85 + alpha * 2
        color: "rgba(0, 0, 255, #{opacity})"
