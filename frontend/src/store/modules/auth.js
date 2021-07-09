import axios from "@/plugins/axios";
import router from "@/routes";

const state = {
  authData: null,
};
const getters = {
  authData: (state) => state.authData,
  token: (state) => state.authData.token,
  currentUserId: (state) => state.authData.id,
};
const mutations = {
  updateAuthData(state, payload) {
    state.authData = payload;
  },
};
const actions = {
  async signup({ dispatch }, formData) {
    const res = await axios.post("/auth/sign_up", formData);
    dispatch("setAuthData", res);
    router.replace("/");
  },
  async login({ dispatch }, formData) {
    const res = await axios.post("/auth/sign_in", formData);
    dispatch("setAuthData", res);
    router.replace("/");
  },
  setAuthData({ commit }, payload) {
    const authData = {
      token: payload.headers,
      id: payload.data.data.id,
    };
    commit("updateAuthData", authData);
    localStorage.setItem("authDataSW", JSON.stringify(authData));
  },
  autoLogin({ commit }) {
    // localStorageにトークンが無ければ抜ける。
    const authData = JSON.parse(localStorage.getItem("authDataSW"));
    if (!authData) return;
    // トークンの期限が切れていれば、localStorageからデータを消して抜ける。
    const now = new Date();
    const expiryMs = authData["token"["expiry"]] * 1000;
    const isExpired = now.getTime() >= expiryMs;
    if (isExpired) localStorage.removeItem("authDataSW");
    // トークンの期限が有効ならオートログインする。
    commit("updateAuthData", authData);
  },
  async logout({ commit }, token) {
    await axios.delete("/auth/sign_out", token);
    commit("updateAuthData", null);
    localStorage.removeItem("authDataSW");
    router.replace("/");
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
