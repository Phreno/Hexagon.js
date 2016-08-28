Manager = require "./Manager.coffee"

describe "Manager", ->
  manager = new Manager

  describe "stepAside", ->
    it "doit ajouter a la coordonnee l'offset passe en parametre", ->
      # given
      coord  = x: 1, y: 2, z: 3
      offset = x: 2, y: 3, z: 4
      # when
      step = manager.stepAside offset, coord
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
        x: offset.southWest.x
        y: offset.southWest.y
        z: offset.southWest.z
      expected.push
        x: offset.northWest.x
        y: offset.northWest.y
        z: offset.northWest.z
      expected.push
        x: offset.north.x
        y: offset.north.y
        z: offset.north.z
      expected.push
        x: offset.northEast.x
        y: offset.northEast.y
        z: offset.northEast.z
      expected.push
        x: offset.southEast.x
        y: offset.southEast.y
        z: offset.southEast.z
      expected.push
        x: offset.south.x
        y: offset.south.y
        z: offset.south.z
      expect( JSON.stringify neighborhood ).toBe JSON.stringify expected

  describe "follow", ->
    origin = x: 0, y: 0, z: 0
    steps = 5
    it "doit recuperer une ligne de cellule en direction du sud-ouest", ->
      # given
      direction = manager.offset.southEast.priority
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
