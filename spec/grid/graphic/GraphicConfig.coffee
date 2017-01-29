# [K3rn€l_P4n1K] GraphicConfig
#   Le propos de cette classe est de fournir les valeurs
#   initiales pour le calcul de la position des cellules.

#################
# CONFIGURATION #
#################

DEFAULT =
  columns: 10
  rows: 10
  radius: 20
  origin_x: 0
  origin_y: 0

CONSTANT =
  coeffHeight: Math.sqrt( 3 )
  coeffWidth: 2
  coeffSide: 3 / 2
  coeffShift: 1 / 2

VENDOR =
  winston: require 'winston'

#################
# GraphicConfig #
#################
VENDOR.winston.log 'silly', '{GraphicConfig}'
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
      VENDOR.winston.log 'debug', '#GraphicConfig#'

    @radius       = DEFAULT.radius        if !opt?radius?
    @originX      = DEFAULT.origin_x      if !opt?originX?
    @originY      = DEFAULT.origin_y      if !opt?originY?
    @columns      = DEFAULT.columns       if !opt?columns?
    @rows         = DEFAULT.rows          if !opt?rows?
    @cellHeight   = @radius * CONSTANT.coeffHeight
    @cellWidth    = @radius * CONSTANT.coeffWidth
    @cellSide     = @radius * CONSTANT.coeffSide
    @cellShift    = @cellHeight * CONSTANT.coeffShift

module.exports = GraphicConfig
