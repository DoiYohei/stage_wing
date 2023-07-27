import axios from "@/plugins/axios";
import store from "@/store";
import { reloadPage } from "@/utils/routers";

export const deletePost = async (postId) => {
  try {
    await axios.delete(`/posts/${postId}`, store.getters.headers);
    return reloadPage();
  } catch (error) {
    if (error.response) {
      return store.dispatch("showError", "投稿を削除できませんでした。");
    }
  }
};

export const patchPost = async (postId, postDescription) => {
  try {
    const formData = new FormData();
    formData.append("post[description]", postDescription);
    await axios.patch(`/posts/${postId}`, formData, store.getters.headers);
    return reloadPage();
  } catch (error) {
    if (error.response) {
      return store.dispatch("showError", "投稿を更新できませんでした。");
    }
  }
};
