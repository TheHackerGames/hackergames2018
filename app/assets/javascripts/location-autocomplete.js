$(function() {
  $locationAutocompleteInput = $("[data-location-autocomplete]");

  if ($locationAutocompleteInput.length == 0) return;

  function fillCoordinatesFields() {
    var location = autocomplete.getPlace();
    $("[data-location-name]").val(location["name"]);
    $("[data-location-address]").val(location["formatted_address"]);
    $("[data-location-latitude]").val(location["geometry"]["location"].lat());
    $("[data-location-longitude]").val(location["geometry"]["location"].lng());
    $("[data-location-gmaps-place-id]").val(location["place_id"]);
  }

  var autocomplete;
  var input = $locationAutocompleteInput.get()[0];
  var locationType = input.dataset.locationType || "address"
  var options = {
    componentRestrictions: { country: "uk" },
    types: [locationType]
  };

  autocomplete = new google.maps.places.Autocomplete(input, options);
  autocomplete.addListener("place_changed", fillCoordinatesFields);
});

$(function initMap() {
  var mapContainer = document.getElementById("map");
  if (mapContainer == null) return;

  var mapData = mapContainer.dataset;
  var markers = JSON.parse(mapData.markers);

  var mapCenter = JSON.parse(mapData.center)

  var map = new google.maps.Map(mapContainer, {
    zoom: 10,
    center: mapCenter
  });

  new google.maps.Marker({ position: mapCenter, map: map, icon: "http://maps.google.com/mapfiles/ms/icons/green-dot.png" });

  if(markers.length > 0) {
    var latlngList = [];

    markers.forEach(function(marker){
      var markerLocation = { lat: marker.latitude, lng: marker.longitude }
      latlngList.push(new google.maps.LatLng (marker.latitude, marker.longitude));

      new google.maps.Marker({ position: markerLocation, map: map, label: marker.label });
    });

    latlngList.push(new google.maps.LatLng (mapCenter.lat, mapCenter.lng));

    var bounds = new google.maps.LatLngBounds();
    latlngList.forEach(function(n){
       bounds.extend(n);
    });
    map.setCenter(bounds.getCenter()); //or use custom center
    map.fitBounds(bounds);
  }
});
