// Hex math defined here: http://blog.ruslans.com/2011/02/hexagonal-grid-math.html

function HexagonGrid(canvasId, radius) {
    this.radius = radius;

    this.height = Math.sqrt(3) * radius;
    this.width = 2 * radius;
    this.side = (3 / 2) * radius;

    this.canvas = document.getElementById(canvasId);
    this.context = this.canvas.getContext('2d');

    this.canvasOriginX = 0;
    this.canvasOriginY = 0;
    
    this.canvas.addEventListener("mousedown", this.clickEvent.bind(this), false);
};

HexagonGrid.prototype.drawHexGrid = function (rows, cols, originX, originY, isDebug) {
    this.canvasOriginX = originX;
    this.canvasOriginY = originY;
    
    var currentHexX;
    var currentHexY;
    var debugText = "";

    var offsetColumn = false;

    for (var col = 0; col < cols; col++) {
        for (var row = 0; row < rows; row++) {

            if (!offsetColumn) {
                currentHexX = (col * this.side) + originX;
                currentHexY = (row * this.height) + originY;
            } else {
                currentHexX = col * this.side + originX;
                currentHexY = (row * this.height) + originY + (this.height * 0.5);
            }

            if (isDebug) {
                debugText = col + "," + row;
            }

            this.drawHex(currentHexX, currentHexY, "#ddd", debugText);
        }
        offsetColumn = !offsetColumn;
    }
};

HexagonGrid.prototype.drawHexAtColRow = function(column, row, color) {
    var drawy = column % 2 == 0 ? (row * this.height) + this.canvasOriginY : (row * this.height) + this.canvasOriginY + (this.height / 2);
    var drawx = (column * this.side) + this.canvasOriginX;

    this.drawHex(drawx, drawy, color, "");
};

HexagonGrid.prototype.drawHex = function(x0, y0, fillColor, debugText) {
    this.context.strokeStyle = "#000";
    this.context.beginPath();
    this.context.moveTo(x0 + this.width - this.side, y0);
    this.context.lineTo(x0 + this.side, y0);
    this.context.lineTo(x0 + this.width, y0 + (this.height / 2));
    this.context.lineTo(x0 + this.side, y0 + this.height);
    this.context.lineTo(x0 + this.width - this.side, y0 + this.height);
    this.context.lineTo(x0, y0 + (this.height / 2));

    if (fillColor) {
        this.context.fillStyle = fillColor;
        this.context.fill();
    }

    this.context.closePath();
    this.context.stroke();

    if (debugText) {
        this.context.font = "8px";
        this.context.fillStyle = "#000";
        this.context.fillText(debugText, x0 + (this.width / 2) - (this.width/4), y0 + (this.height - 5));
    }
};

//Recusivly step up to the body to calculate canvas offset.
HexagonGrid.prototype.getRelativeCanvasOffset = function() {
	var x = 0, y = 0;
	var layoutElement = this.canvas;
    if (layoutElement.offsetParent) {
        do {
            x += layoutElement.offsetLeft;
            y += layoutElement.offsetTop;
        } while (layoutElement = layoutElement.offsetParent);
        
        return { x: x, y: y };
    }
}

