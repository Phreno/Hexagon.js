# Offset de deplacement unitaire sur un axe.
cursor =
  forward: +1
  backward: -1
  position: 0


class Coordinate
  #     ORIENTATION FLAT
  #
  #            NORD
  #  NORD EST   --   NORD OUEST 
  #           /    \
  #           \    /
  #  SUD EST    --   SUD OUEST
  #            SUD
  #
  cubic:
    # Offset des cases adjacentes
    pointTo:
      flat:
        north:
          x: cursor.position
          y: cursor.forward
          z: cursor.backward
          east:
            x: cursor.forward
            y: cursor.position
            z: cursor.backward
          west:
            x: cursor.backward
            y: cursor.forward
            z: cursor.position
        south:
          x: cursor.position
          y: cursor.backward
          z: cursor.forward
          east:
            x: cursor.forward
            y: cursor.backward
            z: cursor.position
          west:
            x: cursor.backward
            y: cursor.position
            z: cursor.forward

    # Converti des coordonnees cubiques en coordonnees odd-q.
    # @coord coordonnees cubiques.
    toOddq: ( coord )->
      col = coord.x
      row = coord.z + ( coord.x - ( coord.x&1 )) / 2
      oddq =
        col: col
        row: row

  oddq:
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
module.exports = Coordinate
