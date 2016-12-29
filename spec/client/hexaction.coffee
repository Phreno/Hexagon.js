#!/usr/bin/env coffee

program = require "commander"

program.version "α.0.1"
program.option "-x, --export", "exporte la grille dans le dossier out"
program.parse process.argv

# Export de la grille au format png

if program.export
  # Attribution des valeurs
  # TODO: placer ces valeur en configuration
  console.log "export grid"
  CANVAS_WIDTH  = 200
  CANVAS_HEIGHT = 200
  OUTPUT_FILE   = "out.html"

  Canvas = require "canvas"
  Writer = require "../grid/graphic/flat/oddq/writer/html/HTMLWriter"
  Layout = require "../grid/graphic/flat/oddq/layout/OddqLayout"

  canvas = new Canvas CANVAS_WIDTH, CANVAS_HEIGHT
  console.log canvas.width
  layout = new Layout
  writer = new Writer layout, canvas

  writer.writeToFile OUTPUT_FILE
