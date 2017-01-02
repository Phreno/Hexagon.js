#!/usr/bin/env coffee

program = require 'commander'
program.version 'α.0.1'
program.option '-v, --verbose','affiche les logs (async) sur la sortie standard'
program.option '-h, --export-html', 'persite la grille dans un fichier HTML'

program.parse process.argv

winston = require 'winston'
winston.level = 'silly'
winston.add winston.transports.File, {
  filename: "#{process.env.HEXACTION_LOG}/client.log"
}

do displayLog = ->
  if !program.verbose
    winston.remove winston.transports.Console

option = {
  rows: do -> program.rows ?= 10,
  columns: 10
}

do sketchCanvas = ->
  Writer = require "../grid/graphic/flat/oddq/writer/html/HTMLWriter"
  writer = new Writer
  writer.sketchGrid option

do exportToHtmlFile = ->
  writer.writeToFile "#{process.env.HEXACTION_OUT}/out.html"

winston.log 'info', 'FIN DE LA ROUTINE'
