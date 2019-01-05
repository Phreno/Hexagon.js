<template>
  <v-container id="grid-main-container">
    <v-layout row>
    <v-flex xs12 sm6 offset-sm3>
        <v-card>
          <canvas id="grid-drawer"
            :width="canvas.width"
            :height="canvas.height"></canvas>
          <v-card-title primary-title>
            <div>
              <div class="headline" v-text="title"></div>
            </div>
          </v-card-title>

          <v-card-actions>
            <v-btn 
              color="success" 
              v-if="!loopInterval"
              @click="startLoop">
            start loop
            </v-btn>
            <v-spacer></v-spacer>
            <v-btn color="error" 
              v-if="loopInterval"
              @click="endLoop">
              end loop
            </v-btn>
          </v-card-actions>

          <v-card-actions>
            <v-flex xs12 sm6 md3 v-if="mousePosition">
              <v-text-field
                label="mouse"
                :value="mousePosition"
                  outline
              ></v-text-field>
            </v-flex> 
            <v-flex xs12 sm6 md3 v-if="hexPosition">
              <v-text-field
                label="hexagon"
                :value="hexPosition"
                  outline
              ></v-text-field>
            </v-flex>   
          </v-card-actions>
          
          <v-card-actions>
            <v-flex xs12 sm6 md3 v-if="lastActionReport">
              <v-text-field
                label="last action"
                :value="lastActionReport"
                  outline
              ></v-text-field>
            </v-flex> 
          </v-card-actions>

          <v-card-actions>
            <v-spacer></v-spacer>
            <v-tooltip left>
              <v-btn slot="activator" icon @click="showSettings = !showSettings">
                <v-icon>{{ 
                  showSettings ? 
                    'keyboard_arrow_up' : 'keyboard_arrow_down' 
                }}</v-icon>
              </v-btn>
              <span v-text="title"></span>
            </v-tooltip>
          </v-card-actions>
  
          <v-slide-y-transition>
            <v-card v-show="showSettings">
              <v-flex xs12>
                <v-slider 
                  :min="settings.minCellsPerRow"
                  :max="settings.maxCellsPerRow" 
                  v-model="settings.cellsPerRow"></v-slider>
              </v-flex>
              <v-flex xs12>
                <v-slider 
                  :min="settings.minCellsPerCol"
                  :max="settings.maxCellsPerCol" 
                  v-model="settings.cellsPerCol"></v-slider>
              </v-flex>
            </v-card>
          </v-slide-y-transition>

        </v-card>
      </v-flex>
    </v-layout>

  </v-container>
</template>

<script>
import GridManager from "./Grid.manager"
import GridInfo from "./Grid.info"
import {
  layout_pointy,
  layout_flat
} from "./Grid.core"
export default {
  data: ()=>({
    gridManager: undefined,
    gridInfo: undefined,
    showSettings: false,
    title: "hexaction",
    loopInterval: undefined,
    settings: {
      framePerSecond: 25,
      layoutOrientation: layout_flat,
      maxCellsPerRow: 30,
      minCellsPerRow: 1,
      maxCellsPerCol: 30,
      minCellsPerCol: 1,
      cellsPerRow: 10,
      cellsPerCol: 10
    },
    canvas:{
      container: undefined,
      ID:"grid-drawer",
      width: 200,
      height: 200,
    },
    mouse:{
      coordinate: {
        cube: {
          q: 0,
          r: 0,
          s: 0
        } 
      },
      position:{
        x: 0,
        y: 0
      }
    },
    actions: []
  }),
  mounted(){
    this.setCanvas()
    this.setGridManager()
    this.setGridInfo(this.gridManager)
    this.trackMouse()
    // setInterval(this.loop,this.frameInterval)
  },
  watch:{
    "settings.cellsPerCol"(){
      this.draw()
    },
    "settings.cellsPerRow"(){
      this.draw()
    }
  },
  computed: {
    mousePosition(){
      return (
        this.gridInfo 
        && undefined!==this.mouse.position.x 
        && undefined!==this.mouse.position.y
      ) ? this.gridInfo.getPixelCoordinate(this.mouse.position)
        : undefined
    },
    hexPosition(){
      return (
        this.gridInfo
        && undefined!==this.mouse.coordinate.cube.q
        && undefined!==this.mouse.coordinate.cube.r
        && undefined!==this.mouse.coordinate.cube.s
      ) ? this.gridInfo.getHexCoordinate(this.mouse.coordinate.cube)
        : undefined
    },
    lastActionReport(){
      return (
        this.gridInfo
        && this.lastAction
      )
        ? this.gridInfo.getEventReport(this.lastAction)
        : undefined
    },
    lastAction(){
      return (
        this.actions
        && this.actions[this.actions.length-1]
      )
        ? this.actions[this.actions.length-1]
        : undefined
    },
    hexActions(){
      return this.actions
    },
    frameInterval(){
      return (
        this.settings
        && this.settings.framePerSecond
      )
        ? 1000/this.settings.framePerSecond
        : undefined
    }
  },
  methods: {
    startLoop(){
      this.loopInterval=setInterval(this.loop, this.frameInterval)
    },
    endLoop(){
      clearInterval(this.loopInterval)
      this.loopInterval=undefined
    },
    loop(){
      this.draw()
    },
    trackMouse(){
      if(
        this.canvas
        && this.canvas.container
      ){
        this.canvas.container.addEventListener('mousemove', this.onMouseMove)
        this.canvas.container.addEventListener('click', this.onMouseClick)
      } else {
        console.error("err: lors de la récupération de la zone de dessin")
      }
    },
    trackAction(event){
      this.actions.push(event)
    },
    draw(){
      this.gridManager.draw(this.settings)
      this.drawLastAction()
    },
    drawLastAction(){
      if(this.lastAction) {
        let hex=this.gridManager.getHexFromEvent(this.lastAction)
        this.highlightHex(hex)
        this.gridManager.drawHex(hex)
      } 
    },
    highlightHex(hex){
      hex.index=2
    },
    setGridManager(){
      this.gridManager=GridManager(this.canvas.container, this.settings)
    },
    onMouseClick(event){
      console.log(event)
      this.trackAction(event)
      this.draw()
    },
    onMouseMove(event){
      this.setMousePosition(event)
      this.setHexUnderMousePosition()
    },
    setCanvas(){
      this.canvas.container=document.getElementById(this.canvas.ID)
    },
    setMousePosition(event){
      this.mouse.position=this.gridManager.getPixelFromEvent(event)
    },
    setHexUnderMousePosition(){
      this.mouse.coordinate.cube=this
        .gridManager
        .getHexUnderPixel(this.mouse.position)
    },
    setGridInfo(){
      this.gridInfo=GridInfo(this.gridManager)
    }
  }
} 
</script>

<style scoped></style>
