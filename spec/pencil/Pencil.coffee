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


