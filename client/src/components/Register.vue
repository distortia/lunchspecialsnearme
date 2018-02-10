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
              <b-alert variant="danger"
                       v-if="this.registerError">
                       {{registerError}}
              </b-alert>
              <b-form-group id="usernameGroup"
                      label="Username"
                      label-for="username">
                <b-form-input id="username"
                        type="text"
                        v-model="form.username"
                        required
                        placeholder="Enter Username">
                </b-form-input>
              </b-form-group>
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
                        label="Password: "
                        label-for="password">
                  <b-form-input id="password"
                          pattern=".{8,}"
                          type="password"
                          v-model="form.password"
                          required title="8 characters minimum"
                          placeholder="Enter Password"
                          :state="doPasswordsMatch()">
                  </b-form-input>
                </b-form-group>
                <b-form-group id="confirmPasswordGroup"
                        label="Confirm Password:"
                        label-for="confirm-password">
                  <b-form-input id="confirm-password"
                          pattern=".{8,}"
                          type="password"
                          v-model="form.confirmPassword"
                          required title="8 characters minimum"
                          placeholder="Confirm Password"
                          :state="doPasswordsMatch()">
                  </b-form-input>
                  <span v-if="doPasswordsMatch() === false" class="password-text">Passwords Must Match</span>
                </b-form-group>
              <b-button :disabled="doPasswordsMatch() === false" type="submit" variant="primary" block>Register</b-button>
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
        username: null,
        email: null,
        password: null,
        confirmPassword: null,
      },
      registerError: null,
    }
  },
  methods: {
    register(event) {
      event.preventDefault();
      const {username, email, password} = this.form;
      this.$http.post('user/register', {"user": { username, email, password } }).then(({body}) => {
        this.$parent.$emit('register:success');
        this.$router.push('/login');
      }).catch(error=> {
        if(error.status === 422){
            const { body: { errors } } = error;
            const errorKey = Object.keys(errors)[0];
            this.registerError = `${errorKey} ${errors[errorKey][0]}`;
        }
      });
    },
    doPasswordsMatch() {
      if(this.form.password || this.form.confirmPassword){
        return this.form.password === this.form.confirmPassword ? null : false;
      }
      return null;
    }
  }
}
</script>

<style lang="scss" scoped>
@import '../assets/sass/login';
.password-text {
  font-size: 12px;
  color: red;
}
.alert::first-letter {
  text-transform: capitalize;
}
</style>
