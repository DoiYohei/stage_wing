export default {
  updateAuthData(state, authData) {
    state.token = authData.token;
    state.avatar = authData.avatar;
    state.userId = authData.userId;
    state.userType = authData.userType;
  },
};
