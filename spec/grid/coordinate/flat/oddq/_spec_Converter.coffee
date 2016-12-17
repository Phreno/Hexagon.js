Converter = require "./Converter"

describe "Converter", ->
  converter = new Converter

  describe "cubicToOddq", ->
    it "doit convertir des coordonnees cubic en coordonnees oddq", ->
      # given
      cubic = x: 10, y: -10, z: 0
      # when
      oddq = converter.cubicToOddq cubic
      # then
      expected = col:10, row: 5
      expect( JSON.stringify oddq ).toBe( JSON.stringify expected )

  describe "oddqToCubic", ->
    it "doit convertir des coordonnees oddq en coordonnees cubic", ->
      # given
      oddq = col: 10, row: 5
      # when
      cubic = converter.oddqToCubic oddq
      # then
      expected = x:10, y:-10, z:0
      expect( JSON.stringify cubic ).toBe JSON.stringify expected
