<template>
  <div>
    <!-- <b-form @submit="feedMe"> -->
      <b-form>
      <b-form-group
        id="locationGroup"
        label="Location"
        label-for="location">
        <b-form-input
          id="location"
          type="input"
          v-model="form.location"
          placeholder="Columbus Oh"
          required></b-form-input>
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
        label="Categories" 
        label-for="keywords">
        <b-form-input 
          id="keywords"
          type="text" 
          v-model="form.keywords"
          placeholder="Mexican"
          required></b-form-input>
        </b-form-group>
      <!-- <b-button type="submit" variant="primary" @click="feedMe">Submit</b-button> -->
      <b-button variant="primary" @click="feedMe">Submit</b-button>
    </b-form>
  </div>
</template>
  <script>
    const apiKey = 'AIzaSyDcr5TVxlv4QivDB2rd-pe3LzgpTQ6YwnE'
    export default {

      name: 'Index',

      data () {
        return {
          form: {
            location: null,
            radius: null,
            keywords: null
          }
        }
      },
      methods: {
        feedMe () {
          const keywords = encodeURIComponent(this.form.keywords)
          const location = this.form.location.replace(/ /g, '+')
          const meters = this.form.radius * 1509
          this.$http.get(`https://maps.googleapis.com/maps/api/geocode/json?key=${apiKey}&address=${location}`).then(response => {
            const geolocation = `${response.body.results[0].geometry.location.lat},${response.body.results[0].geometry.location.lng}`
            console.log('next request', `https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=${apiKey}&location=${geolocation}&radius=${meters}&type=restaurant&keyword=${keywords}&opennow=true`)
            // and into another fucking promise \ 0 / praise javascript
            this.$http.get(`https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=${apiKey}&location=${geolocation}&radius=${meters}&type=restaurant&keyword=${keywords}&opennow=true`).then(resp => {
              console.log('resp.body', resp.body)
              // this.$router.push('specials', resp)
            }, error => {
              console.log(error)
            })
          }, error => {
            console.log(error)
          })
        }
      }
    }
  </script>

  <style lang="sass" scoped>
  @import './../assets/sass/index.scss';
  </style>