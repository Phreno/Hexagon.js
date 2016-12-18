describe "flat_side", ->
  side = require "./flat_side"
  describe "south west", ->
    it "doit etre egal a 0", -> expect( side.SOUTH_WEST ).toBe 0

  describe "north west", ->
    it "doit etre egal a 1", -> expect( side.NORTH_WEST ).toBe 1

  describe "north", ->
    it "doit etre egal a 2", -> expect( side.NORTH ).toBe 2

  describe "north east", ->
    it "doit etre egal a 3", -> expect( side.NORTH_EAST ).toBe 3

  describe "south east", ->
    it "doit etre egal a 4", -> expect( side.SOUTH_EAST ).toBe 4

  describe "south", ->
    it "doit etre egal a 5", -> expect( side.SOUTH ).toBe 5
