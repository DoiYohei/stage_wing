export default {
  token: (state) => state.token,
  avatar: (state) => state.avatar,
  userId: (state) => state.userId,
  userName: (state) => state.userName,
  userType: (state) => state.userType,
  headers: (state) => {
    return { headers: state.token };
  },
  isAuthenticatedBand: (state) => state.userType === "bands",
  isAuthenticatedAudience: (state) => state.userType === "audiences",
};
