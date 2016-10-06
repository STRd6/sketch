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

  n = 13
  dx = width / n
  gap = 20

  [-1..3].forEach (i) ->
    canvas.drawCircle
      x: i * width / 3 + (t / 2 * width) % width / 3
      y: halfWidth / 3
      radius: halfWidth / 2
      color: "hsl(60, 100%, 90%)"

  [1...n].forEach (i) ->
    phi = (i / n) * τ

    end = sin(phi + w / 2) * halfWidth / 2 + halfWidth
    
    color = "hsl(#{sin(i / n * τ + w / 2) * 30 + 155}, 75%, 60%)"

    if i % 2
      mult = -1
    else
      mult = 1

    canvas.drawLine
      start:
        x: halfWidth + (i - n / 2) * dx + mult * sin(phi + w / 2) * dx / 0.3333
        y: height
      end:
        x: i * dx
        y: end + gap/2
      color: color

    canvas.drawCircle
      x: i * dx
      y: end
      radius: sin(phi + w / 2) * 4 + 2
      color: "hsl(300, 75%, 60%)"

    canvas.drawCircle
      x: i * dx
      y: halfWidth / 4 + -sin(phi + w / 2) * 40
      radius: -sin(phi + w / 2) * 4
      color: "hsl(300, 75%, 60%)"


