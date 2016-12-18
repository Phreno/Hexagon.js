Manager = require "./FlatManager.coffee"

describe "FlatManager", ->
  # object a tester
  manager = new Manager

  # dépendance
  directions = require "../enum/flat_direction"

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
        x: directions.southWest.x
        y: directions.southWest.y
        z: directions.southWest.z
      expected.push
        x: directions.northWest.x
        y: directions.northWest.y
        z: directions.northWest.z
      expected.push
        x: directions.north.x
        y: directions.north.y
        z: directions.north.z
      expected.push
        x: directions.northEast.x
        y: directions.northEast.y
        z: directions.northEast.z
      expected.push
        x: directions.southEast.x
        y: directions.southEast.y
        z: directions.southEast.z
      expected.push
        x: directions.south.x
        y: directions.south.y
        z: directions.south.z

      expect( JSON.stringify neighborhood ).toBe JSON.stringify expected

  describe "follow", ->
    origin = x: 0, y: 0, z: 0
    steps = 5

    it "doit recuperer une ligne de cellule en direction du sud-ouest", ->
      # given
      direction = directions.southWest.priority
      # when
      path = manager.follow( direction, steps, origin )
      # then
      expected = [
        ( x:-1, y:0, z:+1 )
        ( x:-2, y:0, z:+2 )
        ( x:-3, y:0, z:+3 )
        ( x:-4, y:0, z:+4 )
        ( x:-5, y:0, z:+5 )
      ]
      expect( JSON.stringify path ).toBe JSON.stringify expected

    it "doit recuperer une ligne de cellule en direction du nord-ouest", ->
      # given
      direction = directions.northWest.priority
      # when
      path = manager.follow( direction, steps, origin )
      # then
      expected = [
        ( x:-1, y:+1, z:0 ),
        ( x:-2, y:+2, z:0 ),
        ( x:-3, y:+3, z:0 ),
        ( x:-4, y:+4, z:0 ),
        ( x:-5, y:+5, z:0 ),
      ]
      expect( JSON.stringify path ).toBe JSON.stringify expected

    it "doit recuperer une ligne de cellule en direction du nord", ->
      direction = directions.north.priority
      path = manager.follow( direction, steps, origin )
      expected = [
        ( x:0, y:+1, z:-1 ),
        ( x:0, y:+2, z:-2 ),
        ( x:0, y:+3, z:-3 ),
        ( x:0, y:+4, z:-4 ),
        ( x:0, y:+5, z:-5 ),
      ]
      expect( JSON.stringify path ).toBe JSON.stringify expected

    it "doit recuperer une ligne de cellule en direction du nord-est", ->
      direction = directions.northEast.priority
      path = manager.follow( direction, steps, origin )
      expected = [
        ( x:+1, y:0, z:-1 ),
        ( x:+2, y:0, z:-2 ),
        ( x:+3, y:0, z:-3 ),
        ( x:+4, y:0, z:-4 ),
        ( x:+5, y:0, z:-5 ),
      ]
      expect( JSON.stringify path ).toBe JSON.stringify expected

    it "doit recuperer une ligne de cellule en direction du sud-est", ->
      direction = directions.southEast.priority
      path = manager.follow( direction, steps, origin )
      expected = [
        ( x:+1, y:-1, z:0 ),
        ( x:+2, y:-2, z:0 ),
        ( x:+3, y:-3, z:0 ),
        ( x:+4, y:-4, z:0 ),
        ( x:+5, y:-5, z:0 ),
      ]
      expect( JSON.stringify path ).toBe JSON.stringify expected

    it "doit recuperer une ligne de cellule en direction du sud", ->
      direction = directions.south.priority
      path = manager.follow( direction, steps, origin )
      expected = [
        ( x:0, y:-1, z:+1 ),
        ( x:0, y:-2, z:+2 ),
        ( x:0, y:-3, z:+3 ),
        ( x:0, y:-4, z:+4 ),
        ( x:0, y:-5, z:+5 ),
      ]
      expect( JSON.stringify path ).toBe JSON.stringify expected


