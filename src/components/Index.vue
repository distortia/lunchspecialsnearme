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
                LSNM is for the 9 to 5 heroes looking to change up their daily routines and expand their culinary tastes. Explore the best of what your city has to offer. Share some of your favorite places so other can indulge in the same.
              </p>
            </div>
          </b-col>
          <b-col cols="12" md="6">
            <b-card class="text-center">
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
                <b-button type="submit" variant="primary" class="btn-block">Search</b-button>
              </b-form>
            </b-card>
          </b-col>
        </b-row>
      </b-container>
    </div>
  </div>
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

<style lang="scss">
@import './../assets/sass/index.scss';
</style>