import axios from "@/plugins/axios";
import store from "@/store";
import { goTo401 } from "./routers";

export const changeLike = (post) => {
  if (!store.getters.token) {
    return goTo401();
  } else {
    const formData = new FormData();
    formData.append("post_id", post.id);
    if (post.favorite) {
      axios.delete("/likes", {
        headers: store.getters.token,
        data: formData,
      });
      post.favorite = false;
      post.likes_count -= 1;
    } else {
      axios.post("/likes", formData, store.getters.headers);
      post.favorite = true;
      post.likes_count += 1;
    }
  }
};
