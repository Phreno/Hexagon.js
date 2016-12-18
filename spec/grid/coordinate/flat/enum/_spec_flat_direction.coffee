describe "flat_direction", ->
  direction = require  "./flat_direction"
  it "doit pointer vers le nord", ->
    # when
    north = direction.north
    # then
    expected = priority: ( require "./flat_side" ).NORTH , x: 0, y: +1, z: -1
    expect( JSON.stringify north ).toBe( JSON.stringify expected )

  it "doit pointer vers le nord-est", ->
    # when
    northEast = direction.northEast
    # then
    expected = priority: ( require "./flat_side" ).NORTH_EAST , x: +1, y: 0, z: -1
    expect( JSON.stringify northEast ).toBe( JSON.stringify expected )

  it "doit pointer vers le nord-ouest", ->
    # when
    northWest = direction.northWest
    # then
    expected = priority: ( require "./flat_side" ).NORTH_WEST , x: -1, y: +1, z: 0
    expect( JSON.stringify northWest).toBe( JSON.stringify expected )

  it "doit pointer vers le sud", ->
    # when
    south = direction.south
    # then
    expected = priority: ( require "./flat_side" ).SOUTH , x: 0, y: -1, z: +1
    expect( JSON.stringify south ).toBe( JSON.stringify expected )

  it "doit pointer vers le sud-est", ->
    # when
    southEast = direction.southEast
    # then
    expected = priority: ( require "./flat_side" ).SOUTH_EAST , x: +1, y: -1, z: 0
    expect( JSON.stringify southEast ).toBe( JSON.stringify expected )

  it "doit pointer vers le sud-ouest", ->
    southWest = direction.southWest
    # then
    expected = priority: ( require "./flat_side" ).SOUTH_WEST , x: -1, y: 0, z: +1
    expect( JSON.stringify southWest).toBe( JSON.stringify expected )
