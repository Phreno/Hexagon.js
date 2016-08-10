(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);var f=new Error("Cannot find module '"+o+"'");throw f.code="MODULE_NOT_FOUND",f}var l=n[o]={exports:{}};t[o][0].call(l.exports,function(e){var n=t[o][1][e];return s(n?n:e)},l,l.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var CubicCoordinateManager, OddqCoordinateManager, cursor;

cursor = {
  forward: +1,
  backward: -1,
  position: 0
};

CubicCoordinateManager = (function() {
  function CubicCoordinateManager() {}

  CubicCoordinateManager.prototype.offset = {
    north: {
      x: cursor.position,
      y: cursor.forward,
      z: cursor.backward,
      east: {
        x: cursor.forward,
        y: cursor.position,
        z: cursor.backward
      },
      west: {
        x: cursor.backward,
        y: cursor.forward,
        z: cursor.position
      }
    },
    south: {
      x: cursor.position,
      y: cursor.backward,
      z: cursor.forward,
      east: {
        x: cursor.forward,
        y: cursor.backward,
        z: cursor.position
      },
      west: {
        x: cursor.backward,
        y: cursor.position,
        z: cursor.forward
      }
    }
  };

  CubicCoordinateManager.prototype.toOddq = function(coord) {
    var col, oddq, row;
    col = coord.x;
    row = coord.z + (coord.x - (coord.x & 1)) / 2;
    return oddq = {
      col: col,
      row: row
    };
  };

  CubicCoordinateManager.prototype.stepAside = function(offset, coord) {
    var side;
    return side = {
      x: offset.x + coord.x,
      y: offset.y + coord.y,
      z: offset.z + coord.z
    };
  };

  CubicCoordinateManager.prototype.getNeighborhood = function(coord) {
    var neighbors;
    return neighbors = [this.stepAside(this.offset.south.east, coord), this.stepAside(this.offset.north.east, coord), this.stepAside(this.offset.north, coord), this.stepAside(this.offset.north.west, coord), this.stepAside(this.offset.south.west, coord), this.stepAside(this.offset.south, coord)];
  };

  CubicCoordinateManager.prototype.getNeighbor = function(direction, coord) {
    var neighbor;
    neighbor = null;
    switch (typeof direction) {
      case "number":
        neighbor = (this.getNeighborhood(coord))[direction];
        break;
      case "object":
        neighbor = this.stepAside(direction, coord);
        break;
      default:
        console.log("err");
    }
    return neighbor;
  };

  CubicCoordinateManager.prototype.follow = function(direction, steps, origin) {
    var coord, path;
    path = [];
    while (steps--) {
      coord = this.getNeighbor(direction, origin);
      path.push(coord);
    }
    return path;
  };

  return CubicCoordinateManager;

})();

OddqCoordinateManager = (function() {
  function OddqCoordinateManager() {}

  OddqCoordinateManager.prototype.toCubic = function(coord) {
    var cubic, x, y, z;
    x = coord.col;
    z = coord.row - (coord.col - (coord.col & 1)) / 2;
    y = -x - z;
    return cubic = {
      x: x,
      z: z,
      y: y
    };
  };

  return OddqCoordinateManager;

})();

},{}]},{},[1]);
