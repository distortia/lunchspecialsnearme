function geolocation() {
  navigator.geolocation.getCurrentPosition((position) => {
    `${position.coords.latitude},${position.coords.longitude}`
  }, err => {
    console.log(err)
  })
};

export { geolocation }