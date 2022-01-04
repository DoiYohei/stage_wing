import axios from "@/plugins/axios";
import router from "@/routes";

const state = {
  authData: null,
  userType: null,
};
const getters = {
  authData: (state) => state.authData,
  token: (state) => {
    if (state.authData) {
      return state.authData.token;
    } else return null;
  },
  headers: (state) => {
    if (state.authData) {
      return { headers: state.authData.token };
    } else return null;
  },
  currentUserId: (state) => {
    if (state.authData) {
      return state.authData.id;
    } else return null;
  },
  userType: (state) => state.userType,
};
const mutations = {
  updateAuthData(state, payload) {
    state.authData = payload;
  },
  updateUserType(state, payload) {
    state.userType = payload;
  },
};
const actions = {
  async signupBand({ dispatch }, formData) {
    const res = await axios.post("/auth/sign_up", formData);
    const userType = "band";
    dispatch("setAuthData", { res, userType });
    router.replace("/");
  },
  async signupAudience({ dispatch }, formData) {
    const res = await axios.post("/audiences", formData);
    const userType = "audience";
    dispatch("setAuthData", { res, userType });
    router.replace("/");
  },
  async loginBand({ dispatch }, formData) {
    const res = await axios.post("/auth/sign_in", formData);
    const userType = "band";
    dispatch("setAuthData", { res, userType });
    router.replace("/");
  },
  async loginAudience({ dispatch }, formData) {
    const res = await axios.post("/audiences/sign_in", formData);
    const userType = "audience";
    dispatch("setAuthData", { res, userType });
    router.replace("/");
  },
  setAuthData({ commit }, payload) {
    const authData = {
      token: payload.res.headers,
      id: payload.res.data.data.id,
    };
    commit("updateAuthData", authData);
    commit("updateUserType", payload.userType);
    localStorage.setItem("authDataSW", JSON.stringify(authData));
    localStorage.setItem("userTypeSW", JSON.stringify(payload.userType));
  },
  autoLogin({ commit }) {
    // localStorageにトークンが無ければ抜ける。
    const authData = JSON.parse(localStorage.getItem("authDataSW"));
    const userType = JSON.parse(localStorage.getItem("userTypeSW"));
    if (!authData) {
      return;
    } else {
      // トークンの期限が切れていれば、localStorageからデータを消して抜ける。
      const now = new Date();
      const expiryMs = authData.token.expiry * 1000;
      const isExpired = now.getTime() >= expiryMs;
      if (isExpired) {
        localStorage.removeItem("authDataSW");
        localStorage.removeItem("userTypeSW");
        return;
      } else {
        // トークンの期限が有効ならオートログインする。
        commit("updateAuthData", authData);
        commit("updateUserType", userType);
      }
    }
  },
  async logout({ dispatch }, payload) {
    if (payload.userType === "band") {
      await axios.delete("/auth/sign_out", payload.token);
    } else {
      await axios.delete("/audiences/sign_out", payload.token);
    }
    return dispatch("deleteToken");
  },
  async deleteBand({ dispatch }, token) {
    await axios.delete("/auth/account/delete", token);
    dispatch("deleteToken");
    router.replace("/");
  },
  async deleteAudience({ dispatch }, token) {
    await axios.delete("/audiences", token);
    dispatch("deleteToken");
    router.replace("/");
  },
  deleteToken({ commit }) {
    commit("updateAuthData", null);
    commit("updateUserType", null);
    localStorage.removeItem("authDataSW");
    localStorage.removeItem("userTypeSW");
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
