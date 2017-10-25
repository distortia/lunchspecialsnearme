<template>
  <div>
    <div class="loading" v-if="loading">
      Loading...
    </div>
    <div v-if="restaurants">
      <h1>Current shit near you: </h1>
      <div v-for="restaurant in restaurants">
          <b-card :title="restaurant.name"
                  :sub-title="restaurant.vicinity">
              <p class="card-text">
                  <div v-for="type in restaurant.types" style="display: block;">
                    {{type}}
                  </div>
              </p>
              <a :href="`https://www.google.com/maps/place/${restaurant.vicinity}`" target="_blank" 
                 class="card-link">Directions</a>
              <b-link href="#"
                      class="card-link">Another link</b-link>
          </b-card>
      </div>
    </div>
  </div>
</template>

<script>
const apiKey = 'AIzaSyDcr5TVxlv4QivDB2rd-pe3LzgpTQ6YwnE'
export default {

  name: 'Specials',
  data () {
    return {
      loading: false,
      restaurants: null
    }
  },
  methods: {
    feedMe () {
      this.loading = true
      const keywords = this.$route.query.keywords
      const location = this.$route.query.location
      const meters = this.$route.query.radius * 1509
      this.$http.get(`https://maps.googleapis.com/maps/api/geocode/json?key=${apiKey}&address=${location}`).then(response => {
        const geolocation = `${response.body.results[0].geometry.location.lat},${response.body.results[0].geometry.location.lng}`
        // and into another fucking promise \ 0 / praise javascript
        this.$http.get(`https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=${apiKey}&location=${geolocation}&radius=${meters}&type=restaurant&keyword=${keywords}&opennow=true`).then(resp => {
          console.log('resp.body', resp.body)
          this.loading = false
          this.restaurants = resp.body.results
        }, error => {
          console.log(error)
        })
      }, error => {
        console.log(error)
      })
    }
  },
  created () {
    this.feedMe()
  },
  watch: {
    // call again the method if the route changes
    '$route': 'feedMe'
  }
}
</script>

<style lang="css" scoped>
</style>