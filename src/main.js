// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import router from './router'
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
// import 'bootstrap/dist/css/bootstrap.css'
// import 'bootstrap-vue/dist/bootstrap-vue.css'

Vue.use(BootstrapVue)
Vue.use(VueResource)

Vue.config.productionTip = false
// Sendgrid api key
// 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
Vue.http.headers.common['Access-Control-Allow-Origin'] = '*'

Vue.http.interceptors.push((request, next) => {
  if (request.url.includes('sendgrid')) {
    request.credentials = true
    request.headers.set('Authorization', 'Bearer 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')
    request.headers.set('Content-Type', 'application/json')
  }
  next()
})
// Google Places api key
// AIzaSyDcr5TVxlv4QivDB2rd-pe3LzgpTQ6YwnE
/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})
