<template>
  <div>
    <div class="loading" v-if="loading">
      Loading...
    </div>
    <div id="map"></div>
    <div v-if="restaurants">
      <h1>Current shit near you({{restaurants.length}}): </h1>
      <div v-for="restaurant in restaurants">
          <b-card :title="restaurant.name"
                  :sub-title="restaurant.vicinity">
              <div style="display: block;">
                <b-badge pill variant="warning">
                  Rating: {{restaurant.rating}} <i class="fa fa-star" aria-hidden="true"></i>
                </b-badge>
                <b-badge pill variant="success">Price Level: {{restaurant.price_level | expensivity }}</b-badge>
              </div>
              <p class="card-text" style="display: inline;"> Types: 
                  <div v-for="type in restaurant.types" style="display: inline;">
                    {{type}}
                  </div>
                </ul>
              </p>
              <b-button :href="`https://www.google.com/maps/place/${restaurant.vicinity}`" target="_blank" 
                 class="card-link" variant="primary"><i class="fa fa-map-marker" aria-hidden="true"></i> Directions</b-button>
          </b-card>
      </div>
    </div>
  </div>
</template>

<script>
/* global google */
export default {

  name: 'Specials',
  data () {
    return {
      map: null,
      loading: false,
      geocoords: {
        lat: null,
        lng: null
      },
      restaurants: null
    }
  },
  methods: {
    feedMe () {
      this.loading = true
      // const geocoder = new google.maps.Geocoder()
      const map = new google.maps.Map(document.getElementById('map'), {
        setCenter: {lat: this.geocoords.lat, lng: this.geocoords.lng},
        zoom: 17
      })
      var service = new google.maps.places.PlacesService(map)
      // geocoder.geocode({ 'address': this.$route.query.location }, (results, status) => {
      navigator.geolocation.getCurrentPosition((position) => {
        // this.geocoords.lat = results[0].geometry.location.lat()
        this.geocoords.lat = position.coords.latitude
        // this.geocoords.lng = results[0].geometry.location.lng()
        this.geocoords.lng = position.coords.longitude
        service.nearbySearch({
          location: {lat: this.geocoords.lat, lng: this.geocoords.lng},
          radius: this.$route.query.radius * 1509,
          type: ['restaurant'],
          keyword: this.$route.query.keywords
        }, response => {
          this.loading = false
          this.restaurants = response
        })
      })
    }
  },
  mounted () {
    this.feedMe()
  },
  watch: {
    // call again the method if the route changes
    '$route': 'feedMe'
  },
  filters: {
    expensivity: value => {
      switch (value) {
        case 0:
          return 'Free'
        case 1:
          return 'Inexpensive'
        case 2:
          return 'Moderate'
        case 3:
          return 'Expensive'
        case 4:
          return 'Very Expensive'
        case undefined:
          return 'Unknown'
        default: 'Unknown'
      }
    }
  }
}
</script>

<style lang="css" scoped>
</style>