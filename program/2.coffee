return (t) ->
  {sin, cos, PI, min} = Math
  canvas = this
  width = @width()
  height = @height()

  context = canvas.context()
  context.lineCap = "round"

  center = Point(width, height).scale(0.5)

  τ = PI * 2
  rot = t * τ

  @fill "blue"

  n = 97
  end = center.add(0, -600)
  [0...n].forEach (i) ->
    r = 255
    b = 255 # if i % 2 then 255 else 128
    canvas.withTransform Matrix.rotation(i * τ/n - rot/28, center), (canvas) ->
      canvas.drawLine
        start: center.add(Point.fromAngle(-rot / 30).scale(center.x * sin(rot / 5 + i * PI * 2 / 194)))
        end: end
        color: "rgba(#{r}, 0, #{b}, 1)"
