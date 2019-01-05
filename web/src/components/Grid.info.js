export default function(gridManager){
  let COORDINATE_SEPARATOR='; '
  function getPixelCoordinate(pixel){
    return `( ${[
      pixel.x,
      pixel.y
    ].join(COORDINATE_SEPARATOR)} )`
  }
  function getHexCoordinate(hex){
    return `( ${[
      hex.q,
      hex.r,
      hex.s
    ].join(COORDINATE_SEPARATOR)} )`
  }
  function getEventReport(event){
    let pixel=event?gridManager.getPixelFromEvent(event):undefined
    let hex=pixel?gridManager.getHexUnderPixel(pixel):undefined
    return hex ? [
        event.type,
        getPixelCoordinate(pixel),
        getHexCoordinate(hex)].join('\t')
      : undefined
  }
  return {
    getPixelCoordinate,
    getHexCoordinate,
    getEventReport
  }
}
