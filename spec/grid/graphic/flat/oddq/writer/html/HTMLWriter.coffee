winston = require 'winston'
winston.log 'silly', '{HTMLWriter}'

class HTMLWriter
  constructor: (@layout)->
    winston.log 'debug', '#HTMLWriter#'

    @DEFAULT= {}
    @DEFAULT.ROWS = 10
    @DEFAULT.COLUMNS = 10
    @DEFAULT.OUTPUT = './out.html'
    @DEFAULT.Layout = require '../../layout/OddqLayout'
    @DEFAULT.NO_IMG =
      'data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAMgAAADICAYAAACtWK6eAAA'+
      'ABmJLR0QA/wD/AP+gvaeTAAAAsUlEQVR4nO3BAQEAAACCIP+vbkhAAQAAAAAAAAAAAAAA'+
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA'+
      'AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAB8GXHmAAFMgHIEAAA'+
      'AAElFTkSuQmCC'

    if !@layout?
      winston.log 'debug', 'layout is not provided'
      winston.log 'debug', '--> setting default layout: oddq'
      @layout = new @DEFAULT.Layout

    ###########
    # PRIVATE #
    ###########

    # Encapsule une image dans un DOM HTML
    #
    # @param imgData [string] image chiffrée
    wrapImg = (imgData)->
      do debug = ->
        winston.log 'debug', 'HTMLWriter.wrapImg'
        # winston.log 'silly', "... imgData: #{JSON.stringify imgData}"

      do checkArgsOrDefault = ->
        if !imgData?
          winston.log 'debug', 'imgData is not provided'
          winston.log 'debug', '--> setting default no img sample'
          imgData = @DEFAULT.NO_IMG

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
        winston.log 'debug', 'HTMLWriter.sketchCellFromReferencePoint'
        point = JSON.stringify referencePoint
        winston.log 'silly',"... referencePoint: #{point}"

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
          winston.log 'silly', "..: vertice: #{JSON.stringify vertice}"
          canvasContext.lineTo vertice.x, vertice.y
        canvasContext.stroke()

    # Trace un hexagon depuis une coordonnée
    #
    # @param coord [oddq] coordonnée sur la grille hexagonale
    # @param layout [layout] disposition de la grille
    # @param canvas [canvas] sur lequel la cellule est tracée
    sketchCellFromCoordinate = (coordinate, layout, canvas)->
      do debug = ->
        winston.log 'debug', 'HTMLWriter.sketchCellFromCoordinate'
        winston.log 'silly', "... coordinate: #{JSON.stringify coordinate}"

      do error = ->
        throw new Error 'ERR coordinate is not provided' if !coordinate?
        throw new Error 'ERR layout is not provided' if !layout?
      referencePoint = layout.getReferencePointFromCoordinate( coordinate )
      sketchCellFromReferencePoint referencePoint, layout, canvas

    ##########
    # PUBLIC #
    ##########

    # Trace une grille hexagonale
    #
    # @param option [object] configuration de la grille a tracer
    # @param option.rows [int] nombre de lignes de la grille
    # @param option.columns [int] nombre de colonnes de la grille
    # @param layout [layout] disposition de la grille
    @sketchGrid = ( option, layout = @layout )->
      winston.log 'debug', 'HTMLWriter.sketchGrid'

      do checkArgsOrDefault = ->
        if !option?
          winston.log 'debug', 'option is not provided'
          winston.log 'debug', '--> setting default values'
          option = {
            rows: @DEFAULT.ROWS,
            columns: @DEFAULT.COLUMNS
          }

        if !option.rows?
          winston.log 'debug', 'option.rows is not provided'
          winston.log 'debug', '--> setting default number of rows'
          option.rows = @DEFAULT.ROWS

        if !option.columns?
          winston.log 'debug', 'option.columns is not provided'
          winston.log 'debug', '--> setting default number of columns'
          option.columns = @DEFAULT.COLUMNS

        winston.log 'silly', "... option: #{JSON.stringify option}"

      do error = ->
        if !layout?
          throw new Error 'ERR layout is not provided'
          process.exit 1


      @canvas = do init = ->
        Canvas = require 'canvas'
        canvasWidth = option.columns * layout.graphicConfig.cellWidth
        canvasHeight = option.rows * layout.graphicConfig.cellHeight
        new Canvas canvasWidth, canvasHeight

      do execute = (canvas = @canvas)->
        for rowIndex in [0..option.rows]
          for columnIndex in [0..option.columns]
            sketchCellFromCoordinate {
              column:columnIndex,
              row:rowIndex
            }, layout, canvas

    @writeToFile = (output) ->
      do checkArgsOrDefault = ->
        if !output?
          winston.log 'debug', 'output is not provided'
          winston.log 'debug', "--> setting default: #{@DEFAULT.OUTPUT}"
          output = @DEFAULT.OUTPUT
      do execute = ( canvas = @canvas ) ->
        winston.log 'debug', 'HTMLWriter.writeToFile'
        ( require 'fs' ).writeFileSync( output, wrapImg canvas.toDataURL() )

module.exports = HTMLWriter
