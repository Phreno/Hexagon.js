side = require "./side"
cursor = require "../../cursor"

# Liste des directions accessibles depuis une cellule.
direction =
  southEast:
    priority: side.SOUTH_EAST
    x: cursor.forward
    y: cursor.backward
    z: cursor.position
  northEast:
    priority: side.NORTH_EAST
    x: cursor.forward
    y: cursor.position
    z: cursor.backward
  north:
    priority: side.NORTH
    x: cursor.position
    y: cursor.forward
    z: cursor.backward
  northWest:
    priority: side.NORTH_WEST
    x: cursor.backward
    y: cursor.forward
    z: cursor.position
  southWest:
    priority: side.SOUTH_WEST
    x: cursor.backward
    y: cursor.position
    z: cursor.forward
  south:
    priority: side.SOUTH
    x: cursor.position
    y: cursor.backward
    z: cursor.forward

module.exports = direction
