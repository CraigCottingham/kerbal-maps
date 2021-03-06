// We need to import the CSS so that webpack will load it.
// The MiniCssExtractPlugin is used to separate it out into
// its own CSS file.
import css from "../css/app.css"

// webpack automatically bundles all modules in your
// entry points. Those entry points can be configured
// in "webpack.config.js".
//
// Import dependencies
//
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative paths, for example:
import {socket} from "./socket.js"
window.socket = socket

import React from "react"
import ReactDOM from "react-dom"

//
// connect to channel
//

var channel
if (window.userID) {
  channel = newChannel(window.userID)
} else {
  channel = newChannel(0)
}

joinChannel(channel)

//
// helper functions
//

function addOverlaysToList(channel, paneId) {
  var pane = L.DomUtil.get(paneId)
  var checkboxList = pane.querySelector("#overlay-list")
  checkboxList.innerHTML = ""

  for (const [overlayId, overlay] of Object.entries(window.overlays)) {
    checkboxList.insertAdjacentHTML(
      "beforeend", `
<div class="form-group form-check">
  <input type="checkbox" class="form-check-input" id="show_overlay_${overlayId}" name="show_overlay" value="${overlayId}" ${overlay.active
      ? 'checked="true"'
      : ''}/>
  <label for="show_overlay_${overlayId}" class="form-check-label">${overlay.name}</label>
</div>
      `)
    document.getElementById(`show_overlay_${overlayId}`).addEventListener("click", function(event) {
      var parsed = Number.parseInt(this.id.replace("show_overlay_", ""))
      if (!Number.isNaN(parsed)) {
        if (this.checked) {
          showOverlay(channel, parsed)
        } else {
          hideOverlay(channel, parsed)
        }
      }
    })
  }
}

function createTileLayer() {
  window.tileLayer = L.tileLayer(`${window.tileCdnURL}/{body}/{style}/{z}/{x}/{y}.png`, {
    // *** TileLayer options
    // minZoom: 0,
    maxZoom: 7,
    // subdomains
    // errorTileUrl
    // zoomOffset: 0,
    tms: true,
    // zoomReverse: false,
    // detectRetina: false,
    // crossOrigin: false,

    // *** GridLayer options
    // tileSize: 256,
    // opacity: 1.0,
    // updateWhenIdle
    // updateWhenZooming: true,
    // updateInterval: 200,
    // zIndex: 1,
    // latLngBounds
    maxNativeZoom: 7,
    minNativeZoom: 0,
    noWrap: true,
    // pane
    // className
    // keepBuffer: 2,

    // *** Layer options
    attribution: 'Map data: crowdsourced' + ' | ' + 'Imagery: © 2011-2019 Take-Two Interactive, Inc.',

    // *** other options
    pack: window.selectedPack,
    body: window.selectedBody,
    style: window.selectedStyle
  }).addTo(window.map)
}

function destroyTileLayer() {
  window.tileLayer.remove()
}

function hideAllOverlays() {
  for (const [id, overlay] of Object.entries(window.overlays)) {
    overlay.layerGroup.removeFrom(window.map)
    overlay.active = false
  }
}

function hideOverlay(channel, overlayId) {
  var overlay = window.overlays[overlayId]
  overlay.layerGroup.removeFrom(window.map)
  overlay.active = false
}

function joinChannel(channel) {
  channel.join().receive("ok", response => {
    console.log(`Joined channel ${channel.topic}`, response)
  }).receive("error", response => {
    console.log("Unable to join channel", response)
  })
}

function loadBiomesForBody(channel, legend, body) {
  channel.push("get_all_biomes", {"body": body}).receive("ok", response => {
    var elements = response.biomes.reduce((acc, biome) => {
      acc.push({
        style: makeLegendStyle(`rgba(${biome.r}, ${biome.g}, ${biome.b}, ${biome.a})`),
        html: '<div>&nbsp;</div>',
        label: biome.label
      })
      return acc
    }, [])

    legend.removeLegend(legend._lastId)
    legend.addLegend({name: 'Biomes', elements: elements})
  })
}

function loadOverlaysForBody(channel, paneId, body) {
  channel.push("get_all_overlays", {"body": body}).receive("ok", response => {
    // don't overwrite window.overlays; update it
    response.overlays.forEach(function(overlay) {
      if (!window.overlays[overlay.id]) {
        overlay.layerGroup = null
        overlay.active = false
        window.overlays[overlay.id] = overlay
      }
    })
    addOverlaysToList(channel, paneId)
  })
}

function makeLegendStyle(color) {
  let style = {
    'width': '11px',
    'height': '11px',
    'border': '1px solid #000000',
    'background-color': color,
    'font-size': '11px',
    'vertical-align': 'baseline'
  }
  return style
}

function newChannel(subtopic) {
  return socket.channel(`data:${subtopic}`, {})
}

function showOverlay(channel, overlayId) {
  // should only do the channel.push if the overlay layerGroup isn't defined
  // since the layerGroup is loaded in a callback, fire an event that adds the layerGroup to the map?
  // probably should always call channel.push and update the layerGroup if necessary
  channel.push("get_overlay", {"id": overlayId}).receive("ok", response => {
    var overlay = window.overlays[overlayId]
    if (!overlay.layerGroup) {
      overlay.layerGroup = L.layerGroup()
      response.overlay.markers.forEach(function(marker) {
        var latitude = marker.latitude
        var longitude = marker.longitude
        var label = `<strong>${marker.name}</strong><br/>${marker.latitude}, ${marker.longitude}<br/>${marker.description || ""}`
        var icon = L.icon.glyph({prefix: marker.icon_prefix, glyph: marker.icon_name})
        L.marker([
          latitude, longitude
        ], {icon: icon}).bindPopup(label).addTo(overlay.layerGroup)
      })
    }
    overlay.layerGroup.addTo(window.map)
    overlay.active = true
  })
}

