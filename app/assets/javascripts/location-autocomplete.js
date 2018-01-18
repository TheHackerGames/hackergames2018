$(function() {
  $locationAutocompleteInput = $("[data-location-autocomplete]");

  if ($locationAutocompleteInput.length == 0) return

  function fillCoordinatesFields() {
    var location = autocomplete.getPlace();
    $('[data-location-name]').val(location['name']);
    $('[data-location-address]').val(location['formatted_address']);
    $('[data-location-latitude]').val(location['geometry']['location'].lat());
    $('[data-location-longitude]').val(location['geometry']['location'].lng());
    $('[data-location-gmaps-place-id]').val(location['place_id']);
  }

  var autocomplete;
  var input = $locationAutocompleteInput.get()[0];
  var locationType = input.dataset.locationType || '(regions)'
  var options = {
    componentRestrictions: { country: "uk" },
    types: [locationType]
  };

  autocomplete = new google.maps.places.Autocomplete(input, options);
  autocomplete.addListener("place_changed", fillCoordinatesFields);
});

$(function initMap() {
  var mapContainer = document.getElementById('map');
  var mapData = mapContainer.dataset;
  var markers = JSON.parse(mapData.markers)

  var mapCenter = { lat: markers[0].latitude, lng: markers[0].longitude }

  var map = new google.maps.Map(mapContainer, {
    zoom: 10,
    center: mapCenter
  });

  markers.forEach(function(marker){
    var latitude = marker.latitude
    var longitude = marker.longitude

    new google.maps.Marker({
      position: { lat: latitude, lng: longitude },
      map: map
    });
  });
});