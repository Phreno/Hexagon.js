import * as GridCore from "./Grid.core"

export default function(canvas, settings){
  function draw(opts){
    settings=opts
    clearCanvas()
    drawGrid()
  }
  function clearCanvas(){
    getCanvasContext2D().clearRect(0, 0, getCanvasWidth(), getCanvasHeight())
  }
  function drawGrid(){
    for(let row=0;row<=settings.cellsPerCol;row++){
      for(let col=0;col<=settings.cellsPerRow;col++){
        drawHex(getHex(col, row))
      }
    }
  }
  function drawHex(hex){
    const isPrime = num => {
      for(let i = 2, s = Math.sqrt(num); i <= s; i++)
        if(num % i === 0) return false;
      return !!num && num !== 1 && num !== 0;
    }
    let corners=getHexCorners(hex)
    getCanvasContext2D().beginPath()
    corners.forEach((corner, index)=>{
      index?
        getCanvasContext2D().lineTo(corner.x, corner.y)
        : getCanvasContext2D().moveTo(corner.x, corner.y)
    })
    getCanvasContext2D().lineTo(corners[0].x, corners[0].y)

    isPrime(hex.index)?
      getCanvasContext2D().fill()
      :getCanvasContext2D().stroke()
  }
  function getHexCorners(hex){
    return GridCore
      .polygon_corners(getGridLayout(), hex)
      .map(el=>{return {x:el.x, y:el.y}})
  }
  function getCanvasContext2D(){
    return canvas.getContext("2d")
  }
  function getCanvasWidth(){
    return canvas.width
  }
  function getCanvasHeight(){
    return canvas.height
  }
  function getGridLayout(){
    return GridCore.Layout(
      settings.layoutOrientation, {
          x: canvas.width/settings.maxCellsPerRow,
          y:canvas.height/settings.maxCellsPerCol
      }, {x:10, y:10}
    )
  }
  function getHex(col, row){
    var rest=-1*(col+row)
    return GridCore.Hex(col, row, rest)
  }
  function getHexUnderPixel(pixel){
    return GridCore.pixel_to_hex(getGridLayout(), pixel)
  }

  return {
    draw,
    getHexUnderPixel
  }
}
