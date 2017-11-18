<template>
  <div id="app">
    <b-navbar type="light" variant="light" sticky @submit.prevent="search">
      <b-navbar-brand href="/">LSNM</b-navbar-brand>
      <b-nav-form>
        <b-form-input
          id="radius"
          type="number"
          v-model="form.radius"
          placeholder="Radius(miles)"
          size="sm"
          class="mr-sm-2"
          required></b-form-input>
        <b-form-input 
          id="keywords"
          type="text"
          v-model="form.keywords"
          placeholder="Mexican"
          class="mr-sm-2"
          size="sm"
          required></b-form-input>
        <b-button size="sm" type="submit" variant="outline-success">Search</b-button>
      </b-nav-form>
    </b-navbar>
    <router-view></router-view>
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
      }
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
    }
  }
}
</script>

<style lang="scss">
</style>
