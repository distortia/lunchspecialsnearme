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
            <b-modal ref="placeModal" hide-footer size="lg" :title="placeModal.title" @shown="clearAddSpecialForm" lazy>
              <b-card no-body border-variant="light" class="text-center">
                <b-tabs card pills>
                  <b-tab title="Specials" active>
                    <div v-show="hasSpecial">
                      <b-card no-body>
                        <b-tabs card>
                          <b-tab v-for="special in specials" :title="special.day_of_week" :key="special.day_of_week" :active="dayOfWeek(special.day_of_week)">
                            <b-list-group>
                              <b-list-group-item v-for="info in special.info" :key="info">{{info}}</b-list-group-item>
                          </b-list-group>
                          </b-tab>
                        </b-tabs>
                      </b-card>
                      <hr>
                    </div>
                    <div>
                      Not seeing what you are after?
                      Be a gyro and add a special!
                      <div v-if="userAuthenticated">
                        <b-form @submit.prevent="addSpecial">
                          <b-form-group label="Day(s) of the Week">
                            <b-form-checkbox-group buttons button-variant="primary" v-model="addSpecialForm.days_of_week" :options="daysOfWeek">
                            </b-form-checkbox-group>
                          </b-form-group>
                          <b-form-textarea v-model="addSpecialForm.info" placeholder="Enter Special Info Here :)" :rows="3" :max-rows="6" required></b-form-textarea>
                          <div>
                            <b-button type="submit" variant="primary">Submit</b-button>
                          </div>
                        </b-form>
                      </div>
                      <div v-else>
                        <p>We are currently in early alpha. Contact us to request access!</p>
                        <p>If you already have an account. Please <b-link to="login">log in</b-link>.</p>
                        <b-form @submit.prevent="requestAccess">
                          <b-form-group
                            id="requestAccessGroup"
                            label="Email"
                            label-for="requestAccessEmail">
                            <b-form-input
                              id="requestAccessEmail"
                              type="email"
                              v-model="requestAccessForm.email"
                              required
                              placeholder="Email Address">
                            </b-form-input>
                            <b-button type="submit" variant="primary">Submit</b-button>
                          </b-form-group>
                        </b-form>
                      </div>
                    </div>
                  </b-tab> 
                  <b-tab title="Info">
                    <h5>{{ placeModal.title }}</h5>
                    <p>
                      <b-badge pill variant="warning">
                        Rating: {{placeModal.rating}} <i class="fa fa-star" aria-hidden="true"></i>
                      </b-badge>
                      <b-badge pill variant="success">Price Level: {{ placeModal.price_level | expensivity }}</b-badge>
                    </p>
                    <p>{{placeModal.address}}</p>
                    <p>Phone: <span>{{ placeModal.phoneNumber }}</span></p>
                    <h4>Hours</h4>
                    <ul class="modal-address">
                      <li v-for="hours in placeModal.openingHours">
                        {{hours}}
                      </li>
                    </ul>
                    <b-button-group class="modal-button-group">
                      <b-button variant="outline-primary" :href="`tel:${placeModal.phoneNumber}`">
                        <i class="fa fa-mobile" aria-hidden="true"></i>
                        Call
                      </b-button>
                      <b-button :href="placeModal.url"
                                target="_blank" 
                                variant="outline-primary">
                        <i class="fa fa-map-marker" aria-hidden="true"></i>
                        Directions
                      </b-button>
                      <b-button variant="outline-primary" :href="placeModal.website" target="_blank">
                        <i class="fa fa-globe" aria-hidden="true"></i>
                        Website
                      </b-button>
                    </b-button-group>
                  </b-tab>
                  <b-tab title="Reviews">
                    <b-list-group> 
                      <b-list-group-item v-for="review in placeModal.review" :key="review.id">
                        <b-media>
                          <b-img slot="aside" :src="review.profile_photo_url" width="125" alt="placeholder" />
                          <p>{{ review.text }}</p>
                          <p><b-badge pill variant="warning">Rating: {{ review.rating }} <i class="fa fa-star" aria-hidden="true"></i></b-badge></p>
                          <p>By: <span><a :href="review.author_url">{{ review.author_name }}</a> about {{ review.relative_time_description }}</span></p>
                        </b-media>
                      </b-list-group-item>
                    </b-list-group> 
                  </b-tab>
                </b-tabs>
              </b-card>
              <b-alert :variant="modalAlert.variant" dismissible :show="modalAlert.show">{{modalAlert.message}}</b-alert>
          </b-modal>
          </div>
        </b-col>
        <b-col md="5" cols="12" @submit.prevent="updateSearch">
          <b-card title="Search">
            <b-form class="card-text">
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
                label="Keywords">
                <b-form-input 
                  id="keywords"
                  type="text"
                  v-model="form.keywords"
                  placeholder="Mexican"
                  required></b-form-input>
                </b-form-group>
              <b-button type="submit" variant="success" block>Search</b-button>
            </b-form>
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
            <b-list-group>
              <b-list-group-item v-for="(restaurant, index) in restaurants" :key="index" class="flex-column align-items-start">
                <div class="d-flex w-100 justify-content-between">
                  <h5 class="mb-1">{{index + 1}}: {{restaurant.name}}</h5>
                  <small>{{restaurant.vicinity}}</small>
                </div>
                <p class="mb-1">
                  <div style="display: block;">
                    <b-badge pill variant="warning">
                      Rating: {{restaurant.rating}} <i class="fa fa-star" aria-hidden="true"></i>
                    </b-badge>
                    <b-badge pill variant="success">Price Level: {{restaurant.price_level | expensivity }}</b-badge>
                  </div>
                  <div class="button-group">
                    <b-button :href="`https://www.google.com/maps/place/${restaurant.vicinity}`"
                              target="_blank" 
                              class="card-link"
                              variant="outline-primary">
                      <i class="fa fa-map-marker" aria-hidden="true"></i>
                      Directions
                    </b-button>
                     <b-button variant="outline-info" @click="showModal(restaurant)">
                        <i class="fa fa-info-circle" aria-hidden="true"></i>
                        Info
                     </b-button>
                   </div>
                </p>
              </b-list-group-item>
            </b-list-group>
          </div>
          <div class="pagination-container" v-if="hasPagination">
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
export default {

  name: 'Specials',
  data () {
    return {
      map: null,
      loading: false,
      _geocoords: null,
      restaurants: null,
      pagination: null,
      placeModal: {},
      hasSpecial: false,
      specials: [],
      form: {
        location: null,
        radius: this.$route.query.radius || null,
        keywords: this.$route.query.keywords || null
      },
      addSpecialForm: {
        days_of_week: [],
        info: null,
      },
      daysOfWeek: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
      requestAccessForm: {
        email: null
      },
      modalAlert: {
        show: false,
        message: null,
        variant: null
      }
    }
  },
  methods: {
    search () {
      this.$router.push({
        path: 'specials',
        query: {
          // location: this.form.location.replace(/ /g, '+'),
          keywords: this.form.keywords,
          radius: this.form.radius
        }
      })
    },
    feedMe () {
      this.loading = true
      this.restaurants = null
      navigator.geolocation.getCurrentPosition((position) => {
        const myGeocoords = { lat: position.coords.latitude, lng: position.coords.longitude }
        this._geocords = `${position.coords.latitude},${position.coords.longitude}`

        this.map = new google.maps.Map(document.getElementById('map'), {
          center: myGeocoords,
          zoom: 13})
        
        // This map marker is different because we pass our lat/lng into it
        // instead of fetching it from the results
        const myLocationMarker = new google.maps.Marker({
          position: myGeocoords,
          animation: google.maps.Animation.DROP,
          icon: 'https://maps.google.com/mapfiles/ms/icons/yellow-dot.png',
          map: this.map
        })

        this.$http.post('results', {location: this._geocords, keyword: this.$route.query.keywords, radius: this.$route.query.radius})
          .then(response => {
            this.loading = false
            this.parsePlaces(response.body.data.results, response.body.data.status, response.body.data.next_page_token)
        })
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
      setTimeout(() => {
        if (this.pagination.hasNextPage) {
          this.pagination.nextPage()
        }
        this.loading = false
      }, 2000)
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
      this.$refs.placeModal.show()
    },
    hideModal () {
      this.$refs.placeModal.hide()
    },
    dayOfWeek(day) {
      let weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
      let date = new Date
      return day === weekday[date.getDay()]
    },
    addSpecial() {
      let special = Object.assign({place_id: this.placeModal.place_id, name: this.placeModal.title, user_id: UserService.getUser().id}, this.addSpecialForm)
      this.$http.post('special/add', special).then(response => {
        this.placeDetails(this.placeModal.place_id)
        this.clearAddSpecialForm()
        this.modalAlert.show = true
        this.modalAlert.variant = 'primary'
        this.modalAlert.message = 'Special added! Thanks for your help! 👍 👍 👍'
      })
    },
    clearAddSpecialForm() {
        this.addSpecialForm.days_of_week =  []
        this.addSpecialForm.info =  null
        this.addSpecialForm.reoccuring =  false
        this.modalAlert.show = false
    },
    updateSearch() {
     this.$router.push({
        path: 'specials',
        query: {
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
    requestAccess () {
      this.$http.post('email/request', {email: this.requestAccessForm.email}).then(response => {
        this.requestAccessForm.email = ''
        this.modalAlert.show = true
        this.modalAlert.variant = 'success'
        this.modalAlert.message = 'We have recieved your request. Expect an email from Alphaity.io'
      }, err => {
        this.modalAlert.show = true
        this.modalAlert.variant = 'danger'
        this.modalAlert.message = 'Something happened on our end. Please try again or email Alphaity.io'
      })
    }
  },
  mounted () {
    this.feedMe()
  },
  computed: {
    hasPagination () {
      let result = false
      if (this.restaurants) {
        result = this.pagination.hasNextPage || false
      }
      return result
    },
    userAuthenticated() {
      return UserService.getUser()
    }
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

<style lang="scss" scoped>
@import './../assets/sass/specials.scss';
</style>