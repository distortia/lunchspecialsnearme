<template>
  <b-container fluid>
    <b-row align-v="center" align-h="center">
      <b-col md="4">
        <b-card header="Register"
              border-variant="primary"
              header-bg-variant="primary"
              header-text-variant="white"
              class="register-card">
          <p class="card-text">
            <b-form @submit="register">
              <b-form-group id="emailGroup"
                      label="Email address:"
                      label-for="email">
                <b-form-input id="email"
                        type="email"
                        v-model="form.email"
                        required
                        placeholder="Enter email">
                </b-form-input>
              </b-form-group>
              <b-form-group id="passwordGroup"
                      label="Password:"
                      label-for="password">
                <b-form-input id="password"
                        type="password"
                        v-model="form.password"
                        required
                        placeholder="Enter Password">
                </b-form-input>
              </b-form-group>
              <b-button type="submit" variant="primary" block>Register</b-button>
            </b-form>
          </p>
          <router-link to="/login" class="card-link">Or Login</router-link>
        </b-card>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
export default {

  name: 'Register',

  data () {
    return {
      form: {
        email: null,
        password: null
      }
    }
  },
  methods: {
    register() {
      console.log('fill me in')
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/sass/login';
</style>