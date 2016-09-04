Manager = require "./Manager.coffee"

describe "Manager", ->
  manager = new Manager

  describe "walk", ->
    it "doit ajouter a la coordonnee l'offset passe en parametre", ->
      # given
      coord  = x: 1, y: 2, z: 3
      offset = x: 2, y: 3, z: 4
      # when
      step = manager.walk offset, coord
      # then
      expected = x: ( 1 + 2 ), y: ( 2 + 3 ), z: ( 3 + 4 )
      expect( JSON.stringify step ).toBe( JSON.stringify expected )

  describe "getNeighborhood", ->
    it "doit recuperer la liste des cellules voisines", ->
      # given
      origin = x: 0, y: 0, z:0
      # when
      neighborhood = manager.getNeighborhood origin
      offset = manager.offset
      # then
      expected = []
      expected.push
        x: offset.SOUTH_WEST.x
        y: offset.SOUTH_WEST.y
        z: offset.SOUTH_WEST.z
      expected.push
        x: offset.NORTH_WEST.x
        y: offset.NORTH_WEST.y
        z: offset.NORTH_WEST.z
      expected.push
        x: offset.NORTH.x
        y: offset.NORTH.y
        z: offset.NORTH.z
      expected.push
        x: offset.NORTH_EAST.x
        y: offset.NORTH_EAST.y
        z: offset.NORTH_EAST.z
      expected.push
        x: offset.SOUTH_EAST.x
        y: offset.SOUTH_EAST.y
        z: offset.SOUTH_EAST.z
      expected.push
        x: offset.SOUTH.x
        y: offset.SOUTH.y
        z: offset.SOUTH.z
      expect( JSON.stringify neighborhood ).toBe JSON.stringify expected

  describe "follow", ->
    origin = x: 0, y: 0, z: 0
    steps = 5
    it "doit recuperer une ligne de cellule en direction du sud-ouest", ->
      # given
      direction = manager.offset.SOUTH_EAST.priority
      # when
      path = manager.follow( direction, steps, origin )
      # then
      expected = [
        ( x:1, y:-1, z:0 )
        ( x:2, y:-2, z:0 )
        ( x:3, y:-3, z:0 )
        ( x:4, y:-4, z:0 )
        ( x:5, y:-5, z:0 )
      ]
      expect( JSON.stringify path ).toBe JSON.stringify expected
