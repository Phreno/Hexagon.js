export default function(){
  function cubeToAxial(cube){
    let q=cube.x
    let r=cube.z
    return GridCore.Hex(q, r)
  }
  function axialToCube(hex){
    let x=hex.q
    let z=hex.r
    let y=-x-z
    return Cube(x, y, z)
  }
  return {

  }
}
