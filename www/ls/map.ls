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


dataLayer = L.tileLayer do
    * "../data/tiles/{z}/{x}/{y}.png"
    * attribution: '<a href="http://creativecommons.org/licenses/by-nc-sa/3.0/cz/" target = "_blank">CC BY-NC-SA 3.0 CZ</a> <a target="_blank" href="http://rozhlas.cz">Rozhlas.cz</a>, data <a target="_blank" href="http://www.volby.cz">ČSÚ</a>'
      zIndex: 2

dataLayer2 = L.tileLayer do
    * "../data/tiles-mag/{z}/{x}/{y}.png"
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
    return unless data.3
    if displayedId == data.0
      window.ig.showKandidatka data[0], data[1]
    else
      window.ig.displayData data
      displayedId := data.0


grid2 = new L.UtfGrid "../data/tiles-mag/{z}/{x}/{y}.json", useJsonP: no
  ..on \mouseover ({data}:e) ->
    displayedId := data?0
    window.ig.displayData data
  ..on \click ({data}) ->
    return unless data
    return unless data.3
    if displayedId == data.0
      window.ig.showKandidatka data[0], data[1]
    else
      window.ig.displayData data
      displayedId := data.0


switchMaps = (target) ->
  map.removeLayer grid
  map.removeLayer dataLayer

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

layers =
  * layer: dataLayer
    dataLayer: grid
    name: 'Obce a městské části'
  * layer: dataLayer2
    dataLayer: grid2
    name: 'Magistáty'



currentLayer = null

selectLayer = ({layer, dataLayer}) ->
  if currentLayer
    lastLayer = currentLayer
    map.removeLayer
    setTimeout do
      ->
        map.removeLayer lastLayer.layer
        map.removeLayer lastLayer.dataLayer
      300

  map.addLayer layer
  currentLayer := {layer, dataLayer}
  <~ setTimeout _, 10
  map.addLayer dataLayer

d3.select mapElement .append \div
  ..attr \class \layer-selector
  ..selectAll \label.item .data layers .enter!append \label
    ..attr \class \item
      ..append \input
        ..attr \type \radio
        ..attr \name \layer
        ..attr \checked (d, i) -> if i == 0 then \checked else void
        ..on \change selectLayer
      ..append \span
        ..html (.name)


selectLayer layers.0
