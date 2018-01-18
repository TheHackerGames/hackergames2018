$(function() {
  if ($("#location").length) {
    function fillCoordinatesFields() {
      var location = autocomplete.getPlace();

      $("#lat").val(location["geometry"]["location"].lat());
      $("#lng").val(location["geometry"]["location"].lng());
    }

    var autocomplete;
    var input = document.getElementById("location");
    var options = {
      componentRestrictions: { country: "uk" },
      types: ["(regions)"] // (cities)
    };

    autocomplete = new google.maps.places.Autocomplete(input, options);
    autocomplete.addListener("place_changed", fillCoordinatesFields);
  }
});
