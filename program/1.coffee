return (t) ->
  {sin, cos, PI, min} = Math
  canvas = this
  width = @width()
  height = @height()

  center = Point(width, height).scale(0.5)

  τ = PI * 2

  rot = t * τ

  @fill("black")
  a = min(1.5 + sin(rot + PI), 1)
  fillColor = "rgba(0, 0, 255, #{a})"

  @fill fillColor
  @withTransform Matrix.rotation(τ/3 + rot/4, center), (canvas) ->
    canvas.withTransform Matrix.scale(0.25, 0.25, center), ->
      canvas.fill("red")

  n = 97
  end = center.add(0, -600)
  [0...n].forEach (i) ->
    r = 255
    b = 255 # if i % 2 then 255 else 128
    canvas.withTransform Matrix.rotation(i * τ/n - rot/28, center), (canvas) ->
      canvas.drawLine
        start: center
        end: end
        color: "rgba(#{r}, 0, #{b}, 1)"
