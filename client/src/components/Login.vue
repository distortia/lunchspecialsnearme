<template>
  <b-container fluid>
    <b-row align-v="center" align-h="center">
      <b-col md="4">
        <b-card header="Login"
              border-variant="primary"
              header-bg-variant="primary"
              header-text-variant="white"
              class="login-card">
          <p class="card-text">
            <b-form action="">
              <b-form-group id="emailGroup"
                      label="Email address:"
                      label-for="email">
                <b-form-input id="email"
                        type="email"
                        v-model="credentials.email"
                        required
                        placeholder="Enter email">
                </b-form-input>
              </b-form-group>
              <b-form-group id="passwordGroup"
                      label="Password:"
                      label-for="password">
                <b-form-input id="password"
                        type="password"
                        v-model="credentials.password"
                        required
                        placeholder="Enter Password">
                </b-form-input>
              </b-form-group>
              <b-button type="submit" variant="primary" @click.prevent="login" block>Login</b-button>
            </b-form>
          </p>
        </b-card>
      </b-col>
    </b-row>
  </b-container>
</template>

<script>
import UserService from '../services/userService';
export default {

  name: 'Login',

  data () {
    return {
      credentials: {
        email: null,
        password: null
      }
    }
  },
  methods: {
    login() {
      this.$http.post('login', {"user": this.credentials})
        .then(data => {
          UserService.addUser(data.body);
          this.$parent.$emit('login:success');
          this.$router.push('/');
        });
      }
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/sass/login';
</style>
