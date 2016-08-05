Coordinate = require "../src/coordinate.coffee"

describe "Coordinate", ->
  coordinate = null
  beforeEach ->
    # given
    coordinate = new Coordinate

  describe "cubic", ->
    describe "pointTo", ->
      describe "flat", ->
        north = null
        south = null
        beforeEach ->
          # given
          north = coordinate.cubic.pointTo.flat.north
          south = coordinate.cubic.pointTo.flat.south
        it "doit pointer vers le nord", ->
          # then
          expect( north.x ).toBe 0
          expect( north.y ).toBe +1
          expect( north.z ).toBe -1
        it "doit pointer vers le nord-est", ->
          # then
          expect( north.east.x ).toBe +1
          expect( north.east.y ).toBe +0
          expect( north.east.z ).toBe -1
        it "doit pointer vers le nord-ouest", ->
          # then
          expect( north.west.x ).toBe -1
          expect( north.west.y ).toBe +1
          expect( north.west.z ).toBe +0

        it "doit pointer vers le sud", ->
          # then
          expect( south.x ).toBe +0
          expect( south.y ).toBe -1
          expect( south.z ).toBe +1
        it "doit pointer vers le sud-est", ->
          # then
          expect( south.east.x ).toBe +1
          expect( south.east.y ).toBe -1
          expect( south.east.z ).toBe +0
        it "doit pointer vers le sud-ouest", ->
          # then
          expect( south.west.x ).toBe -1
          expect( south.west.y ).toBe +0
          expect( south.west.z ).toBe +1

    #describe "toOddq", ->
    # it "doit convertir des coordonnees cubic en coordonnees oddq."

  describe "oddq", ->
    describe "toCubic", ->
      it "doit convertir des coordonnees odd-q en coordonnees cubiques", ->
        # given
        coord =
          col: 10
          row: 5
        # when
        cubic = coordinate.oddq.toCubic coord
        # then
        expect( cubic.x ).toBe 10
        expect( cubic.y ).toBe -10
        expect( cubic.z ).toBe 0
