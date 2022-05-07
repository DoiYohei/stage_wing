import axios from "@/plugins/axios";
import router from "@/routes";

export default {
  async signupBand({ dispatch }, formData) {
    const res = await axios.post("/bands", formData).catch((error) => {
      return error.response.success;
    });
    if (res) {
      const userType = "bands";
      return dispatch("setAuthData", { res, userType });
    } else return res;
  },
  async signupAudience({ dispatch }, formData) {
    const res = await axios.post("/audiences", formData).catch((error) => {
      return error.response.success;
    });
    if (res) {
      const userType = "audiences";
      return dispatch("setAuthData", { res, userType });
    } else return res;
  },
  async loginBand({ dispatch }, formData) {
    const res = await axios.post("/bands/sign_in", formData).catch((error) => {
      return error.response.success;
    });
    if (res) {
      const userType = "bands";
      return dispatch("setAuthData", { res, userType });
    } else return res;
  },
  async loginAudience({ dispatch }, formData) {
    const res = await axios
      .post("/audiences/sign_in", formData)
      .catch((error) => {
        return error.response.success;
      });
    if (res) {
      const userType = "audiences";
      return dispatch("setAuthData", { res, userType });
    } else return res;
  },
  setAuthData({ commit }, payload) {
    const authData = {
      token: payload.res.headers,
      avatar: payload.res.data.data.image.url,
      userId: payload.res.data.data.id,
      userName: payload.res.data.data.name,
      userType: payload.userType,
    };
    commit("updateAuthData", authData);
    localStorage.setItem("authDataSW", JSON.stringify(authData));
    if (authData.userType === "bands") {
      router.replace(`/bands/${authData.userId}`);
    } else {
      router.replace("/");
    }
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
      userName: null,
      userType: null,
    };
    commit("updateAuthData", authData);
    localStorage.removeItem("authDataSW");
    if (router.currentRoute.path === "/") {
      router.go({ path: router.currentRoute.path, force: true });
    } else {
      router.replace("/");
    }
  },
};
