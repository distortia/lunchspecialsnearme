import Vue from 'vue'
import Router from 'vue-router'
import Index from '@/components/Index'
import Specials from '@/components/Specials'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    { path: '/', name: 'index', component: Index },
    { path: '/specials', name: 'Specials', component: Specials }
  ]
})
