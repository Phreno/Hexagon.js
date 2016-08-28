GridCore = require "../../../GridCore"
# Systeme de coordonnees oddq appliqué.
class Oddq extends GridCore
  # Est-ce que la cellule se situe sur une colone soumise a un decalage ?
  #
  # @param oddq [object] coordonnees de la cellule.
  # @param oddq.column [int] index de la colonne.
  # @param oddq.row [int] index de la ligne.
  # @return [boolean] vrai si la cellule est sur une colone paire.
  isShifted: ( oddq )-> isShifted = ( oddq.column % 2 is 0 )

  # Recupere les coordonnees de reference (x et y en pixel)
  # d'une cellule en fonction de sa position en oddq.
  #
  # @note Sous le coin inferieur gauche de la cellule.
  # @param oddq [object] position en oddq.
  # @param oddq.row [int] index de la ligne sur la grille.
  # @param oddq.column [int] index de la colone sur la grille.
  # @return [object] coordonnee du point de reference.
  getReferencePointFromOddq: ( oddq )->
    x = ( oddq.column * @side ) + @originX
    y = ( oddq.row * @height ) + @originY
    referencePoint =
      x: x
      y: if @isShifted oddq then y else ( y + @cellShift )

  # Recupere les vertices d'un hexagone a partir de sa coordonnee de reference.
  #
  # @param referencePoint [object] coordonnees de reference d'un hexagone.
  # @param referencePoint.x [int] coordonnee en abscisse.
  # @param referencePoint.y [int] coordonnee en ordonnee.
  # @return [object] vertices d'un hexagone recuperes dans l'ordre anti-horaire.
  getVerticesFromReferencePoint: ( referencePoint )->
    vertices = [
        ( x: referencePoint.x + @width - @side, y: referencePoint.y )
        ( x: referencePoint.x + @side, y: referencePoint.y )
        ( x: referencePoint.x + @width, y: referencePoint.y + @cellShift )
        ( x: referencePoint.x + @side, y: referencePoint.y + @height )
        ( x: referencePoint.x + @width - @side, y: referencePoint.y + @height )
        ( x: referencePoint.x, y: referencePoint.y + @cellShift )
    ]

  # Recupere les cotes d'un hexagone a partir de sa coordonnee de reference.
  #
  # @param referencePoint [object] coordonnees de reference d'un hexagone.
  # @param referencePoint.x [int] coordonnee en abscisse.
  # @param referencePoint.y [int] coordonnee en ordonnee.
  # @return [array] liste des vertices d'un hexagone regroupes deux a deux.
  getSidesFromReferencePoint: ( referencePoint )->
    @getVerticesFromReferencePoint( referencePoint )
      .map ( vertex, index, vertices )->
        end = vertices.length - 1
        next = if index is end then vertices[ 0 ] else vertices[ index + 1 ]
        side =
          start: vertex
          end: next

  getOddqOverPoint: ( point )->
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

module.exports = Oddq
