<template>
  <div>
    <div class="loading" v-show="loading">
      <i class="fa fa-cog fa-spin fa-3x fa-fw"></i>
      <span class="sr-only">Loading...</span>
    </div>
    <h1 v-if="restaurants">Currently displaying {{restaurants.length}} place(s) near you </h1>
    <b-container fluid>
      <b-row class="specials-container">
        <b-col cols="12" md="7">
          <div class="map-container">
            <div id="map"></div>
            <b-modal ref="placeModalref" hide-footer size="lg" :title="placeModal.title" lazy>
              <place-modal :specials="specials" :hasSpecial="hasSpecial" :placeModal="placeModal" :daysOfWeek="daysOfWeek"></place-modal>
              <b-alert :variant="modalAlert.variant" dismissible :show="modalAlert.show">{{modalAlert.message}}</b-alert>
          </b-modal>
          </div>
        </b-col>
        <b-col md="5" cols="12" @submit.prevent="updateSearch">
          <b-card title="Search">
            <b-form class="card-text">
              <b-form-group
                id="locationGroup"
                label="Address or ZipCode"
                label-for="location">
                <b-input-group>
                  <b-form-input
                    id="location"
                    type="text"
                    v-model="form.location"
                    placeholder="123 park place or 12345"
                    required>
                  </b-form-input>
                   <b-input-group-button>
                    <b-btn variant="outline-primary" @click="getAddress()">
                      <i class="fa fa-location-arrow" v-if="!loadingLocation"></i>
                      <div v-show="loadingLocation">
                        <i class="fa fa-cog fa-spin fa-1x fa-fw"></i>
                        <span class="sr-only">Fetching Location...</span>
                      </div>
                    </b-btn>
                  </b-input-group-button>
                </b-input-group>
              </b-form-group>
              <b-form-group
                label="Search Radius"
                label-for="radius">
              <b-form-input
                id="radius"
                type="number"
                v-model="form.radius"
                placeholder="Radius(miles)"
                required></b-form-input>
              </b-form-group>
              <b-form-group
                label="Categories or Restaurant">
                <b-form-input 
                  id="keywords"
                  type="text"
                  v-model="form.keywords"
                  placeholder="Mexican or Tai's Asian Bistro"
                  required></b-form-input>
                </b-form-group>
              <b-button type="submit" variant="success" block>Search</b-button>
            </b-form>
            <b-alert :show="noLocation" variant="warning" dismissible @dismissed="noLocation = false">Location fetching failed. Please enable location services and try again.</b-alert>
            <b-alert :show="noResults" variant="danger" dismissible @dismissed="noResults = false">No Results - Try again</b-alert>
          </b-card>
          <div class="restaurant-cards-list">
            <div class="ad-container">
              <ins class="adsbygoogle"
                style="display:block"
                data-ad-client="ca-pub-1093990846577533"
                data-ad-slot="9354044408"
                data-ad-format="auto"
                ref="googleAds">
              </ins>
            </div>
            <restaurant-list :restaurants="restaurants"></restaurant-list>
          </div>
          <div class="pagination-container" v-if="pagination">
            <b-button @click="paginate" variant="primary btn-block">Show More</b-button>
          </div>
            <!-- Only show if there are restaurants and there is no more pagination -->
          <b-alert show v-else v-show="restaurants" variant="warning">All results are displayed</b-alert>
        </b-col>
      </b-row>
    </b-container>
  </div>
</template>

<script>
import UserService from '@/services/userService'
import LocationService from '@/services/locationService'
import PlaceModal from '@/components/specials/PlaceModal'
import RestaurantList from '@/components/specials/RestaurantList'

