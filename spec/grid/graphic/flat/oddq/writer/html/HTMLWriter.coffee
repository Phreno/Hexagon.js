class HTMLWriter
  constructor: (@layout, @canvas)->
    @ctx = @canvas.getContext '2d'
    @ctx.strokeStyle = 'rgba(0,0,0,0.5)'

    @wrap = (imgData)->
      "<html><body><img src='#{imgData}'/></body></html>"

    @draw = (referencePoint)->
      @ctx.beginPath()
      for vertice in @layout.getVerticesFromReferencePoint referencePoint
        @ctx.lineTo vertice.x, vertice.y
      @ctx.stroke()

  writeToFile:(output)->
    @draw(x:10, y:10)
    dom = @wrap @canvas.toDataURL()
    fs = require "fs"
    fs.writeFileSync(output, dom)

module.exports = HTMLWriter
