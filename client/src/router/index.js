import Vue from 'vue'
import Router from 'vue-router'
import Index from '@/components/Index'
import Specials from '@/components/Specials'
import Login from '@/components/Login'

Vue.use(Router)

export default new Router({
  routes: [
    { path: '/', name: 'index', component: Index },
    { path: '/specials', name: 'Specials', component: Specials },
    { path: '/login', name: 'Login', component: Login }
  ]
})
