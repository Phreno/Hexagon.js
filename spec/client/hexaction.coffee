#!/usr/bin/env coffee

program = require 'commander'
program.version 'α.0.1'
program.option '-x, --export', 'exporte la grille dans le dossier out'
program.parse process.argv

winston = require 'winston'
winston.level = 'silly'
winston.add winston.transports.File, {
  filename: "#{process.env.HEXACTION_LOG}/client.log"
}
# winston.remove winston.transports.Console

# Export de la grille au format png

if program.export
  # Attribution des valeurs
  # TODO: placer ces valeur en configuration
  CANVAS_WIDTH  = 200
  CANVAS_HEIGHT = 200
  OUTPUT_FILE   = "out.html"

  Canvas = require "canvas"
  Writer = require "../grid/graphic/flat/oddq/writer/html/HTMLWriter"
  Layout = require "../grid/graphic/flat/oddq/layout/OddqLayout"

  canvas = new Canvas CANVAS_WIDTH, CANVAS_HEIGHT
  canvasContext = canvas.getContext '2d'
  canvasContext.strokeStyle = 'rgba(0,0,0,0.5)'

  layout = new Layout
  writer = new Writer layout, canvas

  writer.writeToFile OUTPUT_FILE
