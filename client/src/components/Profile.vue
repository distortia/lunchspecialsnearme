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
                <div v-for="(value, stat) in user.stats">
                  {{ stat | formatStatTitle }}- {{ value }}
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
          </b-tab>
          <b-tab title="Specials">
            List of all currently active specials
            <b-table striped hover :items="[...specials]" :fields="fields">
              <template slot="support" slot-scope="data">
                <b-button size="sm" variant="info" class="mr-2" @click="showEditSpecialModal(data.item)">Edit</b-button>
                <b-button size="sm" variant="danger" @click.stop="deleteSpecial(data.item.id)" class="mr-2">Delete</b-button>
              </template>
            </b-table>
          </b-tab>
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
            <b-alert :show="showErrorAlert" variant="danger" @dismissed="showErrorAlert=false" dismissible>
              <div v-for="(error, errorType) in message">
                {{errorType}} - {{error}}
              </div>
          </b-alert>
        </b-tabs>
      </b-card>
      <b-modal ref="editSpecialModal" title="Editing Special" hide-footer lazy>
        <b-form @submit.prevent="editSpecial" class="text-center">
          <b-form-group label="Day(s) of the Week">
            <b-form-select v-model="specialForm.day_of_week" :options="daysOfWeek" class="mb-3"/>
          </b-form-group>
          <b-form-group label="Special Info">
            <b-form-textarea v-model="specialForm.info" placeholder="Enter Special Info Here :)" :rows="3" :max-rows="6" required></b-form-textarea>
          </b-form-group>
          <div>
            <b-button type="submit" variant="primary" class="btn-block">Submit</b-button>
          </div>
        </b-form>
      </b-modal>
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
      dismissCountDown: 0,
      showErrorAlert: false,
      specials: {},
      fields: [
        { key: 'place_id', label: 'Place Id' },
        'id',
        'name',
        'info',
        { key: 'day_of_week', label: 'Day Of Week' },
        { key: 'support', label: 'Support'}
      ],
      showModal: false,
      specialForm: {
        place_id: null,
        name: null,
        info: null,
        day_of_week: null,
        id: null
      },
      daysOfWeek: ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday'],
    }
  },
  methods: {
    populateProfile() {
      this.user = UserService.getUser()
    },
    updateUser() {
      this.showErrorAlert = false
      this.$http.put('user', {'user': this.user}).then(response => {
        UserService.addUser(response.body.data)
        this.showAlert()
        this.message = "Profile Updated!"
      }, err => {
        this.showErrorAlert = true
        this.message = err.body.errors
      })
    },
    fetchSpecials() {
      this.$http.get(`special/user/${this.user.id}`).then(response => {
        this.specials = response.body.data
      })
    },
    countDownChanged (dismissCountDown) {
      this.dismissCountDown = dismissCountDown
    },
    showAlert () {
      this.dismissCountDown = this.dismissSecs
    },
    editSpecial() {
      console.log(this.specialForm)
      this.$http.put(`special/edit/${this.specialForm.id}`, this.specialForm).then(response => {
          this.showAlert()
          this.message = "Special Edited!"
          this.fetchSpecials()
          this.hideEditSpecialModal()
      })
    },
    deleteSpecial(id) {
      if (confirm('Are you sure you want to delete this special?')) {
        this.$http.delete(`special/delete/${id}`).then(response => {
          this.showAlert()
          this.message = "Special Deleted!"
          this.fetchSpecials()
        })
      }
    },
    showEditSpecialModal(special) {
      this.specialForm = Object.assign(this.specialForm, special)
      this.$refs.editSpecialModal.show()
    },
    hideEditSpecialModal() {
      this.$refs.editSpecialModal.hide()
    }
  },
  created() {
    this.populateProfile()
    this.fetchSpecials()
  },
  filters: {
    formatStatTitle(statTitle) {
      statTitle = statTitle.replace(/_/, ' ')
      return statTitle.split(' ').map((str) => str.charAt(0).toUpperCase() + str.substr(1)).join(' ')
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/sass/profile';
</style>