export default {

  name: 'Specials',
  data () {
    return {
      map: null,
      loading: false,
      loadingLocation: false,
      noLocation: false,
      restaurants: null,
      pagination: null,
      placeModal: {},
      hasSpecial: false,
      noResults: false,
      geocoords: null,
      specials: [],
      form: {
        location: this.$route.query.location.replace(/\+/g, ' ') || null,
        radius: this.$route.query.radius || null,
        keywords: this.$route.query.keywords || null
      },
      daysOfWeek: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      modalAlert: {
        show: false,
        message: null,
        variant: null
      }
    }
  },
  components: {
    'place-modal': PlaceModal,
    'restaurant-list': RestaurantList
  },
  methods: {
    feedMe () {
      this.loading = true
      this.restaurants = null
      this.$http.post('results', {location: this.form.location, keyword: this.$route.query.keywords, radius: this.$route.query.radius})
      .then(response => {
        this.loading = false
        if (response.body.error === 'ZERO_RESULTS') {
          this.noResults = true
          this.geocoords = {lat: parseFloat(response.body.geocoords.split(',')[0]), lng: parseFloat(response.body.geocoords.split(',')[1])}
          this.createMap()
          this.createInitialMarker()
        } else {
          this.noResults = false
          this.geocoords = {lat: parseFloat(response.body.geocoords.split(',')[0]), lng: parseFloat(response.body.geocoords.split(',')[1])}
          this.createMap()
          this.createInitialMarker()
          this.parsePlaces(response.body.data.results, response.body.data.status, response.body.data.next_page_token)
        }
      }, err => {
        //Throw an error to the front end
      })
    },
    createMarker (place, index) {
      let marker = new google.maps.Marker({
        map: this.map,
        animation: google.maps.Animation.DROP,
        label: `${index + 1}`, // add 1 to make them user friendly numbers
        position: place.geometry.location
      })

      marker.addListener('click', () => {
        this.showModal(place)
      })
    },
    parsePlaces (places, status, pagination) {
      this.loading = false
      this.restaurants = (this.restaurants === null) ? places : this.restaurants.concat(places)
      this.pagination = (pagination || false)
      // Draw the markers for the places
      places.forEach((place, index) => {
        this.createMarker(place, index)
      })
    },
    paginate () {
      this.loading = true
      this.$http.post('results', {pagination_token: this.pagination}).then(response => {
        this.loading = false
        this.parsePlaces(response.body.data.results, response.body.data.status, response.body.data.next_page_token)
      })
    },
    placeDetails (placeId) {
      this.$http.get(`results/details/${placeId}`).then(resp => {
        this.placeModal = resp.body.data
        this.$http.get(`special/${placeId}`).then(res => {
          this.hasSpecial = true
          this.specials = this.formatSpecials(res.body.data)
        }, err => {
          this.hasSpecial = false
        })
      })
    },
    showModal (place) {
      this.placeDetails(place.place_id)
      this.$refs.placeModalref.show()
    },
    hideModal () {
      this.$refs.placeModalref.hide()
    },
    updateSearch() {
     this.$router.push({
        path: 'specials',
        query: {
          location: this.form.location.replace(/ /g, '+'),
          keywords: encodeURIComponent(this.form.keywords),
          radius: this.form.radius
        }
      })
    },
    // Combines multiple specials under one day into a list of specials under that day
    formatSpecials(specials) {
      let output = []
      specials.forEach((special) => {
        let existing = output.filter((v, i) => {
          return v.day_of_week === special.day_of_week
        });
        if (existing.length) {
          let existingIndex = output.indexOf(existing[0])
          output[existingIndex].info = output[existingIndex].info.concat(special.info)
        } else {
          if (typeof special.info == 'string')
            special.info = [special.info]
          output.push(special)
        }
      });
      // in place sort based on day of the week.
      output.sort((a, b) => {
        return this.daysOfWeek.indexOf(a.day_of_week) > this.daysOfWeek.indexOf(b.day_of_week)
      })
      return output
    },
    createMap() {
      this.map = new google.maps.Map(document.getElementById('map'), {
        center: this.geocoords,
        zoom: 13})
    },
    createInitialMarker() {
      // This map marker is different because we pass our lat/lng into it
      // instead of fetching it from the results
     new google.maps.Marker({
        position: this.geocoords,
        animation: google.maps.Animation.DROP,
        icon: 'https://maps.google.com/mapfiles/ms/icons/yellow-dot.png',
        map: this.map
      })
    },
    async getAddress () {
      this.loadingLocation = true
      if ('geolocation' in navigator) {
        this.$http.post('location', {location: await LocationService.geolocation()}).then(response => {
          this.form.location = response.body.address
        }, err => {
          this.noLocation = true
        })
        this.loadingLocation = false
      } else {
        this.noLocation = true  
      }
    }
  },
  mounted () {
    this.feedMe()
  },
  watch: {
    '$route': 'feedMe'
  },
  created() {
    this.$root.$on('specialAdded', () => {
      this.placeDetails(this.placeModal.place_id)
      this.modalAlert.show = true
      this.modalAlert.variant = 'primary'
      this.modalAlert.message = 'Special added! Thanks for your help! 👍 👍 👍'
    })
    this.$root.$on('show-restaurant-modal', restaurant => {
      this.showModal(restaurant)
    })
  }
}
</script>

<style lang="scss">
@import './../assets/sass/specials.scss';
</style>