export default {
  token: (state) => state.token,
  userId: (state) => state.userId,
  userName: (state) => state.userName,
  userType: (state) => state.userType,
  userImage: (state) => {
    if (state.avatar) {
      return state.avatar;
    } else {
      return state.userType === "bands"
        ? require("@/assets/img/no-band-img.jpg")
        : require("@/assets/img/no-audience-img.jpeg");
    }
  },
  headers: (state) => {
    return { headers: state.token };
  },
  bandId: (state) => {
    return state.userType === "bands" ? state.userId : null;
  },
  audienceId: (state) => {
    return state.userType === "audiences" ? state.userId : null;
  },
};
