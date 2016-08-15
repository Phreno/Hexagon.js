# Dependances
fs      = require "fs"
drawing = require "pngjs-draw"
png     = drawing require( "pngjs" ).PNG

# Constantes
COEFF_HEIGHT  = Math.sqrt( 3 )
COEFF_WIDTH   = 2
COEFF_SIDE    = 3 / 2

# Valeurs par default
DEFAULT_RADIUS    = 20
DEFAULT_ORIGIN_X  = 0
DEFAULT_ORIGIN_Y  = 0
DEFAULT_CELL_COLOR    = "#ddd"
DEFAULT_STROKE_COLOR  = "#000"
DEFAULT_FILE_NAME = "hexaction.out.png"

# Gestionnaire de grille hexagonale.
#
# @note Le systeme de coordonnee ODDQ est utilise pour localiser les cellules hexagonales.
class HexagonalGridManager

  # Initialization des parametres.
  #
  # @param opt [object] setup du gestionnaire de grille.
  # @option opt [int] radius distance entre le centre d'un hexagon et un vertex.
  # @option opt [int] originX taille en pixel de la marge au bord droit de la grille.
  # @option opt [int] originY taille en pixel de la marge au bord superieur de la grille.
  # @option opt [color] cellColor couleur de fond d'une cellule.
  # @option opt [color] strokeColor couleur des cotes d'une cellule.
  # @option opt [int] columns nombre de colonnes de la grille.
  # @option opt [int] rows nombre de ligne de la grille.
  constructor: ( opt )->
    @radius       = DEFAULT_RADIUS        if !opt?radius?
    @originX      = DEFAULT_ORIGIN_X      if !opt?originX?
    @originY      = DEFAULT_ORIGIN_Y      if !opt?originY?
    @cellColor    = DEFAULT_CELL_COLOR    if !opt?cellColor?
    @strokeColor  = DEFAULT_STROKE_COLOR  if !opt?strokeColor?
    @columns      = DEFAULT_COLUMNS       if !opt?columns?
    @rows         = DEFAULT_ROWS          if !opt?rows?
    @out          = DEFAULT_FILE_NAME     if !opt?out?
    @height       = @radius * COEFF_HEIGHT
    @width        = @radius * COEFF_WIDTH
    @side         = @radius * COEFF_SIDE
    @cellShift    = @height / 2

  ###
     (0,0)---                (2,0)---
    /         \             /         \
   /           \           /           \
  /             \         /             \
  \             /(1,0)--- \             /
   \           //         \\           /
    \         //           \\         /
      ------- /             \ -------
              \             /
               \           /
                \         /
                  -------
  Figure 1: Disposition du systeme de coordonnee oddq. ###

  # Est-ce que la cellule se situe sur une colone soumise a un decalage ?
  #
  # @param oddq [object] coordonnees de la cellule.
  # @param oddq.column [int] index de la colonne.
  # @param oddq row [int] index de la ligne.
  # @return [boolean] vrai si la cellule est sur une colone paire.
  isShifted: ( oddq )-> isShifted = ( oddq.column % 2 is 0 )

  ###
  |   .   -------
  |   . /         \
  |   ./           \
  |   /             \
  |   \             /
  |   .\           /
  |   . \         /
3 |.......-------........
  |   .
  |   .
  +----------------------
      4
  Figure 2: Coordonnee de reference pour un hexagone (4,3). ###

  # Recupere les coordonnees de reference (x et y en pixel) d'une cellule en fonction de sa position en oddq.
  #
  # @note Le point de reference se trouve dans le coin inferieur gauche de la cellule.
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
  ###
      4  -------  3
       /         \
      /           \
   5 /             \ 2
     \             /
      \           /
       \         /
      0  -------  1
  Figure 3: Ordre de recuperation des vertices. ###

  # Recupere les vertices d'un hexagone a partir de sa coordonnee de reference.
  #
  # @param referencePoint [object] coordonnees de reference d'un hexagone.
  # @param referencePoint.x [int] coordonnee en abscisse.
  # @param referencePoint.y [int] coordonnee en ordonnee.
  # @return [object] liste des 6 vertices d'un hexagone recuperes dans l'ordre anti-horaire.
  getVerticesFromReferencePoint: ( referencePoint )->
    vertices = [
        ( x: referencePoint.x + @width - @side,  y: referencePoint.y )
        ( x: referencePoint.x + @side,           y: referencePoint.y )
        ( x: referencePoint.x + @width,          y: referencePoint.y + @cellShift )
        ( x: referencePoint.x + @side,           y: referencePoint.y + @height )
        ( x: referencePoint.x + @width - @side,  y: referencePoint.y + @height )
        ( x: referencePoint.x,                   y: referencePoint.y + @cellShift )
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
        next = if index is ( vertices.length - 1 ) then vertices[ 0 ] else vertices[ index + 1 ]
        side =
          start: vertex
          end: next

  # Dessine la grille parametree dans le constructeur.
  drawGrid: ->
    currentHexX = null
    currentHexY = null
    offsetColumn = false
    for col in [ 0 .. ( @cols - 1 ) ]
      for row in [ 0 .. ( @rows - 1 ) ]
        if !offsetColumn
          currentHexX = ( col * @side ) + @originX
          currentHexY = ( row * @height ) + @originY
        else
          currentHexX = ( col * @side ) + @originX
          currentHexY = ( row * @height ) + @originY + @cellShift
        @drawHex( currentHexX, currentHexY, @cellColor )
        offsetColumn = !offsetColumn

  drawHexAtOddq: ( oddq )->
    referencePoint       = @getReferencePointFromOddq oddq
    referencePoint.color = opt.color
    referencePoint.text  = opt.text
    @drawAtReferencePoint referencePoint

  drawHexAtReferencePoint: ( opt )->
    sides = @getSidesFromXY( opt )
    fs.createReadStream( "blue.png" )
      .pipe( new png filterType: 4 )
      .on "parsed", ->
        @drawLine side.start.x, side.start.y, side.end.x, side.end.y, @colors.red( 50 ) for side in sides
        @pack().pipe fs.createWriteStream( "blue.out.png" )

  getOddqOverPoint: ( point )->
    column = Math.floor point.x / @side
    isShifted = ( column % 2 ) is 0
    row = if isShifted then ( point.y / @height ) else ( point.y + @cellShift ) / @height - 1
    row = Math.floor row
    # Test if on left side of frame
    if point.x > ( column * @side ) and point.x < ( column * @side ) + @width - @side
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
