canvas = this
width = @width()
height = @height()

center = Point(width, height).scale(0.5)

τ = Math.PI * 2

@fill "blue"
@withTransform Matrix.rotation(τ/3, center), (canvas) ->
  canvas.withTransform Matrix.scale(0.25, 0.25, center), ->
    canvas.fill("red")

n = 97
[0...n].forEach (i) ->
  canvas.withTransform Matrix.rotation(i * τ/n, center), (canvas) ->
    canvas.drawLine
      start: center.add(0, -600)
      end: center
      color: "rgba(255, 0, 255, 1)"
