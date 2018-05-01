# GoogleMaps
#$('#airline-route-map').gmap3(
#  address: 'United States'
#  zoom: 3
#  mapTypeId: google.maps.MapTypeId.STREET
#  mapTypeControl: true
#  mapTypeControlOptions: style: google.maps.MapTypeControlStyle.DROPDOWN_MENU
#  navigationControl: true
#  scrollwheel: true
#  streetViewControl: false
#  ).polyline([
#  <%# if @flights.empty? %>
#  {}
#  <%# end %>
#
#  <%# @flights.each do |flight| %>
#  {
#    geodesic: true
#    strokeColor: '#000abf'
#    strokeOpacity: 0.5
#    strokeWeight: 1.5
#    path: [
#      [
#        <%#= flight.origin.location.lat %>
#        <%#= flight.origin.location.lon %>
#      ]
#      [
#        <%#= flight.destination.location.lat %>
#        <%#= flight.destination.location.lon %>
#      ]
#    ]
#  },
#  <%# end %>
#]).fit()

# OpenStreetMap
map = $.fn.OpenStreetMap('airline-route-map')

#latlngs = [
#  <%# @flights.each do |flight| %>
#  [
#    new (L.LatLng)(<%#= flight.origin.location.lat %>,<%#= flight.origin.location.lon %>)
#    new (L.LatLng)(<%#= flight.destination.location.lat %>,<%#= flight.destination.location.lon %>)
#  ]
#  <%# end %>
#]

# define polylines
#polylines = L.geodesic(
#  latlngs,
#  color:  '#000abf',
#  steps:  50,
#  weight: 1.5
#).addTo(map)

# zoom the map to the polylines
#map.fitBounds polylines.getBounds()

<% @flights.each do |flight| -%>
latLng = new (L.LatLng)(<%= flight.destination.location.lat %>,<%= flight.destination.location.lon %>)

marker = L.marker(latLng, {icon: $.fn.OpenStreetMap_AirportIcon()}).addTo(map);

marker.bindPopup(
  "<b><%= flight.destination.to_display %></b><br>" +
  '<%= link_to 'View Departures', search_schedule_index_path(q: { airline_icao_eq: @airline.icao, origin_ident_eq: flight.destination.ident }) %>' +
  ' | ' +
  '<%= link_to 'View Arrivals', search_schedule_index_path(q: { airline_icao_eq: @airline.icao, destination_ident_eq: flight.destination.ident }) %>',
  offset: [0,-20]
);
<% end -%>