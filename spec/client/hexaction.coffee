#!/usr/bin/env coffee

# [K3rn€l_P4n1k] HEXACTION
#   Client console pour travailler avec des grilles hexagonales
#
# Requirements:
# - HTMLWriter

DEFAULT =
  rows:10
  cols:10
  radius:50
  outputFolder: "./"
  outputFile: "out.html"
  logFolder: "./"
  logFile: "client.log"
  verbosity: "silly"
  disposition: "oddq"

DEPENDENCY =
  HTMLWriter: require "../grid/graphic/flat/oddq/writer/html/HTMLWriter"
  OddqLayout: require "../grid/graphic/flat/oddq/layout/OddqLayout"
  Layout: undefined

VENDOR =
  program: require 'commander' # Parse les arguments du script
  winston: require 'winston'   # Loggeur

do init = ->
  VENDOR.program.version 'α.0.1'

  coercion =
    getLayout: (layoutName = DEFAULT.disposition) ->
      DEPENDENCY.Layout = DEPENDENCY.OddqLayout

  VENDOR.program.option(
    '-r, --rows [number]'
    , "(#{DEFAULT.rows}) Nombre de lignes de la grilles"
    , DEFAULT.rows)

  VENDOR.program.option(
    '-c, --columns [number]'
    , "(#{DEFAULT.cols}) Nombre de colonnes de la grilles"
    , DEFAULT.cols)

  VENDOR.program.option(
    '-d, --disposition [string]'
    , "(#{DEFAULT.disposition}) Disposition de la grille "
    + "(oddq, oddr, evenq, evenr)"
    , coercion.getLayout)

  VENDOR.program.option(
    '-r, --radius [number]'
    , "(#{DEFAULT.radius}) Distance vertex-centre"
    , DEFAULT.radius)

  VENDOR.program.option(
    '-lf, --logFile [string]'
    , "(#{DEFAULT.logFile}) Fichier de log"
    , DEFAULT.logFile)

  VENDOR.program.option(
    '-lF, --logFolder [string]'
    , "(#{DEFAULT.logFolder}) Dossier de log",
    DEFAULT.logFolder)

  VENDOR.program.option(
    '-o, --outputFile [string]'
    , "(#{DEFAULT.outputFile}) Fichier de sortie"
    , DEFAULT.outputFile)

  VENDOR.program.option(
    '-O, --outputFolder [string]'
    , "(#{DEFAULT.outputFolder}) Dossier de sortie"
    , DEFAULT.outputFolder)

  VENDOR.program.option(
    '-V, --verbosity [string]'
    , "(#{DEFAULT.verbosity}) Configure l\'intensite des log"
    , DEFAULT.verbosity)

  VENDOR.program.option(
    '-l, --log'
    , "(#{DEFAULT.verbose}) Affiche les logs (async) sur la sortie standard")

  VENDOR.program.option(
    '-h, --export-html'
    , "Persite la grille dans un fichier HTML")

VENDOR.program.parse process.argv

do displayLog = ->
  VENDOR.winston.level = VENDOR.program.verbosity
  VENDOR.winston.add VENDOR.winston.transports.File, {
    filename: "#{VENDOR.program.logFolder}/#{VENDOR.program.logFile}"
  }
  if !VENDOR.program.log
    VENDOR.winston.remove VENDOR.winston.transports.Console

do processing = ->
  layout = new DEPENDENCY.Layout VENDOR.program

  writer = new DEPENDENCY.HTMLWriter layout
  writer.sketchGrid

  file = "#{VENDOR.program.outputFolder}/#{VENDOR.program.outputFile}"
  VENDOR.winston.log 'info', "export processing to #{file}"
  writer.writeToFile file

VENDOR.winston.log 'info', 'FIN DE LA ROUTINE'
