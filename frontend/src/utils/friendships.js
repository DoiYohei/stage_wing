import axios from "@/plugins/axios";
import store from "@/store";

export const changeFriendship = (followedId, isFollowing) => {
  const formData = new FormData();
  formData.append("followed_id", followedId);
  if (isFollowing) {
    axios.delete("/friendships", {
      headers: store.getters.token,
      data: formData,
    });
  } else {
    axios.post("/friendships", formData, store.getters.headers);
  }
};
