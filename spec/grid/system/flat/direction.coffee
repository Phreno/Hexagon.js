side = require "./side"
cursor = require "../../cursor"

# Liste des directions accessibles depuis une cellule.
direction =
  southWest:
    priority: side.SOUTH_WEST
    x: cursor.backward
    y: cursor.position
    z: cursor.forward
  northWest:
    priority: side.NORTH_WEST
    x: cursor.backward
    y: cursor.forward
    z: cursor.position
  north:
    priority: side.NORTH
    x: cursor.position
    y: cursor.forward
    z: cursor.backward
  northEast:
    priority: side.NORTH_EAST
    x: cursor.forward
    y: cursor.position
    z: cursor.backward
  southEast:
    priority: side.SOUTH_EAST
    x: cursor.forward
    y: cursor.backward
    z: cursor.position
  south:
    priority: side.SOUTH
    x: cursor.position
    y: cursor.backward
    z: cursor.forward

module.exports = direction
