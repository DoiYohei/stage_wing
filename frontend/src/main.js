import Vue from 'vue'
import App from './App'
import router from './router'
import store from './store'
import VueYoutube from './plugins/vue-youtube'

Vue.config.productionTip = false

store.dispatch('autoLogin')

new Vue({
  VueYoutube,
  store,
  router,
  render: h => h(App)
}).$mount('#app')
