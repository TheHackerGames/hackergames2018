$(function() {
  function getPlaces() {
    var coordinates = {
      lat: $placesList.data("lat"),
      lng: $placesList.data("lng")
    };

    infowindow = new google.maps.InfoWindow();
    var service = new google.maps.places.PlacesService(
      document.createElement("div")
    );
    service.nearbySearch(
      {
        location: coordinates,
        radius: 500,
        type: ["cafe"]
      },
      callback
    );
  }

  function callback(results, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      $results = results;
      for (var i = 0; i < results.length; i++) {
        $placesList.append(
          "<li class='mb3'><a class='ba b--black-025 shadow-3 db br2 pa3 no-underline black' href='javascript:;' data-place-id='" +
            i +
            "'><div class='ttu fw6 tracked mb2'>" +
            results[i].name +
            "</div><div class='gray'>" +
            results[i].vicinity +
            "</div></a></li>"
        );
      }
    }
  }

  $placesList = $("[data-places-list]");
  if ($placesList.length == 0) return;

  $results = [];
  getPlaces();

  $(document).on("click", "[data-place-id]", function() {
    $(".b--black")
      .removeClass("b--black")
      .addClass("b--black-025");
    $(this)
      .removeClass("b--black-025")
      .addClass("b--black");
    var placeId = $(this).data("place-id");

    $("[data-location-name]").val($results[placeId]["name"]);
    $("[data-location-address]").val($results[placeId]["vicinity"]);
    $("[data-location-latitude]").val(
      $results[placeId]["geometry"]["location"].lat()
    );
    $("[data-location-longitude]").val(
      $results[placeId]["geometry"]["location"].lng()
    );
    $("[data-location-gmaps-place-id]").val($results[placeId]["place_id"]);
  });
});
