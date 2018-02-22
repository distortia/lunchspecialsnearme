import localStorage from '../util/localStorage'

const geolocation = async () => {
  const position = await getCurrentPosition({highAccuracy: true})
  return `${position.coords.latitude},${position.coords.longitude}`
}

const getCurrentPosition = (options = {}) => {
  return new Promise((resolve, reject) => {
    navigator.geolocation.getCurrentPosition(resolve, reject, options);
  })
}

export default {
  geolocation
}