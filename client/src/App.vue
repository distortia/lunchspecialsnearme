<template>
  <div id="app">
    <b-navbar toggleable="md" type="dark" variant="primary">
      <b-navbar-toggle target="nav_collapse"></b-navbar-toggle>
      <b-navbar-brand to="/" exact>LSNM</b-navbar-brand>
      <b-collapse is-nav id="nav_collapse">
        <b-navbar-nav>
          <b-nav-item to="/" exact>Home</b-nav-item>
        </b-navbar-nav>
        <b-navbar-nav class="ml-auto">
          <b-button size="sm" class="my-2 my-sm-0" @click="feedbackModal = !feedbackModal" variant="outline-light">Feedback</b-button>
          <b-nav-item to="/login">Login</b-nav-item>
          <b-nav-item to="/register">Register</b-nav-item>
        </b-navbar-nav>
      </b-collapse>
    </b-navbar>
    <transition name="fade">
      <router-view></router-view>
    </transition>
    <b-modal 
      v-model="feedbackModal"
      title="Feedback"
      @ok="handleOk"
      @shown="clearFeedback"
      ref="feedbackModal">
      <b-alert variant="success" :show="feedbackSent" dismissible>Thanks for your feedback! We appreciate it!</b-alert>
      <form @submit.stop.prevent="handleSubmit">
        <b-form-textarea
          v-model="feedback"
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

export default {
  name: 'app',
  data () {
    return {
      form: {
        location: null,
        radius: null,
        keywords: null
      },
      feedbackModal: false,
      feedback: '',
      feedbackSent: false,
    }
  },
  methods: {
    search () {
      this.$router.push({
        path: 'specials',
        query: {
          // location: this.form.location.replace(/ /g, '+'),
          keywords: encodeURIComponent(this.form.keywords),
          radius: this.form.radius
        }
      })
    },
    clearFeedback () {
      this.feedback = ''
    },
    handleOk (event) {
      event.preventDefault ()
      if (!this.feedback) {
        alert('Please enter your feedback')
      } else {
        this.handleSubmit()
      }
    },
    handleSubmit () {
      this.$http.post('email/feedback',{feedback: this.feedback}).then(response => {
        this.feedbackSent = true
      })
      this.clearFeedback ()
    },
  }
}
</script>

<style lang="scss">
@import './assets/sass/app';
</style>
