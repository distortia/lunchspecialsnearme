<template>
  <div id="app">
    <b-navbar toggleable="md" type="dark" variant="primary" sticky>
      <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>
      <b-navbar-brand to="/">LSNM</b-navbar-brand>
      <b-collapse is-nav id="nav_collapse">
        <b-navbar-nav>
          <b-nav-item to="/">Home</b-nav-item>
        </b-navbar-nav>
        <b-navbar-nav class="ml-auto">
          <b-button size="sm" class="my-2 my-sm-0" @click="feedbackModal = !feedbackModal" variant="outline-light">Feedback</b-button>
          <div id="user-header-wrapper" v-if="isLoggedIn">
            <b-nav-item to="/profile">Hello, {{user.username || user.email}}!</b-nav-item>
            <b-nav-item @click.prevent="logout">Logout</b-nav-item>
          </div>
          <template v-else>
            <b-nav-item to="/login">Login</b-nav-item>
            <b-nav-item to="/register">Register</b-nav-item>
          </template>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
    <div class="success-alert" v-if="successMessage">
      <b-alert dismissible variant="success" show>{{successMessage}}</b-alert>
    </div>
    <transition name="fade">
      <router-view></router-view>
    </transition>
    <b-modal
      v-model="feedbackModal"
      title="Feedback"
      @ok="handleOk"
      @shown="clearFeedback"
      ref="feedbackModal">
      <b-alert variant="success" :show="feedbackSent" @dismissed="feedbackSent=false" dismissible>Thanks for your feedback! We appreciate it!</b-alert>
      <form @submit.stop.prevent="handleSubmit">
        <b-form-group id="emailGroup"
                    label="Email address:"
                    label-for="feedbackEmail">
          <b-form-input id="feedbackEmail"
                        type="email"
                        v-model="feedback.email"
                        required
                        placeholder="Enter email">
          </b-form-input>
        </b-form-group>
        <b-form-textarea
          v-model="feedback.info"
          placeholder="Enter Feedback or recommendations"
          rows="3">
        </b-form-textarea>
      </form>
    </b-modal>
  </div>
</template>

<script>
import 'bootstrap/dist/css/bootstrap.css'
import 'bootstrap-vue/dist/bootstrap-vue.css'
import UserService from './services/userService';

export default {
  name: 'app',
  data () {
    return {
      user: UserService.getUser(),
      isLoggedIn: UserService.isLoggedIn(),
      successMessage: null,
      feedbackModal: false,
      feedbackSent: false,
      feedback: {
        info: '',
        email: ''
      }
    }
  },
  created() {
    this.$on('login:success', () => {
      this.user = UserService.getUser();
      this.isLoggedIn = UserService.isLoggedIn();
    });
    this.$on('register:success', () => {
      this.successMessage = "Registration Successful! You may now log in!"
    });
  },
  methods: {
    logout() {
      this.$http.post('logout', {"user": this.credentials})
        .then(data => {
          UserService.removeUser();
          this.user = null;
          this.isLoggedIn = false;
          this.$router.push('/');
        });
    },

    clearFeedback () {
      this.feedback.info = ''
      this.feedback.email = ''
    },
    handleOk (event) {
      event.preventDefault ()
      if (!this.feedback.info) {
        alert('Please enter your feedback')
      } else {
        this.handleSubmit()
      }
    },
    handleSubmit () {
      this.$http.post('email/feedback', {feedback: this.feedback}).then(response => {
        this.feedbackSent = true
      })
      this.clearFeedback ()
    },
  },
}
</script>

<style lang="scss">
@import './assets/sass/app';
#user-header-wrapper {
  display: inherit;
}
.success-alert{
  text-align: center;
  .alert {
    margin: 0;
  }
}
</style>
