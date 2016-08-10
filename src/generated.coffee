# Offset de deplacement unitaire sur un axe.
cursor =
  forward: +1
  backward: -1
  position: 0

class CubicCoordinateManager
  offset:
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

  # Recupere le cube adjacent dans la direction donnee.
  # @offset du cote adjacent.
  # @coord cellule a partir de laquelle est effectue le pas de cote.
  stepAside: ( offset, coord )->
    side =
      x: offset.x + coord.x,
      y: offset.y + coord.y,
      z: offset.z + coord.z

  # Recupere les cases au voisinage.
  # @coord cellule dont on veut recuperer les cases voisines
  getNeighborhood: ( coord )->
    neighbors = [
      @stepAside( @offset.south.east, coord )
      @stepAside( @offset.north.east, coord )
      @stepAside( @offset.north, coord )
      @stepAside( @offset.north.west, coord )
      @stepAside( @offset.south.west, coord )
      @stepAside( @offset.south, coord )
    ]

  # Recupere la case au voisinage dans la direction donnee.
  # @direction cote par lequel on recupere le voisin.
  # @coord cellule dont on veut recuperer le voisin.
  getNeighbor: ( direction, coord )->
    neighbor = null
    switch typeof direction
      when "number" then neighbor = ( @getNeighborhood coord )[ direction ]
      when "object" then neighbor = @stepAside( direction, coord )
      else console.log "err"
    neighbor

  # Recupere le chemin a partir d une case dans une direction.
  # @direction cote par lequel par le chemin.
  # @steps longueur du chemin.
  # @origin depart du chemin.
  follow: ( direction, steps, origin )->
    path = []
    while steps--
      coord = this.getNeighbor direction, origin
      path.push coord
    path

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
