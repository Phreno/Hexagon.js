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
            <v-flex xs12 sm6 md3 v-if="displayableMousePosition">
              <v-text-field
                label="mouse"
                :value="displayableMousePosition"
                  outline
              ></v-text-field>
            </v-flex> 
            <v-flex xs12 sm6 md3 v-if="displayableHexCoordinate">
              <v-text-field
                label="hexagon"
                :value="displayableHexCoordinate"
                  outline
              ></v-text-field>
            </v-flex>   
          </v-card-actions>
          
          <v-card-actions>
            <v-flex xs12 sm6 md3 v-if="displayableLastActionReport">
              <v-text-field
                label="last action"
                :value="displayableLastActionReport"
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
      moveEvent:new MouseEvent("move", {
        bubbles: true,
        cancelable: true,
        view: window
      })
    },
    actions: []
  }),
  mounted(){
    this.canvas.container=document.getElementById(this.canvas.ID)
    this.gridManager=GridManager(this.canvas.container, this.settings)
    this.gridInfo=GridInfo(this.gridManager)
    this.trackMouse()
    // setInterval(this.loop,this.loopIntervalDuration)
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
    hexUnderMouse(){
      var hex=undefined
      if (
        this.pixelUnderMouse
        && this.gridManager
      ){
        hex=this
          .gridManager
          .getHexUnderPixel(this.pixelUnderMouse)
        hex.color='blue'
        this.gridManager.drawHex(hex)
      }
      return hex
    },
    displayableMousePosition(){
      return (
        this.gridInfo 
        && this.pixelUnderMouse
        && undefined!==this.pixelUnderMouse.x 
        && undefined!==this.pixelUnderMouse.y
      ) ? this.gridInfo.getPixelCoordinate(this.pixelUnderMouse)
        : undefined
    },
    displayableHexCoordinate(){
      return (
        this.gridInfo
        && this.hexUnderMouse
      ) ? this.gridInfo.getHexCoordinate(this.hexUnderMouse)
        : undefined
    },
    displayableLastActionReport(){
      return (
        this.gridInfo
        && this.lastAction
      )
        ? this.gridInfo.getEventReport(this.lastAction)
        : undefined
    },
    pixelUnderMouse(){
      return (
        this.gridManager
        && this.mouse
        && this.mouse.moveEvent
      )
        ? this.gridManager.getPixelFromEvent(this.mouse.moveEvent)
        : undefined
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
    loopIntervalDuration(){
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
      this.loopInterval=setInterval(this.loop, this.loopIntervalDuration)
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
    onMouseClick(event){
      this.trackAction(event)
      this.draw()
    },
    onMouseMove(event){
      this.mouse.moveEvent=event
    },
  }
} 
</script>

<style scoped></style>
