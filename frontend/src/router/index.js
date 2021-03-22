import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/views/Home'
import SignUp from '@/views/SignUp'
import LogIn from '@/views/LogIn'

Vue.use(Router)

export default new Router({
  mode: 'history',
  routes: [
    {
      path: '/',
      name: 'Home',
      component: Home
    },
    {
      path: '/signup',
      name: 'SignUp',
      component: SignUp
    },
    {
      path: '/login',
      name: 'Login',
      component: LogIn
    }
  ]
})
