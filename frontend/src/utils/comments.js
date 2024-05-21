import axios from "@/plugins/axios";
import store from "@/store";
import { goTo401, reloadPage } from "@/utils/routers";

export const postComment = async (reply, parentId, comment, eventId) => {
  if (!store.getters.token) {
    return goTo401();
  } else {
    try {
      const formData = new FormData();
      if (reply) {
        formData.append("comment[content]", reply);
        formData.append("comment[parent_id", parentId);
      } else {
        formData.append("comment[content]", comment);
      }
      formData.append("comment[event_id]", eventId);
      await axios.post("/comments", formData, store.getters.headers);
      reloadPage();
    } catch (error) {
      store.dispatch("showError", "コメントを投稿できませんでした。");
    }
  }
};

export const deleteComment = async (commentId) => {
  try {
    await axios.delete(`/comments/${commentId}`, store.getters.headers);
    reloadPage();
  } catch (error) {
    store.dispatch("showError", "コメントを削除できませんでした。");
  }
};
