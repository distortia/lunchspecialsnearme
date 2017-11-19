<template>
  <b-form @submit.prevent="submit">
<!--     <b-form-group
      id="locationGroup"
      label="Location"
      label-for="location">
      <b-form-input
        id="location"
        type="input"
        v-model="form.location"
        placeholder="123 park place columbus oh"
        required></b-form-input>
      <b-input-group-button slot="right">
        <b-btn variant="info">Location</b-btn>
      </b-input-group-button>
    </b-form-group> -->
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
    <b-button type="submit" variant="primary">Submit</b-button>
  </b-form>
</template>
  <script>
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
        submit () {
          this.$router.push({
            path: 'specials',
            query: {
              // location: this.form.location.replace(/ /g, '+'),
              keywords: encodeURIComponent(this.form.keywords),
              radius: this.form.radius
            }
          })
        }
      }
    }
  </script>

  <style>
  /*@import './../assets/sass/index.scss';*/
  </style>