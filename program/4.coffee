return (t, canvas) ->
  {sin, cos, PI, min} = Math
  canvas = this
  width = canvas.width()
  height = canvas.height()

  center = Point(width, height).scale(0.5)

  halfWidth = width/2

  τ = PI * 2
  rot = t * τ

  canvas.fill("black")

  overallRotation = 0 #- rot / 30

  n = 240
  end = center.add(0, -halfWidth)
  [0...n].forEach (i) ->
    r = 255
    b = 255 # if i % 2 then 255 else 128
    canvas.withTransform Matrix.rotation(i * τ/n + overallRotation, center), (canvas) ->
      canvas.drawLine
        start: center.add(Point.fromAngle(-rot / 3 ).scale(halfWidth * sin(0 + i * τ / 80)))
        end: end
        color: "rgba(#{r}, 0, #{b}, 1)"
