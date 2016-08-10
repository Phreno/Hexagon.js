class OddqCoordinateManager
  # Converti des coordonnees oddq en coordonnees cubiques.
  # @coord coordonnees oddq.
  toCubic: ( coord )->
    x = coord.col
    z = coord.row - ( coord.col - ( coord.col&1 )) / 2
    y = -x-z
    cubic =
      x: x
      z: z
      y: y

module.exports = OddqCoordinateManager
