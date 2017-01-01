winston = require 'winston'
winston.log 'silly', '{GraphicConfig}'


# .Noyau du gestionnaire de grille.
class GraphicConfig

# Initialization des parametres.
  #
  # @param opt [object] setup du gestionnaire de grille.
  # @option opt [int] radius distance entre le centre d'un hexagon et un vertex.
  # @option opt [int] originX taille en pixel de la marge au bord droit.
  # @option opt [int] originY taille en pixel de la marge au bord superieur.
  # @option opt [int] columns nombre de colonnes de la grille.
  # @option opt [int] rows nombre de ligne de la grille.
  constructor: ( opt ) ->
    do debug = ->
      winston.log 'debug', '#GraphicConfig#'

    @COEFF = {}
    @COEFF.HEIGHT  = Math.sqrt( 3 )
    @COEFF.WIDTH   = 2
    @COEFF.SIDE    = 3 / 2
    @COEFF.SHIFT   = 1 / 2

    @DEFAULT = {}
    @DEFAULT.COLUMNS   = 10
    @DEFAULT.ROWS      = 10
    @DEFAULT.RADIUS    = 20
    @DEFAULT.ORIGIN_X  = 0
    @DEFAULT.ORIGIN_Y  = 0

    @radius       = @DEFAULT.RADIUS        if !opt?radius?
    @originX      = @DEFAULT.ORIGIN_X      if !opt?originX?
    @originY      = @DEFAULT.ORIGIN_Y      if !opt?originY?
    @columns      = @DEFAULT.COLUMNS       if !opt?columns?
    @rows         = @DEFAULT.ROWS          if !opt?rows?
    @cellHeight   = @radius * @COEFF.HEIGHT
    @cellWidth    = @radius * @COEFF.WIDTH
    @cellSide     = @radius * @COEFF.SIDE
    @cellShift    = @cellHeight * @COEFF.SHIFT

module.exports = GraphicConfig
