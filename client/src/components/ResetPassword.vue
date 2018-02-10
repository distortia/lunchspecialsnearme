<template>
  <b-container fluid>
    <b-row align-v="center" align-h="center">
      <b-col md="4">
        <b-card header="Reset Password"
              border-variant="primary"
              header-bg-variant="primary"
              header-text-variant="white"
              class="reset-password-card">
          <p class="card-text">
            <b-form @submit.prevent="resetPassword">
              <b-alert variant="info"
                       :show="this.resetMessage.show">
                       {{resetMessage.info}}
              </b-alert>
              <b-form-group id="emailGroup"
                      label="Email address:"
                      label-for="email">
                <b-form-input id="email"
                        type="email"
                        v-model="reset.email"
                        required
                        placeholder="Enter email" required>
                </b-form-input>
              </b-form-group>
              <b-button type="submit" variant="primary" block>Send</b-button>
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

  name: 'ResetPassword',

  data () {
    return {
      resetMessage: {
        info: null,
        show: false
      },
      reset: {
        email: null
      }
    }
  },
  methods: {
    resetPassword() {
      console.log(this.reset.email)
      this.$http.post('user/reset', {email: this.reset.email}).then(response => {
        this.resetMessage.show = true
        this.resetMessage.info = `Password reset instructions have been sent to ${this.reset.email}`
        this.reset.email = null
      })
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/sass/login';
</style>