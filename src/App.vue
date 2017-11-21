<template>
  <div id="app">
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
/* https://stackoverflow.com/a/13172336*/
/* for full height browser window*/
html {
  height: 100%;
}
body {
  min-height: 100%;
}
.loading i, .loading span {
  z-index: 100;
  position: absolute;
  top: 50%;
  left: 50%;
  margin: -50px 0px 0px -50px;
}
</style>
