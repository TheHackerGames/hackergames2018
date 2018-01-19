$(function() {
  $placesList = $("[data-places-list]");
  if ($placesList.length == 0) return;

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
        type: ["store"]
      },
      callback
    );
  }

  function callback(results, status) {
    if (status === google.maps.places.PlacesServiceStatus.OK) {
      for (var i = 0; i < results.length; i++) {
        console.log(results[i]);
        // createMarker(results[i]);
      }
    }
  }

  getPlaces();

  //
  // function createMarker(place) {
  //   var placeLoc = place.geometry.location;
  //   var marker = new google.maps.Marker({
  //     map: map,
  //     position: place.geometry.location
  //   });
  //
  //   google.maps.event.addListener(marker, "click", function() {
  //     infowindow.setContent(place.name);
  //     infowindow.open(map, this);
  //   });
  // }
});
