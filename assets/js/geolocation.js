function geoloction() {
  navigator.geolocation.getCurrentPosition((position) => {
    return `${position.coords.latitude},${position.coords.longitude}`
  })
};

export { geolocation }