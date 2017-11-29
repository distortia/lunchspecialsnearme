// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import VueAnalytics from 'vue-analytics'

Vue.use(BootstrapVue)
Vue.use(VueResource)
Vue.use(VueAnalytics, {
  id: 'UA-90321609-3',
  checkDuplicatedScript: true
})

Vue.config.productionTip = false
// Google Places api key
// AIzaSyDcr5TVxlv4QivDB2rd-pe3LzgpTQ6YwnE
/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})
