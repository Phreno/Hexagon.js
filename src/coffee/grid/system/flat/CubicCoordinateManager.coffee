c = require "../Cursor"
p = require "./VerticePriority"

class CubicCoordinateManager
  offset:
    southEast:
      priority: p.SOUTH_EAST
      x: c.forward
      y: c.backward
      z: c.position
    northEast:
      priority: p.NORTH_EAST
      x: c.forward
      y: c.position
      z: c.backward
    north:
      priority: p.NORTH
      x: c.position
      y: c.forward
      z: c.backward
    northWest:
      priority: p.NORTH_WEST
      x: c.backward
      y: c.forward
      z: c.position
    southWest:
      priority: p.SOUTH_WEST
      x: c.backward
      y: c.position
      z: c.forward
    south:
      priority: p.SOUTH
      x: c.position
      y: c.backward
      z: c.forward

  # Recupere le cube adjacent dans la direction donnee.
  # @offset du cote adjacent.
  # @coord cellule a partir de laquelle est effectue le pas de cote.
  stepAside: ( offset, coord )->
    side =
      x: ( offset.x + coord.x )
      y: ( offset.y + coord.y )
      z: ( offset.z + coord.z )

  # Recupere les cases au voisinage.
  # @origin coordonnee de la cellule dont on veut recuperer les cases voisines
  getNeighborhood: ( origin )->
    neighbors = []
    nextStep = @stepAside
    directions = @offset
    Object
      .keys directions
      .forEach ( target )->
        step = directions[ target ]
        neighbors[ step.priority ] = nextStep step, origin
    neighbors

  # Recupere le chemin a partir d une case dans une direction.
  # @direction cote par lequel par le chemin.
  # @steps longueur du chemin.
  # @origin depart du chemin.
  follow: ( direction, steps, origin, path )->
    path = [] if !path?
    path.push ( @getNeighborhood origin )[ direction ]
    @follow direction, steps, path[ path.length - 1 ], path if --steps
    path

module.exports = CubicCoordinateManager
