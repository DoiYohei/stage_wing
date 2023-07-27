import axios from "@/plugins/axios";
import store from "@/store";
import { reloadPage } from "@/utils/routers";

export const postTicket = async (id, bandId) => {
  try {
    const formData = new FormData();
    formData.append("ticket[event_id]", id);
    formData.append("ticket[band_id]", bandId);
    await axios.post(`/tickets`, formData, store.getters.headers);
    return reloadPage();
  } catch (error) {
    if (error.response) {
      store.dispatch("showError", "チケットを取り置きできませんでした。");
    }
  }
};

export const deleteTicket = async (id) => {
  try {
    await axios.delete(`/tickets/${id}`, store.getters.headers);
    return reloadPage();
  } catch (error) {
    if (error.response) {
      store.dispatch("showError", "チケットをキャンセルできませんでした。");
    }
  }
};