//Uses a grid overlay algorithm to determine hexagon location
//Left edge of grid has a test to acuratly determin correct hex
HexagonGrid.prototype.getSelectedTile = function(mouseX, mouseY) {

	var offSet = this.getRelativeCanvasOffset();

    mouseX -= offSet.x;
    mouseY -= offSet.y;

    var column = Math.floor((mouseX) / this.side);
    var row = Math.floor(
        column % 2 == 0
            ? Math.floor((mouseY) / this.height)
            : Math.floor(((mouseY + (this.height * 0.5)) / this.height)) - 1);


    //Test if on left side of frame            
    if (mouseX > (column * this.side) && mouseX < (column * this.side) + this.width - this.side) {


        //Now test which of the two triangles we are in 
        //Top left triangle points
        var p1 = new Object();
        p1.x = column * this.side;
        p1.y = column % 2 == 0
            ? row * this.height
            : (row * this.height) + (this.height / 2);

        var p2 = new Object();
        p2.x = p1.x;
        p2.y = p1.y + (this.height / 2);

        var p3 = new Object();
        p3.x = p1.x + this.width - this.side;
        p3.y = p1.y;

        var mousePoint = new Object();
        mousePoint.x = mouseX;
        mousePoint.y = mouseY;

        if (this.isPointInTriangle(mousePoint, p1, p2, p3)) {
            column--;

            if (column % 2 != 0) {
                row--;
            }
        }

        //Bottom left triangle points
        var p4 = new Object();
        p4 = p2;

        var p5 = new Object();
        p5.x = p4.x;
        p5.y = p4.y + (this.height / 2);

        var p6 = new Object();
        p6.x = p5.x + (this.width - this.side);
        p6.y = p5.y;

        if (this.isPointInTriangle(mousePoint, p4, p5, p6)) {
            column--;

            if (column % 2 == 0) {
                row++;
            }
        }
    }

    return  { row: row, column: column };
};


HexagonGrid.prototype.sign = function(p1, p2, p3) {
    return (p1.x - p3.x) * (p2.y - p3.y) - (p2.x - p3.x) * (p1.y - p3.y);
};

//TODO: Replace with optimized barycentric coordinate method
HexagonGrid.prototype.isPointInTriangle = function isPointInTriangle(pt, v1, v2, v3) {
    var b1, b2, b3;

    b1 = this.sign(pt, v1, v2) < 0.0;
    b2 = this.sign(pt, v2, v3) < 0.0;
    b3 = this.sign(pt, v3, v1) < 0.0;

    return ((b1 == b2) && (b2 == b3));
};

HexagonGrid.prototype.clickEvent = function (e) {
    var mouseX = e.pageX;
    var mouseY = e.pageY;

    var localX = mouseX - this.canvasOriginX;
    var localY = mouseY - this.canvasOriginY;

    var tile = this.getSelectedTile(localX, localY);
    if (tile.column >= 0 && tile.row >= 0) {
        var drawy = tile.column % 2 == 0 ? (tile.row * this.height) + this.canvasOriginY + 6 : (tile.row * this.height) + this.canvasOriginY + 6 + (this.height / 2);
        var drawx = (tile.column * this.side) + this.canvasOriginX;

        this.drawHex(drawx, drawy - 6, "rgba(110,110,70,0.3)", "");
    } 
};

/**
 * Designation des mouvements sur les axes.
 * */
move = {
    forward: +1,
    backward: -1,
    none: 0
}

/**
 * Definition des differents systemes de coordonnees.
 * */
