import Vue from 'vue'
import Router from 'vue-router'
import Index from '@/components/Index'
import Specials from '@/components/Specials'
import Login from '@/components/Login'
import Register from '@/components/Register'
import Profile from '@/components/Profile'
import UserService from '@/services/userService.js'

const requireAuth = (to, _from, next) => {
  if(UserService.getUser()) {
    next() 
  } else {
    next({ path: 'login' })
  }
}

const afterAuth = (_to, from, next) => {
  if(getUser()) {
    next(from.path)
  } else {
    next()
  }
}

const routes = [
    { path: '/', name: 'index', component: Index },
    { path: '/specials', name: 'Specials', component: Specials },
    { path: '/login', name: 'Login', component: Login },
    { path: '/register', name: 'Register', component: Register },
    { path: '/profile', name: 'Profile', component: Profile, beforeEnter: requireAuth },
    { path: '*', redirect: '/'}
  ]

export default routes