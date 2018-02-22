// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import Ads from 'vue-google-adsense'
import UserService from './services/userService'
import routes from './router/index'
import mobileMixin from './util/mobileMixin'

Vue.use(VueRouter)
Vue.use(BootstrapVue)
Vue.use(VueResource)

Vue.use(require('vue-script2'))

Vue.use(Ads.Adsense)
Vue.use(Ads.InArticleAdsense)
Vue.use(Ads.InFeedAdsense)

const router = new VueRouter({
  routes,
  mode: 'history'
})

Vue.config.productionTip = false
Vue.http.options.root = window.location.hostname === 'localhost' ? 'http://localhost:4000/api' : 'https://api.alphaity.io/api'

Vue.http.headers.common['Content-Type'] = 'application/json'

Vue.http.interceptors.push((request, next) => {
  const jwt = UserService.getJwt();
  if(jwt){
    request.headers.set('Authorization', `Bearer ${jwt}`);
  }
  next();
});

Vue.mixin(mobileMixin)

Vue.filter('expensivity', (value) => {
    switch (value) {
      case 0:
        return 'Free'
      case 1:
        return 'Inexpensive'
      case 2:
        return 'Moderate'
      case 3:
        return 'Expensive'
      case 4:
        return 'Very Expensive'
      case undefined || null:
        return 'Unknown'
      default: 'Unknown'
    }
})

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})
