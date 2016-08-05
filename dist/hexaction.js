/*
hexaction by K3rnelP4n1k :
* https://github.com/Phreno
* https://twitter.com/Phreno
Version: 0.0.1
Forked from https://github.com/rrreese/Hexagon.js
Full source at git+https://github.com/Phreno/hexaction.git
ISC License

Copyright (c) 2016, K3rnel P4n1k

Permission to use, copy, modify, and/or distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

*/
(function() {
  var Coordinate, cursor;

  cursor = {
    forward: +1,
    backward: -1,
    position: 0
  };

  Coordinate = (function() {
    function Coordinate() {}

    Coordinate.prototype.cubic = {
      pointTo: {
        flat: {
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
        }
      }
    };

    Coordinate.prototype.oddq = {
      toCubic: function(coord) {
        var cubic, x, y, z;
        x = coord.col;
        z = coord.row - (coord.col - (coord.col & 1)) / 2;
        y = -x - z;
        return cubic = {
          x: x,
          z: z,
          y: y
        };
      }
    };

    return Coordinate;

  })();

  module.exports = coordinate;

}).call(this);
