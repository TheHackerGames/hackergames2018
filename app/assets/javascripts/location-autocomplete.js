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
