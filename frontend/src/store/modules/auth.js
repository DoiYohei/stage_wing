import axios from "@/plugins/axios";
import router from "@/routes";

const state = {
  token: null,
  userId: null,
  userType: null,
};
const getters = {
  token: (state) => state.token,
  userId: (state) => state.userId,
  userType: (state) => state.userType,
  headers: (state) => {
    return { headers: state.token };
  },
  isAuthenticatedBand: (state) => state.userType === "bands",
  isAuthenticatedAudience: (state) => state.userType === "audiences",
};
const mutations = {
  updateAuthData(state, payload) {
    if (payload) {
      state.token = payload.token;
      state.userId = payload.userId;
      state.userType = payload.userType;
    } else {
      state.token = null;
      state.userId = null;
      state.userType = null;
    }
  },
};
const actions = {
  async signupBand({ dispatch }, formData) {
    const res = await axios.post("/bands", formData);
    const userType = "bands";
    return dispatch("setAuthData", { res, userType });
  },
  async signupAudience({ dispatch }, formData) {
    const res = await axios.post("/audiences", formData);
    const userType = "audiences";
    return dispatch("setAuthData", { res, userType });
  },
  async loginBand({ dispatch }, formData) {
    const res = await axios.post("/bands/sign_in", formData);
    const userType = "bands";
    return dispatch("setAuthData", { res, userType });
  },
  async loginAudience({ dispatch }, formData) {
    const res = await axios.post("/audiences/sign_in", formData);
    const userType = "audiences";
    return dispatch("setAuthData", { res, userType });
  },
  setAuthData({ commit }, payload) {
    const authData = {
      token: payload.res.headers,
      userId: payload.res.data.data.id,
      userType: payload.userType,
    };
    commit("updateAuthData", authData);
    localStorage.setItem("authDataSW", JSON.stringify(authData));
  },
  autoLogin({ commit }) {
    // localStorageにトークンが無ければ抜ける。
    const authData = JSON.parse(localStorage.getItem("authDataSW"));
    if (!authData) {
      return;
    } else {
      // トークンの期限が切れていれば、localStorageからデータを消して抜ける。
      const now = new Date();
      const expiryMs = authData.token.expiry * 1000;
      const isExpired = now.getTime() >= expiryMs;
      if (isExpired) {
        localStorage.removeItem("authDataSW");
        return;
      } else {
        // トークンの期限が有効ならオートログインする。
        commit("updateAuthData", authData);
      }
    }
  },
  async logout({ dispatch, getters }) {
    await axios.delete(`/${getters.userType}/sign_out`, getters.headers);
    return dispatch("deleteToken");
  },
  async deleteAccount({ dispatch, getters }) {
    await axios.delete(`/${getters.userType}`, getters.headers);
    return dispatch("deleteToken");
  },
  deleteToken({ commit }) {
    commit("updateAuthData", null);
    localStorage.removeItem("authDataSW");
    if (router.history.current.path !== "/") {
      router.replace("/");
    }
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
