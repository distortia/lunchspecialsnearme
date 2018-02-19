<template>
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
                <b-form-checkbox-group :stacked="isMobile()" buttons button-variant="primary" v-model="addSpecialForm.days_of_week" :options="daysOfWeek" :class="{'w-100': isMobile()}">
                </b-form-checkbox-group>
              </b-form-group>
              <b-form-textarea v-model="addSpecialForm.info" placeholder="Enter Special Info Here :)" :rows="3" :max-rows="6" required></b-form-textarea>
              <div>
                <b-button type="submit" variant="primary" class="w-100">Submit</b-button>
              </div>
            </b-form>
          </div>
          <div v-else>
            <p>We are currently in early alpha. Contact us to request access!</p>
            <p>If you already have an account. Please <b-link to="login">log in</b-link>. Or <b-link to="register">register here</b-link></p>
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
</template>

<script>
import UserService from '@/services/userService'
export default {

  name: 'placeModal',

  data () {
    return {
      addSpecialForm: {
        days_of_week: [],
        info: null,
      },
    }
  },
  props: ['specials', 'hasSpecial', 'placeModal', 'daysOfWeek'],
  methods: {
    dayOfWeek(day) {
      let weekday = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
      let date = new Date
      return day === weekday[date.getDay()]
    },
    clearAddSpecialForm() {
      this.addSpecialForm.days_of_week =  []
      this.addSpecialForm.info =  null
      this.addSpecialForm.reoccuring =  false
    },
    addSpecial() {
      let special = Object.assign({place_id: this.placeModal.place_id, name: this.placeModal.title, user_id: UserService.getUser().id}, this.addSpecialForm)
      this.$http.post('special/add', special).then(response => {
        this.$root.$emit('specialAdded')
        this.clearAddSpecialForm()
      })
    },
  },
  computed: {
    userAuthenticated() {
      return UserService.getUser()
    }
  },
}
</script>

<style lang="scss">
</style>