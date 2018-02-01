<template>
  <b-container>
    <b-row>
      <h1>Profile</h1>
    </b-row>
    <b-row v="center" align-h="center">
      <b-card no-body>
        <b-tabs pills card>
          <b-tab title="Info" active>
            <div class="user-info">
              <div>Username: {{user.username}}</div>
              <div>Email: {{user.email}}</div>
              <div>
                Stats: 
                <div v-for="stat in user.stats">
                  stat
                </div>
              </div>
            </div>
          </b-tab>
          <b-tab title="Account">
            <p>Update one or both ¯\_(ツ)_/¯</p>
            <b-form @submit.prevent="updateUser">
              <b-form-group
                label="Update Email"
                label-for="email">
                <b-form-input
                  id="email"
                  type="email"
                  v-model="user.email">
                </b-form-input>
              </b-form-group>
              <b-form-group
                label="Update Password"
                label-for="password">
                <b-form-input
                  id="password"
                  type="password"
                  v-model="user.password">
                </b-form-input>
              </b-form-group>
              <b-button type="submit" variant="primary">Update</b-button>
            </b-form>
            <b-alert :show="dismissCountDown"
                     dismissible
                     variant="success"
                     @dismissed="dismissCountdown=0"
                     @dismiss-count-down="countDownChanged">
               {{message}}
              <b-progress variant="warning"
                  :max="dismissSecs"
                  :value="dismissCountDown"
                  height="4px">
              </b-progress>
            </b-alert>
          </b-tab>
        </b-tabs>
      </b-card>
    </b-row>
  </b-container>
</template>

<script>
import UserService from '../services/userService'
export default {

  name: 'Profile',

  data () {
    return {
      user: {},
      message: null,
      dismissSecs: 5,
      dismissCountDown: 0
    }
  },
  methods: {
    populateProfile() {
      // this.$http.get('/user/' {user: {}})
      // Merge the users together and save into the localstorage
      this.user = UserService.getUser()
    },
    updateUser() {
      console.log(this.user)
      this.showAlert()
      this.message = "Profile Updated!"
    },
    countDownChanged (dismissCountDown) {
      this.dismissCountDown = dismissCountDown
    },
    showAlert () {
      this.dismissCountDown = this.dismissSecs
    }
  },
  created() {
    this.populateProfile()
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/sass/profile';
</style>