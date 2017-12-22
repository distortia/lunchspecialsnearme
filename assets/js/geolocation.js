$(() => {
  _geolocation = function() {
    let geocoords;
    setTimeout(() => {
      navigator.geolocation.getCurrentPosition((position) => {
        this.geocoords = `${position.coords.latitude},${position.coords.longitude}`
      })
    })
    return geocoords
  }
})