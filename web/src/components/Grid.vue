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
            <v-flex xs12 sm6 md3>
              <v-text-field
                label="mouse"
                :value="mousePosition"
                  outline
              ></v-text-field>
            </v-flex> 
            <v-flex xs12 sm6 md3
                v-if="mouse.coordinate && mouse.coordinate.cube">
              <v-text-field
                label="hexagon"
                :value="hexPosition"
                  outline
              ></v-text-field>
            </v-flex> 
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
import {
  layout_pointy,
  layout_flat
} from "./Grid.core"
export default {
  data: ()=>({
    gridManager: undefined,
    showSettings: false,
    title: "hexaction",
    settings: {
      layoutOrientation: layout_flat,
      maxCellsPerRow: 100,
      minCellsPerRow: 1,
      maxCellsPerCol: 100,
      minCellsPerCol: 1,
      cellsPerRow: 25,
      cellsPerCol: 10
    },
    canvas:{
      ID:"grid-drawer",
      width: 500,
      height: 500,
    },
    mouse:{
      coordinate: {
        cube: {
          q: undefined,
          r: undefined,
          s: undefined
        } 
      },
      position:{
        x: undefined,
        y: undefined
      }
    },
    actions: []
  }),
  mounted(){
    this.trackMouse()
    this.setGridManager()
    this.draw()
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
      return [
        this.mouse.position.x,
        this.mouse.position.y
      ].join(':')
    },
    hexPosition(){
      return [
        this.mouse.coordinate.cube.q,
        this.mouse.coordinate.cube.r,
        this.mouse.coordinate.cube.s
      ].join(':')
    },
  },
  methods: {
    trackMouse(){
      this.getCanvas().addEventListener('mousemove', this.onMouseMove)
      this.getCanvas().addEventListener('click', this.onMouseClick)
    },
    draw(){
      this.getGridManager().draw(this.settings)
    },
    getCanvas(){
      return document.getElementById(this.canvas.ID)
    },
    getBoundingClientRect(){
      return this.getCanvas().getBoundingClientRect()
    },
    setGridManager(){
      this.gridManager=new GridManager(this.getCanvas())
    },
    getGridManager(){
      return this.gridManager
    },
    onMouseClick(event){
      console.log("click :)")
      let pixel=this.sanitizeMousePosition(event)
      let hex=this.getGridManager().getHexUnderPixel(pixel)
      hex.index=2
      this.getGridManager().drawHex(hex)
      console.log(hex)
    },
    onMouseMove(event){
      this.setMousePosition(event)
      this.setHexUnderMousePosition()
    },
    setMousePosition(event){
      this.mouse.position=this.sanitizeMousePosition(event)
    },
    setHexUnderMousePosition(){
      this.mouse.coordinate.cube=this
        .getGridManager()
        .getHexUnderPixel(this.mouse.position)
    },
    sanitizeMousePosition(event){
      let rect=this.getBoundingClientRect()
      return {
        x:event.clientX-rect.left,
        y:event.clientY-rect.top  
      }
    }
  }
} 
</script>

<style scoped></style>
