import axios from "@/plugins/axios";
import router from "@/routes";

export default {
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
  async logout({ getters, dispatch, commit }) {
    try {
      await axios.delete(`/${getters.userType}/sign_out`, getters.headers);
      return dispatch("deleteToken");
    } catch (error) {
      if (error) return commit("showError", "ログアウトできませんでした");
    }
  },
  async deleteAccount({ getters, dispatch, commit }) {
    try {
      await axios.delete(`/${getters.userType}`, getters.headers);
      return dispatch("deleteToken");
    } catch (error) {
      if (error) return commit("showError", "退会できませんでした");
    }
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
  showError({ commit }, text) {
    commit("showError", text);
  },
  clearError({ commit }) {
    commit("clearError");
  },
};
