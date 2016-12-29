winston = require 'winston'
winston.log 'silly', '{HTMLWriter}'
class HTMLWriter
  constructor: (@layout, @canvas)->
    winston.log 'debug', '#HTMLWriter#'

    # Encapsule une image dans un DOM HTML
    #
    # @param imgData [string] image chiffrée
    @wrapImg = (imgData)->
      winston.log 'debug', 'HTMLWriter.wrapImg'
      winston.log 'silly', "... imgData: #{JSON.stringify imgData}"
      "<html><body><img src='#{imgData}'/></body></html>"

    # Trace un hexagone depuis un point de reference
    #
    # @param referencePoint [coordonnée x/y] coin inférieur gauche dans lequel
    # l'hexagone est inscrit
    # @param layout [layout] disposition de la grille
    # @param canvas [canvas] canvas sur lequel la cellule est tracée
    @sketchCellFromReferencePoint = (referencePoint, layout, canvas)->
      winston.log 'debug', 'HTMLWriter.sketchCellFromReferencePoint'
      winston.log 'silly',"... referencePoint: #{JSON.stringify referencePoint}"
      canvasContext = canvas.getContext '2d'
      vertices  = layout.getVerticesFromReferencePoint referencePoint
      start     = vertices[0]
      canvasContext.beginPath()
      for vertice in vertices
        winston.log 'silly', "..: vertice: #{JSON.stringify vertice}"
        canvasContext.lineTo vertice.x, vertice.y
      # Fermeture de la cellule
      canvasContext.lineTo start.x, start.y
      canvasContext.stroke()

    # Trace un hexagon depuis une coordonnée
    #
    # @param coord [oddq] coordonnée sur la grille hexagonale
    # @param layout [layout] disposition de la grille
    # @param canvas sur lequel la cellule est tracée
    @sketchCellFromCoordinate = (coordinate, layout, canvas)->
      winston.log 'debug', 'HTMLWriter.sketchCellFromCoordinate'
      referencePoint = layout.getReferencePointFromCoordinate( coordinate )
      @sketchCellFromReferencePoint referencePoint

  writeToFile:(output)->
    winston.log 'debug', 'HTMLWriter.writeToFile'
    # @sketchCellFromReferencePoint { x:10, y:10 }, @layout, @canvas
    @sketchCellFromCoordinate { row:2, column:2 }, @layout, @canvas
    dom = @wrapImg @canvas.toDataURL()
    fs = require "fs"
    fs.writeFileSync(output, dom)

module.exports = HTMLWriter
