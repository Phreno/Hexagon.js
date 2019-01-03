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
    }
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
    // Debug functions
    trackMouse(){
      this
        .getCanvas()
        .addEventListener('mousemove', this.onMouseMove)
    },
    
    // Grid functions
    draw(){
      this.getGridManager().draw(this.settings)
    },

    // Getters & Setters 
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
    onMouseMove(event){
      this.setMousePosition(event)
      this.setHexUnderMousePosition()
    },
    setMousePosition(event){
      let rect=this.getBoundingClientRect()
      this.mouse.position.x=event.clientX-rect.left
      this.mouse.position.y=event.clientY-rect.top  
    },
    setHexUnderMousePosition(){
      let hex=this
        .getGridManager()
        .getHexUnderPixel(
          this.mouse.position
        )
      this.mouse.coordinate.cube.q=Math.trunc(hex.q)
      this.mouse.coordinate.cube.r=Math.trunc(hex.r)
      this.mouse.coordinate.cube.s=Math.trunc(hex.s)
    }

  }
} 
</script>

<style scoped>
  
</style>
