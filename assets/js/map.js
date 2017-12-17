function init_map() {
    const myLocation = { lat: 39.8675784, lng: -82.7988644 };
    var myOptions = {
        zoom: 13,
        center: myLocation,
    };
    let map = new google.maps.Map(document.getElementById('map'), myOptions);
    let marker = new google.maps.Marker({
        map: map,
        animation: google.maps.Animation.DROP,
        position: myLocation,
        icon: 'https://maps.google.com/mapfiles/ms/icons/yellow-dot.png'
    });
    // infowindow.open(map, marker);
    // google.maps.event.addListener(marker, 'click', function() {
    //     infowindow.open(map, marker);
    // });
}
google.maps.event.addDomListener(window, 'load', init_map);

function create_marker(place, index) {
  let marker = new google.maps.Marker({
    map: document.getElementById('map'),
    animation: google.maps.Animation.DROP,
    label: `${index + 1}`, // add 1 to make them user friendly numbers
    position: place.geometry.location
  })

  marker.addListener('click', () => {
    this.showModal(place)
  })
}

function parsePlaces (places, status, pagination) {
  this.restaurants = (this.restaurants === null) ? places : this.restaurants.concat(places)
  this.pagination = pagination
  // Draw the markers for the places
  places.forEach((place, index) => {
    this.createMarker(place, index)
  })
}


// export default initMap