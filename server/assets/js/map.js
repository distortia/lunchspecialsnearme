$(() => {
  initMap = function(lat, lng) {
    const myLocation = { lat: parseFloat(lat), lng: parseFloat(lng) };
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
    window.map = map
  }

  createMarker = function(place, index) {
    let marker = new google.maps.Marker({
      map: map,
      animation: google.maps.Animation.DROP,
      label: `${index + 1}`, // add 1 to make them user friendly numbers
      position: place.geometry.location
    });
  };
})