import Vue from 'vue'
import Router from 'vue-router'
import Home from '@/views/Home'
import SignUp from '@/views/Auth/SignUp'
import LogIn from '@/views/Auth/LogIn'
import EventsIndex from '@/views/Events/EventsIndex'
import EventsShow from '@/views/Events/EventsShow'
import EventsEdit from '@/views/Events/EventsEdit'
import EventsNew from '@/views/Events/EventsNew'
import BandsIndex from '@/views/Bands/BandsIndex'
import BandsShow from '@/views/Bands/BandsShow'
import BandsEdit from '@/views/Bands/BandsEdit'

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
      name: 'LogIn',
      component: LogIn
    },
    {
      path: '/events',
      name: 'EventsIndex',
      component: EventsIndex
    },
    {
      path: '/events/:id',
      name: 'EventsShow',
      component: EventsShow,
      props: true
    },
    {
      path: '/events/:id/edit',
      name: 'EventsEdit',
      component: EventsEdit,
      props: true
    },
    {
      path: '/event/new',
      name: 'EventsNew',
      component: EventsNew
    },
    {
      path: '/bands',
      name: 'BandsIndex',
      component: BandsIndex
    },
    {
      path: '/bands/:id',
      name: 'BandsShow',
      component: BandsShow,
      props: true
    },
    {
      path: '/bands/:id/edit',
      name: 'BandsEdit',
      component: BandsEdit
    }
  ]
})
