import Vue from "vue";
import Vuex from "vuex";
import auth from "./modules/auth";
import audiences from "./modules/audiences";
Vue.use(Vuex);

export default new Vuex.Store({
  modules: {
    auth,
    audiences,
  },
});
