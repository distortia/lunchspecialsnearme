<template>
  <div>
    <div class="loading" v-show="loading">
      <i class="fa fa-cog fa-spin fa-3x fa-fw"></i>
      <span class="sr-only">Loading...</span>
    </div>
    <b-container fluid>
      <b-modal ref="placeModalref" hide-footer size="lg" :title="placeModal.title" lazy>
        <place-modal :specials="specials" :hasSpecial="hasSpecial" :placeModal="placeModal" :daysOfWeek="daysOfWeek"></place-modal>
        <Adsense
          data-ad-client="ca-pub-1093990846577533"
          data-ad-slot="9354044408">
        </Adsense>
        <b-alert :variant="modalAlert.variant" dismissible :show="modalAlert.show">{{modalAlert.message}}</b-alert>
      </b-modal>
      <b-row class="specials-container">
        <b-col cols="12" md="4">
          <div class="search-container">
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
                  label="Categories or Restaurant - Leave blank for all results">
                  <b-form-input 
                    id="keywords"
                    type="text"
                    v-model.trim="form.keywords"
                    @input="autocompleteList"
                    @blur.native="autocomplete.items = []"
                    placeholder="Mexican or Tai's Asian Bistro">
                    </b-form-input>
                  </b-form-group>
                  <b-list-group v-show="autocomplete.items">
                    <b-list-group-item
                      button
                      @click.prevent="setAsKeyWord(item.description)"
                      class="autocomplete"
                      v-for="(item, $item) in autocomplete.items"
                      :key="$item">
                      {{ item.description }}
                    </b-list-group-item>
                  </b-list-group>
                <b-button type="submit" variant="success" block  @click="autocomplete.items = []">Search</b-button>
              </b-form>
              <b-alert :show="noLocation" variant="warning" dismissible @dismissed="noLocation = false">Location fetching failed. Please enable location services and try again.</b-alert>
              <b-alert :show="noResults" variant="danger" dismissible @dismissed="noResults = false">No Results - Try again</b-alert>
            </b-card>
          </div>
        </b-col>
        <b-col md="8" cols="12" @submit.prevent="updateSearch">
          <h1 v-if="restaurants">Currently displaying {{restaurants.length}} place(s) near you </h1>
          <div class="restaurant-cards-list">
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
      },
      autocomplete: {
        items: [],
        visible: false
      }
    }
  },
  components: {
    'place-modal': PlaceModal,
    'restaurant-list': RestaurantList,
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
        } else {
          this.noResults = false
          this.geocoords = {lat: parseFloat(response.body.geocoords.split(',')[0]), lng: parseFloat(response.body.geocoords.split(',')[1])}
          this.restaurants = (this.restaurants === null) ? response.body.data.results : this.restaurants.concat(response.body.data.results)
          this.parsePlaces(response.body.data.results, response.body.data.status, response.body.data.next_page_token)
        }
      }, err => {
        //Throw an error to the front end
      })
    },
    parsePlaces (places, status, pagination) {
      this.loading = false
      // this.restaurants = (this.restaurants === null) ? places : this.restaurants.concat(places)
      this.pagination = (pagination || false)
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
    },
    setAsKeyWord(keyword) {
      this.form.keywords = keyword
      this.autocomplete.items = []
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
    this.autocomplete.visible = false
    this.autocomplete.items = []
  },
  beforeUpdated () {
    this.autocomplete.visible = false
    this.autocomplete.items = []
  },
  computed: {
    autocompleteList() {
      if (this.form.keywords && this.form.radius) {
        this.$http.post('autocomplete', {location: this.form.location, radius: this.form.radius, keyword: this.form.keywords}).then(resp => {
          this.autocomplete.items = resp.body.data
        }, err => {
        })
      }
    }
  }
}
</script>

<style lang="scss">
@import './../assets/sass/specials.scss';
</style>