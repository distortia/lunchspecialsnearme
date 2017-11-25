<template>
  <div>
    <b-navbar toggleable="md" type="light" variant="light" sticky @submit.prevent="search">
      <b-navbar-toggle target="nav-collapse"></b-navbar-toggle>
      <b-navbar-brand href="/">LSNM</b-navbar-brand>
      <b-button size="sm" class="my-2 my-sm-0" @click="feedbackModal = !feedbackModal" variant="outline-primary">Feedback</b-button>
      <b-collapse is-nav id="nav-collapse">
        <b-navbar-nav class="ml-auto">
          <b-nav-form>
            <b-form-input
              id="radius"
              type="number"
              v-model="form.radius"
              placeholder="Radius(miles)"
              size="sm"
              class="mr-sm-2"
              required></b-form-input>
            <b-form-input 
              id="keywords"
              type="text"
              v-model="form.keywords"
              placeholder="Mexican"
              class="mr-sm-2"
              size="sm"
              required></b-form-input>
            <b-button size="sm" type="submit" variant="outline-success">Search</b-button>
          </b-nav-form>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
    <div class="loading" v-show="loading">
      <i class="fa fa-cog fa-spin fa-3x fa-fw"></i>
      <span class="sr-only">Loading...</span>
    </div>
    <h1 v-if="restaurants">Currently displaying {{restaurants.length}} place(s) near you </h1>
    <b-container fluid>
      <b-row>
        <b-col cols="12" md="7">
          <div class="map-container">
            <div id="map"></div>
            <b-modal ref="placeModal" hide-footer :title="placeModal.title" lazy>
              <div class="d-block text-center">
                <p>{{placeModal.address}}</p>
                  <p>
                    <b-badge pill variant="warning">
                      Rating: {{placeModal.rating}} <i class="fa fa-star" aria-hidden="true"></i>
                    </b-badge>
                    <b-badge pill variant="success">Price Level: {{placeModal.price_level | expensivity }}</b-badge>
                  </p>
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
              </div>
              <b-btn variant="outline-danger" block @click="hideModal">Close</b-btn>
          </b-modal>
          </div>
        </b-col>
        <b-col md="5" cols="12">
          <div class="restaurant-cards-list">
            <div class="ad-container">
              <p>
                We try not to be intrusive with the ads.<br>Please consider disabling ad block.
                <i class="fa fa-frown-o" aria-hidden="true"></i>
              </p>
              <ins class="adsbygoogle"
                style="display:block"
                data-ad-client="ca-pub-1093990846577533"
                data-ad-slot="9354044408"
                data-ad-format="auto"
                ref="googleAds">
              </ins>
            </div>
            <div v-for="(restaurant, index) in restaurants">
                <b-card :title="`${index + 1}: ${restaurant.name}`"
                        :sub-title="restaurant.vicinity">
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
                </b-card>
            </div> 
          </div>
          <div class="pagination-container" v-if="hasPagination">
            <b-button @click="paginate" variant="primary btn-block">Show More</b-button>
          </div>
            <!-- Only show if there are restaurants and there is no more pagination -->
            <b-alert show v-else v-show="restaurants" variant="warning">All results are displayed</b-alert>
        </b-col>
      </b-row>
    </b-container>
    <b-modal 
      v-model="feedbackModal"
      title="Feedback"
      @ok="handleOk"
      @shown="clearFeedback"
      ref="feedbackModal">
      <form @submit.stop.prevent="handleSubmit">
        <b-form-textarea
           v-model.trim="feedback"
           placeholder="Enter Feedback"
           :rows="3"></b-form-textarea>
        </form>
    </b-modal>
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
      pagination: null,
      placeModal: {},
      form: {
        location: null,
        radius: this.$route.query.radius || null,
        keywords: this.$route.query.keywords || null
      },
      feedbackModal: false,
      feedback: ''
    }
  },
  methods: {
    search () {
      this.$router.push({
        path: 'specials',
        query: {
          // location: this.form.location.replace(/ /g, '+'),
          keywords: encodeURIComponent(this.form.keywords),
          radius: this.form.radius
        }
      })
    },
    feedMe () {
      this.loading = true
      this.restaurants = null
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
          icon: 'https://maps.google.com/mapfiles/ms/icons/yellow-dot.png',
          map: map
        })
        this.map = map

        let service = new google.maps.places.PlacesService(map)

        service.nearbySearch({
          location: { lat: position.coords.latitude, lng: position.coords.longitude },
          radius: this.$route.query.radius * 1509,
          type: ['restaurant'],
          openNow: true,
          keyword: this.$route.query.keywords
        }, this.parsePlaces)
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
      this.pagination = pagination
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
      let service = new google.maps.places.PlacesService(this.map)
      service.getDetails({ placeId: placeId }, place => {
        this.placeModal = {
          phoneNumber: place.international_phone_number,
          address: place.formatted_address,
          title: place.name,
          price_level: place.price_level,
          rating: place.rating,
          website: place.website,
          reviews: place.reviews,
          photos: place.photos,
          url: place.url,
          openingHours: place.opening_hours.weekday_text
        }
      })
    },
    showModal (place) {
      this.placeDetails(place.place_id)
      this.$refs.placeModal.show()
    },
    hideModal () {
      this.$refs.placeModal.hide()
    },
    adblocked () {
      return this.$refs.googleAds.offsetHeight === 0
    },
    clearFeedback () {
      this.feedback = ''
    },
    handleOk (evt) {
      evt.preventDefault()
      if (!this.feedback) {
        alert('Please enter feedback')
      } else {
        this.handleSubmit()
      }
    },
    handleSubmit () {
      const msg = {
        to: 'nickstalter@gmail.com',
        from: 'feedback@lunchspecialsnearme.com',
        subject: 'New Feedback',
        text: this.feedback
      }
      this.$http.post('https://api.sendgrid.com/v3/mail/send', msg).then(success => {
        console.log('message sent', success)
      }, err => {
        console.log('err', err)
      })
      this.clearFeedback()
      this.$refs.feedbackModal.hide()
    }
  },
  mounted () {
    this.feedMe()
  },
  computed: {
    hasPagination () {
      let result = false
      if (this.restaurants) {
        result = this.pagination.hasNextPage
      }
      return result
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