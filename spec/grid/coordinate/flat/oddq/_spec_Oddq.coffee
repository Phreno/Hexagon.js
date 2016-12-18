Oddq = require "./Oddq"

describe "Oddq", ->
  oddq = new Oddq
  describe "isShifted", ->
    it "doit etre decaler si la colonne est paire", ->
      expect( oddq.isShifted { column: 2 } ).toBe true

    it "ne doit pas etre decaler si la colonne est impaire", ->
      expect( oddq.isShifted { column: 3 } ).toBe false

