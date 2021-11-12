import axios from "@/plugins/axios";

const state = {
  audiences: null,
};
const getters = {
  audiences: (state) => state.audiences,
};
const mutations = {
  updateAudiences(state, payload) {
    state.audiences = payload;
  },
};
const actions = {
  async getAudiences({ commit }) {
    const res = await axios.get("/audiences");
    return commit("updateAudiences", res.data);
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
