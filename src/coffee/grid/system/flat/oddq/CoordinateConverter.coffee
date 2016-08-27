class CoordinateConverter
  # Converti des coordonnees oddq en coordonnees cubiques.
  # @coord coordonnees oddq.
  oddqToCubic: ( coord )->
    x = coord.col
    z = coord.row - ( coord.col - ( coord.col&1 )) / 2
    y = -x-z
    cubic =
      x: x
      z: z
      y: y

  # Converti des coordonnees cubiques en coordonnees odd-q.
  # @coord coordonnees cubiques.
  CubicTooOddq: ( coord )->
    col = coord.x
    row = coord.z + ( coord.x - ( coord.x&1 )) / 2
    oddq = col: col, row: row

module.exports = CoordinateConverter
