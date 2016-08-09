base = "../".repeat 3
Manager = require "#{base}src/coordinate/flat/CubicCoordinateManager.coffee"

describe "(flat) CubicCoordinateManager", ->
  manager = new Manager

  describe "offset", ->

    it "doit pointer vers le nord", ->
      # then
      expect( manager.offset.north.x ).toBe 0
      expect( manager.offset.north.y ).toBe +1
      expect( manager.offset.north.z ).toBe -1

    it "doit pointer vers le nord-est", ->
      # then
      expect( manager.offset.north.east.x ).toBe +1
      expect( manager.offset.north.east.y ).toBe +0
      expect( manager.offset.north.east.z ).toBe -1

    it "doit pointer vers le nord-ouest", ->
      # then
      expect( manager.offset.north.west.x ).toBe -1
      expect( manager.offset.north.west.y ).toBe +1
      expect( manager.offset.north.west.z ).toBe +0

    it "doit pointer vers le sud", ->
      # then
      expect( manager.offset.south.x ).toBe +0
      expect( manager.offset.south.y ).toBe -1
      expect( manager.offset.south.z ).toBe +1

    it "doit pointer vers le sud-est", ->
      # then
      expect( manager.offset.south.east.x ).toBe +1
      expect( manager.offset.south.east.y ).toBe -1
      expect( manager.offset.south.east.z ).toBe +0

    it "doit pointer vers le sud-ouest", ->
      # then
      expect( manager.offset.south.west.x ).toBe -1
      expect( manager.offset.south.west.y ).toBe +0
      expect( manager.offset.south.west.z ).toBe +1

  describe "toOddq", ->
    it "doit convertir des coordonnees cubic en coordonnees oddq", ->
      # given
      coord =
        x: 10
        y: -10
        z: 0
      # when
      oddq = manager.toOddq coord
      # then
      expect( oddq.col ).toBe 10
      expect( oddq.row ).toBe 5
