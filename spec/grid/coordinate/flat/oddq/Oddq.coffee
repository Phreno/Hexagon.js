Manager = require "../Manager.coffee"
# Systeme de coordonnees oddq appliqué.
class Oddq extends Manager
  # Est-ce que la cellule se situe sur une colone soumise a un decalage ?
  #
  # @param oddq [object] coordonnees de la cellule.
  # @param oddq.column [int] index de la colonne.
  # @param oddq.row [int] index de la ligne.
  # @return [boolean] vrai si la cellule est sur une colone paire.
  isShifted: ( oddq )-> isShifted = ( oddq.column % 2 is 0 )
module.exports = Oddq
