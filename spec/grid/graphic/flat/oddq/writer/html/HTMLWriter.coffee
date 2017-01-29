# [K3rn€l_P4n1k] HTMLWriter
#   Le propos de cette classe est de dessiner une grille hexagonale.

#################
# CONFIGURATION #
#################

DEFAULT =
  output: 'unprovided.html'
  no_img:'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAYAAACtWK6eAA'+
      'AABmJLR0QA/wD/AP+gvaeTAAAAsUlEQVR4nO3BAQEAAACCIP+vbkhAAQAAAAAAAAAAAAAA'+
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8GXHmAAFMgHIEAAA'+
      'AAElFTkSuQmCC'


DEPENDENCY =
  OddqLayout: require '../../layout/OddqLayout'

VENDOR =
  winston: require 'winston'
  Canvas: require 'canvas'

VENDOR.winston.log 'silly', (JSON.stringify DEPENDENCY, null, 2)
##############
# HTMLWriter #
##############
VENDOR.winston.log 'silly', '{HTMLWriter}'

class HTMLWriter
  constructor: (@layout)->
    VENDOR.winston.log 'debug', '#HTMLWriter#'

    if !@layout?
      VENDOR.winston.log 'debug', 'layout is not provided'
      VENDOR.winston.log 'debug', '--> setting default layout: oddq'
      @layout = new DEPENDENCY.OddqLayout

    ###########
    # PRIVATE #
    ###########

    # Encapsule une image dans un DOM HTML
    #
    # @param imgData [string] image chiffrée
    wrapImg = (imgData)->
      do debug = ->
        VENDOR.winston.log 'debug', 'HTMLWriter.wrapImg'
        # VENDOR.winston.log 'silly', "... imgData: #{JSON.stringify imgData}"

      do checkArgsOrDefault = ->
        if !imgData?
          VENDOR.winston.log 'debug', 'imgData is not provided'
          VENDOR.winston.log 'debug', '--> setting default no img sample'
          imgData = DEFAULT.no_img

      do execute = ->
        "<html><body><img src='#{imgData}'/></body></html>"

    # Trace un hexagone depuis un point de reference
    #
    # @param referencePoint [coordonnée x/y] coin inférieur gauche dans lequel
    # l'hexagone est inscrit
    # @param layout [layout] disposition de la grille
    # @param canvas [canvas] canvas sur lequel la cellule est tracée
    sketchCellFromReferencePoint = (referencePoint, layout, canvas)->
      do debug = ->
        VENDOR.winston.log 'debug', 'HTMLWriter.sketchCellFromReferencePoint'
        point = JSON.stringify referencePoint
        VENDOR.winston.log 'silly',"... referencePoint: #{point}"

      do error = ->
        if !referencePoint?
          throw new Error 'ERR referencePoint is not provided'
          process.exit 1

        if !layout?
          throw new Error 'ERR layout is not provided'
          process.exit 1

        if !canvas?
          throw new Error 'ERR canvas is not provided'
          process.exit 1

      path = do init = ->
        vertices = layout.getVerticesFromReferencePoint referencePoint
        # Force le chemin depuis le dernier vertice jusqu'au premier
        vertices.push vertices[0]
        vertices

      do execute = ->
        canvasContext = canvas.getContext '2d'
        canvasContext.beginPath()
        for vertice in path
          VENDOR.winston.log 'silly', "..: vertice: #{JSON.stringify vertice}"
          canvasContext.lineTo vertice.x, vertice.y
        canvasContext.stroke()

    # Trace un hexagon depuis une coordonnée
    #
    # @param coord [oddq] coordonnée sur la grille hexagonale
    # @param layout [layout] disposition de la grille
    # @param canvas [canvas] sur lequel la cellule est tracée
    sketchCellFromCoordinate = (coordinate, layout, canvas)->
      do debug = ->
        VENDOR.winston.log 'debug', 'HTMLWriter.sketchCellFromCoordinate'
        VENDOR.winston.log(
          'silly'
          , "... coordinate: #{JSON.stringify coordinate}")

      do error = ->
        throw new Error 'ERR coordinate is not provided' if !coordinate?
        throw new Error 'ERR layout is not provided' if !layout?

      referencePoint = layout.getReferencePointFromCoordinate( coordinate )
      sketchCellFromReferencePoint referencePoint, layout, canvas

    ##########
    # PUBLIC #
    ##########

    # Trace une grille hexagonale
    @sketchGrid = (layout = @layout)->
      VENDOR.winston.log 'debug', 'HTMLWriter.sketchGrid'

      do error = ->
        if !layout?
          throw new Error 'ERR layout is not provided'
          process.exit 1

      @canvas = do init = () ->
        VENDOR.winston.log 'silly', '""""""'
        VENDOR.winston.log 'silly', (JSON.stringify layout, null, 2 )
        VENDOR.winston.log 'silly', '......'
        canvasWidth =
          layout.graphicConfig.columns * layout.graphicConfig.cellWidth
        canvasHeight =
          layout.graphicConfig.rows * layout.graphicConfig.cellHeight
        new VENDOR.Canvas canvasWidth, canvasHeight

      do execute = (container = @canvas)->
        for rowIndex in [0..layout.graphicConfig.rows]
          for columnIndex in [0..layout.graphicConfig.columns]
            sketchCellFromCoordinate {
              column:columnIndex,
              row:rowIndex
            }, layout, container

    @writeToFile = (output) ->
      do error = ->
        if !output?
          throw new Error 'ERR output is not provided'
          process.exit 1

      do execute = ( grid = @canvas ) ->
        VENDOR.winston.log 'debug', 'HTMLWriter.writeToFile'
        ( require 'fs' ).writeFileSync( output, wrapImg grid.toDataURL() )

module.exports = HTMLWriter
