#!/usr/bin/env coffee

program = require 'commander'
program.version 'α.0.1'
program.option '-v, --verbose', 'affiche les logs sur la sortie standard'

program.parse process.argv

winston = require 'winston'
winston.level = 'silly'
winston.add winston.transports.File, {
  filename: "#{process.env.HEXACTION_LOG}/client.log"
}

# Export de la grille au format png

if !program.verbose
  winston.remove winston.transports.Console

winston.log 'info', 'LANCEMENT DE LA ROUTINE'

# Attribution des valeurs
# TODO: placer ces valeur en configuration
CANVAS_WIDTH  = 1200
CANVAS_HEIGHT = 1200

Canvas = require "canvas"
Writer = require "../grid/graphic/flat/oddq/writer/html/HTMLWriter"
Layout = require "../grid/graphic/flat/oddq/layout/OddqLayout"

canvas = new Canvas CANVAS_WIDTH, CANVAS_HEIGHT
canvasContext = canvas.getContext '2d'
canvasContext.strokeStyle = 'rgba(0,0,0,0.5)'

layout = new Layout
writer = new Writer layout, canvas

writer.sketchGrid { rows:5, columns:4 }, @layout, @canvas
writer.writeToFile "#{process.env.HEXACTION_OUT}/out.html"

winston.log 'info', 'FIN DE LA ROUTINE'
