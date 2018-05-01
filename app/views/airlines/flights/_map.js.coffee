# GoogleMaps
#origin = <%#= [@flight.origin.location.lat, @flight.origin.location.lon].to_json %>
#dest   = <%#= [@flight.destination.location.lat, @flight.destination.location.lon].to_json %>
#
#$('#airline-flight-map').gmap3(
#  center: new (google.maps.LatLng)(39.8, -98.6)
#  zoom: 4
#  mapTypeId: google.maps.MapTypeId.STREET
#  mapTypeControl: true
#  mapTypeControlOptions:
#    style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
#  navigationControl: true
#  scrollwheel: true
#  streetViewControl: false
#).polyline([
#  {
#    geodesic: true
#    strokeColor: '#000abf'
#    strokeOpacity: 0.5
#    strokeWeight: 2.0
#    path: [ origin, dest ]
#  }
#]).marker({
#  position: origin
#  icon: '<%#= asset_path('maps/marker-airport-green.png') %>'
#}).marker({
#  position: dest
#  icon: '<%#= asset_path('maps/marker-airport-red.png') %>'
#})
#.fit()

# OpenStreetMap
map = $.fn.OpenStreetMap('airline-flight-map')

origin = new (L.LatLng)(<%= @flight.origin.location.lat %>,<%= @flight.origin.location.lon %>)
dest   = new (L.LatLng)(<%= @flight.destination.location.lat %>,<%= @flight.destination.location.lon %>)

latlngs = [
  [
    origin
    dest
  ]
]

# define polylines
polylines = L.geodesic(
  latlngs,
  color:  '#000abf',
  steps:  50,
  weight: 1.5
).addTo(map)

# add markers
L.marker(origin, {icon: $.fn.OpenStreetMap_OriginIcon()}).addTo(map);
L.marker(dest, {icon: $.fn.OpenStreetMap_DestIcon()}).addTo(map);

# zoom the map to the polylines
map.fitBounds polylines.getBounds()