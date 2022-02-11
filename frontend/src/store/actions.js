import axios from "@/plugins/axios";
import router from "@/routes";

export default {
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
      avatar: payload.res.data.data.image.url,
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
    const authData = {
      token: null,
      avatar: null,
      userId: null,
      userType: null,
    };
    commit("updateAuthData", authData);
    localStorage.removeItem("authDataSW");
    if (router.history.current.path !== "/") {
      router.push("/");
    }
  },
};
