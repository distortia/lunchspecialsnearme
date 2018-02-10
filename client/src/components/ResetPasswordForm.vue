<template>
  <b-container fluid>
    <b-row align-v="center" align-h="center">
      <b-col md="4">
        <b-card header="Update Password"
              border-variant="primary"
              header-bg-variant="primary"
              header-text-variant="white"
              class="reset-password-card">
          <p class="card-text">
            <b-form @submit.prevent="updatePassword">
              <b-alert variant="info"
                       :show="this.updateMessage.show">
                       {{updateMessage.info}}
                       <b-link to="/login">Login Here</b-link>
              </b-alert>
              <b-form-group id="updateGroup"
                      label="New Password:"
                      label-for="password">
                <b-form-input id="password"
                        type="password"
                        v-model="update.password"
                        minlength="8"
                        required
                        placeholder="Enter New Password" required>
                </b-form-input>
              </b-form-group>
              <b-button type="submit" variant="primary" block>Update</b-button>
            </b-form>
            <b-link to="/login">Login</b-link>
          </p>
        </b-card>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
export default {

  name: 'ResetPasswordForm',

  data () {
    return {
      temp_id: this.$route.params.temp_id,
      update: {
        password: null
      },
      updateMessage: {
        show: false,
        info: null
      }
    }
  },
  methods: {
    updatePassword() {
      this.$http.post(`user/reset/${this.temp_id}`, {password: this.update.password}).then(response => {
        this.updateMessage.show = true
        this.updateMessage.info = 'Password has been updated!'
        this.update.password = null
      })
    },
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/sass/login';
</style>