import axios from "@/plugins/axios";
import store from "@/store";
import router from "@/routes";

export const getEvent = async (id) => {
  const token = store.getters.audienceId ? store.getters.headers : null;
  const res = await axios.get(`/events/${id}`, token);
  if (res.data.unregistered_performers) {
    res.data.unregistered_performers =
      res.data.unregistered_performers.split("*/");
  }
  return res.data;
};

export const postEvent = async (event, lineup, flyer) => {
  const eventFormData = new FormData();
  eventFormData.append("event[name]", event.name);
  eventFormData.append("event[place]", event.place);
  eventFormData.append("event[ticket_price]", event.ticket_price);
  eventFormData.append("event[date]", event.date);
  eventFormData.append("event[open_at]", event.open_at);
  eventFormData.append("event[start_at]", event.start_at);
  eventFormData.append("event[content]", event.content);
  eventFormData.append("event[reservation]", event.reservation);
  eventFormData.append(
    "event[unregistered_performers]",
    lineup.newNoIdLineup.join("*/")
  );
  if (flyer) eventFormData.append("event[flyer]", flyer);
  const res = await axios.post("/events", eventFormData, store.getters.headers);
  return res;
};

export const deleteEvent = async (id) => {
  try {
    await axios.delete(`/events/${id}`, store.getters.headers);
    router.replace("/events");
  } catch (error) {
    store.dispatch("showError", "イベントを削除できませんでした。");
  }
};
