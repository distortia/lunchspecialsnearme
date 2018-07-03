<template>
  <div class="index-image-wrapper">
    <div class="index-wrapper">
      <b-container class="home-container">
        <b-row align-v="center">
          <b-col class="text-center" cols="12" md="6">
            <div class="home-content">
              <h1>Lunch Specials Near Me</h1>
              <p>Linking Local Restaurants with Local Stomachs</p>
              <p>
                LSNM is for the 9 to 5 heroes looking to change up their daily routines and expand their culinary tastes. Explore the best of what your city has to offer. Share some of your favorite places so others can indulge in the same.
              </p>
              <p>
                What do your taste buds want to explore today?
              </p>
            </div>
          </b-col>
          <b-col cols="12" md="6">
            <b-card class="text-center">
              <b-form @submit.prevent="submit">
                <b-form-group
                  id="locationGroup"
                  label="Address or ZipCode"
                  label-for="location">
                  <b-input-group>
                    <b-form-input
                      id="location"
                      type="text"
                      v-model.lazy.trim="form.location"
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
                  id="radiusGroup"
                  label="Search Radius(Miles)"
                  label-for="radius">
                  <b-form-input
                    id="radius"
                    type="number"
                    v-model="form.radius"
                    placeholder="5"
                    required></b-form-input>
                </b-form-group>
                <b-form-group 
                  id="keywordGroup"
                  label="Categories or Restaurant - Leave blank for all results"
                  label-for="keywords">
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
                </ul>
                <b-button type="submit" variant="primary" class="btn-block">Search</b-button>
              </b-form>
              <b-alert :show="noLocation" variant="warning" dismissible @dismissed="noLocation = false">Location fetching failed. Please enable location services and try again.</b-alert>
            </b-card>
          </b-col>
        </b-row>
      </b-container>
    </div>
  </div>
</template>
<script>
import LocationService from '@/services/locationService'

  export default {

    name: 'Index',

    data () {
      return {
        form: {
          location: null,
          radius: null,
          keywords: null
        },
        noLocation: false,
        loadingLocation: false,
        autocomplete: {
          items: [],
          visible: false
        }
      }
    },
    methods: {
      submit () {
        this.$router.push({
          path: 'specials',
          query: {
            location: this.form.location.replace(/ /g, '+'),
            keywords: this.form.keywords,
            radius: this.form.radius
          }
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
      },
      setAsKeyWord(keyword) {
        this.form.keywords = keyword
        this.autocomplete.items = []
      },
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

<style lang="scss" scoped>
@import './../assets/sass/index.scss';
</style>