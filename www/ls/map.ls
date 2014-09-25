mapElement = document.createElement 'div'
  ..id = \map
document.body.appendChild mapElement
window.ig.map = map = L.map do
  * mapElement
  * minZoom: 6,
    maxZoom: 12,
    zoom: 7,
    center: [49.78, 15.5]
    maxBounds: [[48.4,11.8], [51.2,18.9]]

getLayer = (topic, year) ->
  L.tileLayer do
    * "../data/tiles/{z}/{x}/{y}.png"
    * attribution: '<a href="http://creativecommons.org/licenses/by-nc-sa/3.0/cz/" target = "_blank">CC BY-NC-SA 3.0 CZ</a> <a target="_blank" href="http://rozhlas.cz">Rozhlas.cz</a>, data <a target="_blank" href="http://www.volby.cz">ČSÚ</a>'
      zIndex: 2

baseLayer = L.tileLayer do
  * "https://samizdat.cz/tiles/ton_b1/{z}/{x}/{y}.png"
  * zIndex: 1
    opacity: 1
    attribution: 'mapová data &copy; přispěvatelé <a target="_blank" href="http://osm.org">OpenStreetMap</a>, obrazový podkres <a target="_blank" href="http://stamen.com">Stamen</a>, <a target="_blank" href="https://samizdat.cz">Samizdat</a>'

labelLayer = L.tileLayer do
  * "https://samizdat.cz/tiles/ton_l1/{z}/{x}/{y}.png"
  * zIndex: 3
    opacity: 0.75

displayedId = null
window.ig.utfgrid = grid = new L.UtfGrid "../data/tiles/{z}/{x}/{y}.json", useJsonP: no
  ..on \mouseover ({data}:e) ->
    displayedId := data?0
    window.ig.displayData data
  ..on \click ({data}) ->
    return unless data
    return unless data.2
    if displayedId == data.0
      window.ig.showKandidatka data[0], data[1]
    else
      window.ig.displayData data
      displayedId := data.0

map.on \zoomend ->
  z = map.getZoom!
  if z > 9 && !map.hasLayer baseLayer
    map
      ..addLayer baseLayer
      ..addLayer labelLayer
    layers.forEach (.layer.setOpacity 0.6)
  else if z <= 9 && map.hasLayer baseLayer
    map
      ..removeLayer baseLayer
      ..removeLayer labelLayer
    layers.forEach (.layer.setOpacity 1)

layers = [
  layer: getLayer '/', 2014
  name: 'Počtu kandidátů na mandát'
]

currentLayer = null

selectLayer = ({layer}) ->
  if currentLayer
    lastLayer = currentLayer
    setTimeout do
      ->
        map.removeLayer lastLayer.map
      300

  map.addLayer layer
  currentLayer :=
    map: layer

selectLayer layers.0
setTimeout do
  -> map.addLayer grid
  10
