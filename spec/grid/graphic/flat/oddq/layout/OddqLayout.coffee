GraphicConfig = require "../../../GraphicConfig.coffee"
winston = require "winston"
winston.log 'silly', '{OddqLayout}'
# Systeme de coordonnees oddq appliqué.
class OddqLayout
  constructor:()->
    do debug = ->
      winston.log 'debug', '#OddqLayout#'

    @graphicConfig = new GraphicConfig()

    @offset = {
      southWest: {
        x: @graphicConfig.cellWidth - @graphicConfig.cellSide,
        y: 0
      },
      southEast: {
        x: @graphicConfig.cellSide,
        y: 0
      },
      east: {
        x: @graphicConfig.cellWidth,
        y: @graphicConfig.cellShift
      },
      northEast: {
        x: @graphicConfig.cellSide,
        y: @graphicConfig.cellHeight
      },
      northWest: {
        x: @graphicConfig.cellWidth - @graphicConfig.cellSide,
        y: @graphicConfig.cellHeight
      },
      west: {
        x: 0,
        y: @graphicConfig.cellShift
      }
    }

    winston.log 'silly', "... @offset: #{JSON.stringify @offset}"

    # Est-ce que la cellule se situe sur une colone soumise a un decalage ?
    #
    # @param oddq [object] coordonnees de la cellule.
    # @param oddq.column [int] index de la colonne.
    # @param oddq.row [int] index de la ligne.
    # @return [boolean] vrai si la cellule est sur une colone paire.
    @isShifted = ( oddq )->
      winston.log 'debug', 'OddqLayout.isShifted'
      isShifted = ( oddq.column % 2 is 0 )

    # Recupere les coordonnees de reference (x et y en pixel)
    # d'une cellule en fonction de sa position en oddq.
    #
    # @param oddq [object] position en oddq.
    # @param oddq.row [int] index de la ligne sur la grille.
    # @param oddq.column [int] index de la colone sur la grille.
    # @return [object] coordonnee du point de reference.
    @getReferencePointFromCoordinate = ( oddq ) ->
      do debug = ->
        winston.log 'debug', 'OddqLayout.getReferencePointFromCoordinate'
        winston.log 'silly', "... oddq: #{JSON.stringify oddq}"

      do error = ->
        if !oddq?
          throw new Error 'oddq is not provided'
          exit 1
        if !oddq.column?
          throw new Error 'oddq.column is not provided'
          exit 1
        if !oddq.row?
          throw new Error 'oddq.row is not provided'
          exit 1

      x = ( oddq.column * @graphicConfig.cellSide ) + @graphicConfig.originX
      y = ( oddq.row * @graphicConfig.cellHeight ) + @graphicConfig.originY
      referencePoint =
        x: x
        y: if @isShifted oddq then y else ( y + @graphicConfig.cellShift )

    # Recupere les vertices d'un hexagone a partir de sa coordonnee de
    # reference.
    #
    # @param referencePoint [object] coordonnees de reference d'un hexagone.
    # @param referencePoint.x [int] coordonnee en abscisse.
    # @param referencePoint.y [int] coordonnee en ordonnee.
    # @return [object] vertices d'un hexagone recuperes dans l'ordre
    # anti-horaire.
    @getVerticesFromReferencePoint = ( referencePoint )->
      do debug = ->
        winston.log 'debug', 'OddqLayout.getVerticesFromReferencePoint'
        winston.log 'silly', "... referencePoint: #{referencePoint}"

      do error = ->
        if !referencePoint?
          throw new Error 'referencePoint is not provided'
          exit 1

        if !referencePoint.x?
          throw new Error 'referencePoint.x is not provided'
          exit 1

        if !referencePoint.y?
          throw new Error 'referencePoint.y is not provided'
          exit 1

      vertices = [
        {
          x: referencePoint.x + @offset.southWest.x,
          y: referencePoint.y + @offset.southWest.y
        },
        {
          x: referencePoint.x + @offset.southEast.x,
          y: referencePoint.y + @offset.southEast.y
        },
        {
          x: referencePoint.x + @offset.east.x,
          y: referencePoint.y + @offset.east.y
        },
        {
          x: referencePoint.x + @offset.northEast.x,
          y: referencePoint.y + @offset.northEast.y
        },
        {
          x: referencePoint.x + @offset.northWest.x,
          y: referencePoint.y + @offset.northWest.y
        },
        {
          x: referencePoint.x + @offset.west.x,
          y: referencePoint.y + @offset.west.y
        }
      ]

  # Recupere les cotes d'un hexagone a partir de sa coordonnee de reference.
  #
  # @param referencePoint [object] coordonnees de reference d'un hexagone.
  # @param referencePoint.x [int] coordonnee en abscisse.
  # @param referencePoint.y [int] coordonnee en ordonnee.
  # @return [array] liste des vertices d'un hexagone regroupes deux a deux.
  getSidesFromReferencePoint: ( referencePoint )->
    winston.log 'debug', 'OddqLayout.getSidesFromReferencePoint'
    @getVerticesFromReferencePoint( referencePoint )
      .map ( vertex, index, vertices )->
        end = vertices.length - 1
        next = if index is end then vertices[ 0 ] else vertices[ index + 1 ]
        side =
          start: vertex
          end: next

  getOddqOverPoint: ( point )->
    winston.log 'debug', 'OddqLayout.getOddqOverPoint'
    column = Math.floor point.x / @side
    isShifted = ( column % 2 ) is 0
    shifted = point.y / @height
    nonShifted = ( point.y + @cellShift ) / @height - 1
    row = if isShifted then shifted else nonShifted
    row = Math.floor row
    # Test if on left side of frame
    limitLeft = column * @side
    limitRight = limitLeft + @width - @side
    if point.x > limitLeft and point.x < limitRight
      # Now test which of the two triangles we are in
      # Top left triangle points
      p1 =
        x: column * @side
        y: if isShifted then row * @height else ( row * @height ) + @cellShift
      p2 =
        x: p1.x
        y: p1.y + @cellShift
      p3 =
        x: p1.x + @width - @side
        y: p1.y
      if @isPointInTriangle point, p1, p2, p3
        column--
        if isShifted then row--

      # Bottom left triangle points
      p4 = p2
      p5 =
        x: p4.x
        y: p4.y + @cellShift
      p6 =
        x: p5.x + @width - @side
        y: p5.y
      if @isPointInTriangle point, p4, p5, p6
        column--
        if isShifted then row++
      result = row: row, column: column

  #sign: (p1, p2, p3)−>
  # ( p1.x - p3.x ) * ( p2.y - p3.y ) - ( p2.x - p3.x ) * ( p1.y - p3.y )

  #isPointInTriangle: (pt, v1, v2, v3)−>
  #  b1 = ( @sign pt, v1, v2 ) < 0.0
  #  b2 = ( @sign pt, v2, v3 ) < 0.0
  #  b3 = ( @sign pt, v3, v1 ) < 0.0
  #  ( b1 is b2 ) and ( b2 is b3 )

module.exports = OddqLayout
