winston = require 'winston'
winston.log 'silly', '{GraphicConfig}'

# Constantes
COEFF_HEIGHT  = Math.sqrt( 3 )
COEFF_WIDTH   = 2
COEFF_SIDE    = 3 / 2
COEFF_SHIFT   = 1 / 2

# Valeurs par default
DEFAULT_COLUMNS   = 10
DEFAULT_ROWS      = 10
DEFAULT_RADIUS    = 20
DEFAULT_ORIGIN_X  = 0
DEFAULT_ORIGIN_Y  = 0

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
  constructor: ( opt )->
    winston.log 'debug', '#GraphicConfig#'
    @radius       = DEFAULT_RADIUS        if !opt?radius?
    @originX      = DEFAULT_ORIGIN_X      if !opt?originX?
    @originY      = DEFAULT_ORIGIN_Y      if !opt?originY?
    @columns      = DEFAULT_COLUMNS       if !opt?columns?
    @rows         = DEFAULT_ROWS          if !opt?rows?
    @height       = @radius * COEFF_HEIGHT
    @width        = @radius * COEFF_WIDTH
    @side         = @radius * COEFF_SIDE
    @cellShift    = @height * COEFF_SHIFT

module.exports = GraphicConfig
