#!/usr/bin/env coffee

program = require "commander"
HexactionService = require "./service/HexactionService"

program.version "α.0.1"
program.option "-x, --export", "exporte la grille dans le dossier out"


# Export de la grille au format png

if program.export
  # Attribution des valeurs
  # TODO: placer ces valeur en configuration
  gridWidth = 10
  gridHeight = 10
  cellSide = 50
  Hexaction.service.:


