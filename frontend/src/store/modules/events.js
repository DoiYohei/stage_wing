import axios from "@/plugins/axios";
import router from "@/routes";

const state = {
  eventsData: null,
  eventData: {},
};
const getters = {
  eventsData: (state) => state.eventsData,
  eventData: (state) => state.eventData,
};
const mutations = {
  updateEventsData(state, responseData) {
    state.eventsData = responseData;
  },
  updateEventData(state, responseData) {
    state.eventData = responseData;
  },
};
const actions = {
  postEvent({ commit, dispatch }, data) {
    return axios.post("/events", data.formData, data.token).then((response) => {
      commit("updateEventData", response.data);
      dispatch("getEventsData");
    });
  },
  getEventsData({ commit }) {
    return axios.get("/events").then((response) => {
      commit("updateEventsData", response.data.events);
    });
  },
  async getEventData({ commit }, eventId) {
    const res = await axios.get("/events/" + eventId);
    commit("updateEventData", res.data);
    return res.data;
  },
  editEventData({ commit, dispatch }, editData) {
    axios
      .patch(
        "/events/" + editData.eventId,
        editData.formData,
        editData.tokenData
      )
      .then((response) => {
        commit("updateEventData", response.data);
        dispatch("getEventsData");
        router.replace("/events/" + response.data.id);
      });
  },
  deleteEventData({ commit }, deleteData) {
    axios.delete("/events/" + deleteData.eventId, deleteData.tokenData);
    commit("updateEventData", {});
    commit("updateEventsData", null);
    router.replace("/");
  },
};

export default {
  state,
  getters,
  mutations,
  actions,
};
