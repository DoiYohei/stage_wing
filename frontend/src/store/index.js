import Vue from 'vue'
import Vuex from 'vuex'
import auth from './modules/auth'
import bands from './modules/bands'
import events from './modules/events'

Vue.use(Vuex)

export default new Vuex.Store({
  modules: {
    auth,
    bands,
    events
  }
})