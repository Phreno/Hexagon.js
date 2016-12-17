winston = require 'winston'
winston.level = 'debug'

class Manager
  # Ajoute un decalage coordonnee à coordonnee a la cellule.
  #
  # @param offset [cubic] coordonnee a ajouter a start.
  # @param start [cubic] coordonnee de depart.
  walk: ( offset, start )->
    winston.log 'debug', 'walk'
    winston.log 'debug', "... offset: #{JSON.stringify offset, null, 2}"
    winston.log 'debug', "... start: #{JSON.stringify start, null, 2}"
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
        winston.log 'debug', "... target: #{JSON.stringify target, null, 2}"
        neighbor = directions[ target ]
        neighbors[ neighbor.priority ] = next neighbor, origin

    winston.log 'debug', "... neighbors: #{JSON.stringify neighbors, null, 2}"
    neighbors

  # Recupere le chemin a partir d une case dans une direction.
  # Fonction récursive, path est construit à la volée.
  #
  # @direction cote par lequel par le chemin.
  # @steps longueur du chemin.
  # @origin depart du chemin.
  # @path (optionnel) historique du chemin parcouru.
  follow: ( direction, steps, origin, path )->
    winston.log 'debug', 'follow'
    winston.log 'debug', "... direction: #{JSON.stringify direction, 2, null}"
    winston.log 'debug', "... steps: #{JSON.stringify steps, 2, null}"
    winston.log 'debug', "... origin: #{JSON.stringify origin, 2, null}"
    winston.log 'debug', "... path: #{JSON.stringify path}"
    path = [] if !path?
    path.push ( @getNeighborhood origin )[ direction ]
    @follow direction, steps, path[ path.length - 1 ], path if --steps
    path

module.exports = Manager
