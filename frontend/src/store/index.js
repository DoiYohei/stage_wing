import Vue from "vue";
import Vuex from "vuex";
import getters from "./getters";
import mutations from "./mutations";
import actions from "./actions";

Vue.use(Vuex);

export default new Vuex.Store({
  state: {
    token: null,
    avatar: null,
    userId: null,
    userName: null,
    userType: null,
    resultDialog: false,
    resultText: "",
  },
  getters,
  mutations,
  actions,
});
