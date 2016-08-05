# Offset de deplacement unitaire sur un axe.
cursor =
  forward: +1
  backward: -1
  position: 0

class Coordinate
  cubic:
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
  oddq:
    toCubic: ( coord )->
      x = coord.col
      z = coord.row - ( coord.col - ( coord.col&1 )) / 2
      y = -x-z
      cubic =
        x: x
        z: z
        y: y
module.exports = coordinate
