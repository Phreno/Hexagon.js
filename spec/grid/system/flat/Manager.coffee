winston = require 'winston'
winston.level = 'debug'
pretty = require 'prettyprint'

class Manager
  # Ajoute un decalage coordonnee à coordonnee a la cellule.
  #
  # @param offset [cubic] coordonnee a ajouter a start.
  # @param start [cubic] coordonnee de depart.
  walk: ( offset, start )->
    destination =
      x: ( start.x + offset.x )
      y: ( start.y + offset.y )
      z: ( start.z + offset.z )

  # Recupere les cases au voisinage.
  #
  # @param origin [cubic] cellule dont on veut recuperer les cases voisines
  getNeighborhood: ( origin )->
    winston.log 'debug' , 'getNeighborhood'
    winston.log 'debug' , "... origin: #{JSON.stringify origin, null, 2}"

    neighbors = []
    next = @walk
    directions = require "./direction"

    Object
      .keys directions
      .forEach ( target )->
        neighbor = directions[ target ]
        neighbors[ neighbor.priority ] = next neighbor, origin

    winston.log 'debug' , "... neighbors: #{JSON.stringify neighbors, null, 2}"
    neighbors

  # Recupere le chemin a partir d une case dans une direction.
  #
  # @direction cote par lequel par le chemin.
  # @steps longueur du chemin.
  # @origin depart du chemin.
  follow: ( direction, steps, origin, path )->
    path = [] if !path?
    path.push ( @getNeighborhood origin )[ direction ]
    @follow direction, steps, path[ path.length - 1 ], path if --steps
    path

module.exports = Manager
