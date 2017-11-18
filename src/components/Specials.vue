<template>
  <div>
    <div class="loading" v-if="loading">
      Loading...
    </div>
    <h1 v-if="restaurants">Current places near you({{restaurants.length}}): </h1>
    <b-container fluid>
      <b-row>
        <b-col cols="7">
          <div class="map-container">
            <div id="map"></div>
          </div>
        </b-col>
        <b-col cols="5">
          <div class="restaurant-cards-list">
            <div v-for="restaurant in restaurants">
                <b-card :title="restaurant.name"
                        :sub-title="restaurant.vicinity">
                    <div style="display: block;">
                      <b-badge pill variant="warning">
                        Rating: {{restaurant.rating}} <i class="fa fa-star" aria-hidden="true"></i>
                      </b-badge>
                      <b-badge pill variant="success">Price Level: {{restaurant.price_level | expensivity }}</b-badge>
                    </div>
                    <!-- This is probably temporary -->
                    <p class="card-text" style="display: inline;"> Types: 
                        <div v-for="type in restaurant.types" style="display: inline;">
                          {{type}}
                        </div>
                      </ul>
                    </p>
                    <b-button :href="`https://www.google.com/maps/place/${restaurant.vicinity}`" target="_blank" 
                       class="card-link" variant="outline-primary"><i class="fa fa-map-marker" aria-hidden="true"></i> Directions</b-button>
                </b-card>
            </div> 
          </div>
            <div class="pagination-container" v-if="restaurants">
              <b-pagination :total-rows="100" :limit=10 v-model="currentPage" :per-page="10" align="center" hide-ellipsis></b-pagination>
            </div>
        </b-col>
      </b-row>
    </b-container>
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
      restaurants: null,
      currentPage: 0
    }
  },
  methods: {
    feedMe () {
      this.loading = true
      // const geocoder = new google.maps.Geocoder()
      // geocoder.geocode({ 'address': this.$route.query.location }, (results, status) => {
      navigator.geolocation.getCurrentPosition((position) => {
        const myGeocoords = { lat: position.coords.latitude, lng: position.coords.longitude }
        // this.geocoords.lat = results[0].geometry.location.lat()
        this.geocoords.lat = position.coords.latitude
        // this.geocoords.lng = results[0].geometry.location.lng()
        this.geocoords.lng = position.coords.longitude

        let map = new google.maps.Map(document.getElementById('map'), {
          center: myGeocoords,
          zoom: 13})

        // This map marker is different because we pass our lat/lng into it
        // instead of fetching it from the results
        // eslint-disable-next-line no-unused-vars
        const myLocationMarker = new google.maps.Marker({
          position: myGeocoords,
          animation: google.maps.Animation.DROP,
          map: map
        })

        let service = new google.maps.places.PlacesService(map)

        service.nearbySearch({
          location: {lat: position.coords.latitude, lng: position.coords.longitude},
          radius: this.$route.query.radius * 1509,
          type: ['restaurant'],
          keyword: this.$route.query.keywords
        }, response => {
          this.loading = false
          this.restaurants = response
          this.map = map
          // Draw the markers for the places
          response.forEach((place) => {
            this.createMarker(place)
          })
        }, error =>
        console.log(error))
      })
    },
    createMarker (place) {
      // eslint-disable-next-line no-unused-vars
      let placeLoc = place.geometry.location
      // eslint-disable-next-line no-unused-vars
      let marker = new google.maps.Marker({
        map: this.map,
        animation: google.maps.Animation.DROP,
        position: place.geometry.location
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

<style lang="scss">
/* map sizing taken from https://www.labnol.org/internet/embed-responsive-google-maps/28333/ */
.map-container {
  position: relative;
  padding-bottom: 80%; // This is the aspect ratio
  height: 0;
  overflow: hidden;
}
#map {
  height: 600px;
  width: 800px;
}
#map iframe {
  position: absolute;
  top: 0;
  left: 0;
  width: 100% !important;
  height: 100% !important;
}
.restaurant-cards-list {
  max-height: 75vh;
  overflow-y: scroll;
}
</style>