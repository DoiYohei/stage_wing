export default {
  updateAuthData(state, authData) {
    state.token = authData.token;
    state.avatar = authData.avatar;
    state.userId = authData.userId;
    state.userName = authData.userName;
    state.userType = authData.userType;
  },
  showResult(state, text) {
    state.resultDialog = true;
    state.resultText = text;
  },
  clearResult(state) {
    state.resultDialog = false;
    state.resultText = "";
  },
};