HexagonGrid.prototype.coordinate = {
    /**
     * Systeme de coordonnee relatif au coin superieur gauche.
     * Utilise pour le trace.
     * Orientation: flat.
     * */
    oddQ: {
        /**
         * Converti des coordonnee odd-q en coordonnee cubique.
         * @oddq coordonnee a convertir.
         * */
        convertToCube: function convertToCube (oddq) {
            var x = oddq.col;
            var z = oddq.row - (oddq.col - (oddq.col&1)) / 2;
            var y = -x-z;
            return {
                x: x,
                z: z,
                y: y
            };
        }
    },

    /**
     * Systeme de coordonnee utilise pour le calcul.
     * */
    cube: {
        /**
         * Offset de deplacement lorsque l on se deplace vers ...
         * */
        direction: {
            southEast: {
                x: move.forward,
                y: move.backward,
                z: move.none
            }, northEast: {
                x: move.forward,
                y: move.none,
                z: move.backward
            }, north: {
                x: move.none,
                y: move.forward,
                z: move.backward
            }, northWest: {
                x: move.backward,
                y: move.forward,
                z: move.none
            }, southWest: {
                x: move.backward,
                y: move.none,
                z: move.forward
            }, south: {
                x: move.none,
                y: move.backward,
                z: move.forward
            },
        },
        /**
         * Converti des coordonnees cubiques en coordonnees odd-q.
         * @cube coordonnee a convertir.
         * */
        convertToOddQ: function convertToOddQ (cube) {
            var col = cube.x;
            var row = cube.z + (cube.x - (cube.x&1)) / 2;
            return {
                col: col,
                row: row
            }
        },
        /**
         * Converti des coordonnees cubiques en coordonnees axiale.
         * @cube coordonnee a convertir.
         * */
        convertToAxial: function convertToAxial (cube) {
            return {
                col: cube.x,
                row: cube.z
            }
        },
        /**
         * Recupere le cube adjacent dans la direction donnee.
         * @direction cote adjacent.
         * @cube cellule a partir de laquelle est effectue le pas de cote.
         * */
        stepAside: function stepAside (direction, cube) {
            return {
                x: cube.x + direction.x,
                y: cube.y + direction.y,
                z: cube.z + direction.z
            };
        },
        /**
         * Recupere les cases au voisinage.
         * @cube cellule dont on veut recuperer les cases voisines.
         * */
        getNeighborhood: function getNeighborhood (cube) {
            return [
                this.stepAside(this.direction.southEast, cube),
                this.stepAside(this.direction.northEast, cube),
                this.stepAside(this.direction.north, cube),
                this.stepAside(this.direction.northWest, cube),
                this.stepAside(this.direction.southWest, cube),
                this.stepAside(this.direction.south, cube)
            ];
        },
        /**
         * Recupere la case au voisinage dans la direction ...
         * @direction cote par lequel on recupere le voisin.
         * @cube cellule dont on veut recuperer le voisin.
         * */
        getNeighbor: function getNeighbor (direction, cube) {
            var neighbor = null;
                if("number" === typeof(direction)) neighbor = this.getNeighborhood(cube)[direction];
                else if("string" === typeof(direction)) neighbor = this.stepAside(this.direction[direction], cube);
                else if("object" === typeof(direction)) neighbor = this.stepAside(direction, cube);
                return neighbor;
        },
        /**
         * Recupere le chemin a partir d une case dans une direction.
         * @direction cote par lequel par le chemin.
         * @radius longueur du chemin.
         * @cube depart du chemin.
         * */
        follow: function follow (direction, radius, cube) {
            var path = [];
            path.push(cube);
            while(radius--) {
                cube = this.getNeighbor(cube, direction);
                path.push(cube);
            }
            return path;
        }
    },
    /*  */
    axial: {
        /**
         * Converti une coordonnee axiale en coordonnee cubique.
         * @axial coordonnees axiales de la cellule.
         * */
        convertToCube: function convertToCube(axial) {
            var x = axial.col;
            var z = axial.row;
            var y = -x-z;
            return {
                x: x,
                z: z,
                y: y
            };
        }
    }
}

/**
 * Recupere un anneau.
 * @center le center de l anneau.
 * @radius la taille du rayon.
 * */
HexagonGrid.prototype.getRing = function cubeRing(center, radius) {
    var direction = this.coordinate.cube.direction;
    var cube = this.coordinate.cube.follow(direction.southWest, radius, center).pop();
    var result = [];
    for (var side = 0; side < 6; side++) {
        for (var offset = 0; offset < radius; offset++) {
            result.push(cube);
            cube = this.coordinate.cube.getNeighbor(side, cube);
        }
    }
    result = result.map(this.coordinate.cube.convertToOddQ);
    return result;
}

/**
 * Redessine un set de cellules.
 * @cells toutes les cellules a tracer.
 * */
HexagonGrid.prototype.drawCells = function drawCells (cells) {
    for(var index = 0; index < cells.length; index++) {
        this.drawHexAtColRow(cells[index].col, cells[index].row, "#000");
    };
}