function updateTileLayer() {
  destroyTileLayer()
  createTileLayer()
}

//
// start setting up the window
//

window.map = L.map('mapid', {
  preferCanvas: true,
  // attributionControl: true,
  // zoomControl: true,
  // closePopupOnClick: true,
  // boxZoom: true,
  // doubleClickZoom: true,
  // dragging: true,
  // zoomSnap: 1,
  // zoomDelta: 1,
  // trackResize: true,
  // inertia
  // inertiaDeceleration: 3000,
  // inertiaMaxSpeed: Infinity,
  // easeLinearity: 0.2,
  // worldCopyJump: false,
  // maxBoundsViscosity: 0.0,
  // keyboard: true,
  // keyboardPanDelta: 80,
  // scrollWheelZoom: true,
  // wheelDebounceTime: 40,
  // wheelPxPerZoomLevel: 60,
  // tap: true,
  // tapTolerance: 15,
  // touchZoom
  // bounceAtZoomLimits: true,
  crs: L.CRS.EPSG4326,
  center: (
    (window.locFromQuery !== undefined)
    ? window.locFromQuery
    : [-0.1027, -74.5754]), // KSC
  zoom: (
    (window.zoomFromQuery !== undefined)
    ? window.zoomFromQuery
    : 5),
  // minZoom
  // maxZoom
  // layers: [],
  // maxBounds: null,
  // renderer
  // zoomAnimation: true,
  // zoomAnimationThreshold: 4,
  // fadeAnimation: true,
  // markerZoomAnimation: true,
  // transform3DLimit: 2^23,
})

L.latlngGraticule({
  showLabel: true,
  dashArray: [
    5, 5
  ],
  zoomInterval: [
    {
      start: 2,
      end: 3,
      interval: 30
    }, {
      start: 4,
      end: 4,
      interval: 10
    }, {
      start: 5,
      end: 7,
      interval: 5
    }, {
      start: 8,
      end: 10,
      interval: 1
    }
  ]
}).addTo(window.map)

if (window.labelFromQuery !== undefined) {
  var icon = L.icon.glyph({prefix: "far", glyph: "dot-circle"})
  L.marker(window.locFromQuery, {icon: icon}).bindPopup(window.labelFromQuery).addTo(window.map)
}

var popup = L.popup()

function onMapClick(e) {
  popup.setLatLng(e.latlng).setContent("You clicked the map at " + e.latlng.toString()).openOn(window.map)
}
window.map.on('click', onMapClick)

window.legendControl = new L.Control.HtmlLegend({
  position: 'bottomright',
  legends: [
    {
      name: 'Placeholder',
      elements: []
    }
  ],
  collapseSimple: true,
  detectStretched: true,
  visibleIcon: 'icon icon-eye',
  hiddenIcon: 'icon icon-eye-slash'
});
// window.map.addControl(window.legendControl)

var sidebar = L.control.sidebar({container: "sidebar"}).addTo(window.map)

window.selectedPack = "(stock)"
window.selectedBody = "kerbin"
if (window.bodyFromQuery !== undefined) {
  window.selectedBody = window.bodyFromQuery
}
window.selectedStyle = "sat"
createTileLayer()

window.changeSelectedPack = (value) => {
  window.selectedPack = value
  hideAllOverlays()
  window.overlays = {} // clear out overlays for previous body
  updateTileLayer()
}

window.changeSelectedBody = (value) => {
  window.selectedBody = value
  hideAllOverlays()
  window.overlays = {} // clear out overlays for previous body
  updateTileLayer()
  if (window.selectedStyle == "biome") {
    loadBiomesForBody(channel, window.legendControl, window.selectedBody)
  }
}

window.changeSelectedStyle = (value) => {
  window.selectedStyle = value
  updateTileLayer()
  if (window.selectedStyle == "biome") {
    window.legendControl.addTo(window.map)
    loadBiomesForBody(channel, window.legendControl, window.selectedBody)
  }
  else {
    window.legendControl.remove()
  }
}

import MapBodyAndStyle from "./components/MapBodyAndStyle.js"
ReactDOM.render(
  <MapBodyAndStyle
    onPackChange = { window.changeSelectedPack }
    onBodyChange = { window.changeSelectedBody }
    onStyleChange = { window.changeSelectedStyle }
  />, document.getElementById("map-body-and-style")
)

window.overlays = {}

sidebar.on("content", (event) => {
  switch (event.id) {
      // case "sidebar-body-style":
      // load packs
      // load bodies for pack
      // load biome mappings for body
    case "sidebar-overlays":
      loadOverlaysForBody(channel, event.id, window.selectedBody)
  }
})

// enable search form?
$("#search-form").on("submit", (event) => {
  let query = event.target.elements.namedItem("search[query]").value

  channel.push("parse_search", {"query": query}).receive("ok", response => {
    window.map.flyTo(response.location)
  })

  return false
})

// enable tooltips
$(function() {
  $("[data-toggle='tooltip']").tooltip()
})

// force packs/bodies/biome mappings for default selections?
