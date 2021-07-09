import axios from "@/plugins/axios";
import router from "@/routes";

const state = {
  bandsData: null,
  bandData: {},
};
const getters = {
  bandsData: (state) => state.bandsData,
  bandData: (state) => state.bandData,
};
const mutations = {
  updateBandsData(state, responseData) {
    state.bandsData = responseData;
  },
  updateBandData(state, responseData) {
    state.bandData = responseData;
  },
};
const actions = {
  getBandsData({ commit }) {
    return axios.get("/bands").then((response) => {
      commit("updateBandsData", response.data.bands);
    });
  },
  getBandData({ commit }, bandId) {
    return axios.get("/bands/" + bandId).then((response) => {
      commit("updateBandData", response.data);
    });
  },
  editBandData({ commit }, editData) {
    axios
      .patch("/auth/account/edit", editData.formData, editData.token)
      .then((response) => {
        console.log(response);
        commit("updateBandData", response.data);
        commit("updateBandsData", null);
        router.replace("/bands/" + response.data.data.id);
      });
  },
  deleteBandData({ commit }, tokenData) {
    axios.delete("/auth/account/delete", tokenData);
    commit("updateBandData", {});
    commit("updateBandsData", null);
    router.replace("/");
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
