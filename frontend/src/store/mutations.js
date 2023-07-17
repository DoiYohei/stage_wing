export default {
  updateAuthData(state, authData) {
    state.token = authData.token;
    state.avatar = authData.avatar;
    state.userId = authData.userId;
    state.userName = authData.userName;
    state.userType = authData.userType;
  },
  showError(state, text) {
    state.isError = true;
    state.errorText = text;
  },
  clearError(state) {
    state.isError = false;
    state.errorText = "";
  },
};
