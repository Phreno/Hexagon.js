Oddqlayout = require "../../../layout/OddqLayout"


drawhexatreferencepoint: ( referencepoint )->
  canvas = new Canvas 200, 200
  ctx = canvas.getContext '2d'
  ctx.strokeStyle = 'rgba(0,0,0,0.5)'
  ctx.beginPath()

  for vertice in  @getVerticesFromReferencePoint referencePoint
    ctx.lineTo vertice.x, vertice.y
  ctx.stroke()

  console.log '<img src="' + canvas.toDataURL() + '" />'
