
winston = require 'winston'
winston.level = 'silly'
winston.add winston.transports.File, {filename: 'log/oddq.Manager.log'}
winston.remove winston.transports.Console

class Manager
  # Ajoute un decalage coordonnee à coordonnee a la cellule.
  #
  # @param offset [cubic] coordonnee a ajouter a start.
  # @param start [cubic] coordonnee de depart.
  walk: ( offset, start )->
    winston.log 'debug', 'walk'
    winston.log 'silly', "... offset: #{JSON.stringify offset}"
    winston.log 'silly', "... start: #{JSON.stringify start}"
    destination =
      x: ( start.x + offset.x )
      y: ( start.y + offset.y )
      z: ( start.z + offset.z )

  # Recupere les cases au voisinage.
  #
  # @param origin [cubic] cellule dont on veut recuperer les cases voisines
  getNeighborhood: ( origin )->
    winston.log 'debug' , 'getNeighborhood'
    winston.log 'silly' , "... origin: #{JSON.stringify origin}"

    neighbors = []
    next = @walk
    directions = require "../enum/flat_direction"

    Object
      .keys directions
      .forEach ( target )->
        winston.log 'silly', "... target: #{JSON.stringify target}"
        neighbor = directions[ target ]
        winston.log 'silly', "... neighbor: #{JSON.stringify neighbor}"
        neighbors[ neighbor.priority ] = next neighbor, origin

    winston.log 'silly', "... neighbors: #{JSON.stringify neighbors}"
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
    winston.log 'silly', "... direction: #{JSON.stringify direction}"
    winston.log 'silly', "... steps: #{JSON.stringify steps}"
    winston.log 'silly', "... origin: #{JSON.stringify origin}"
    winston.log 'silly', "... path: #{JSON.stringify path}"
    path = [] if !path?
    path.push ( @getNeighborhood origin )[ direction ]
    @follow direction, steps, path[ path.length - 1 ], path if --steps
    path

module.exports = Manager
