class Converter
  # Converti des coordonnees oddq en coordonnees cubiques.
  # @param oddq [oddq] coordonnees oddq.
  oddqToCubic: ( oddq )->
    x = oddq.col
    z = oddq.row - ( oddq.col - ( oddq.col&1 )) / 2
    y = - x - z
    cubic =
      x: x
      y: y
      z: z

  # Converti des coordonnees cubiques en coordonnees odd-q.
  # @param [cubic] coordonnees cubiques.
  cubicToOddq: ( cubic )->
    col = cubic.x
    row = cubic.z + ( cubic.x - ( cubic.x&1 )) / 2
    oddq = col: col, row: row

module.exports = Converter
