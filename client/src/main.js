// The Vue build version to load with the `import` command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from 'vue'
import App from './App'
import BootstrapVue from 'bootstrap-vue'
import VueResource from 'vue-resource'
import VueRouter from 'vue-router'
import UserService from './services/userService'
import routes from './router/index'
import mobileMixin from './util/mobileMixin'

Vue.use(VueRouter)
Vue.use(BootstrapVue)
Vue.use(VueResource)

const router = new VueRouter({
  routes,
  mode: 'history'
})

Vue.config.productionTip = false

Vue.http.options.root = (process.env.API_HOST || 'http://localhost') + ':' + (process.env.API_PORT || '4000') + '/api'

Vue.http.headers.common['Content-Type'] = 'application/json'

Vue.http.interceptors.push((request, next) => {
  const jwt = UserService.getJwt();
  if(jwt){
    request.headers.set('Authorization', `Bearer ${jwt}`);
  }
  next();
});

Vue.mixin(mobileMixin)

/* eslint-disable no-new */
new Vue({
  el: '#app',
  router,
  template: '<App/>',
  components: { App }
})
