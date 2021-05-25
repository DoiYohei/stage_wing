import axios from '@/axios'
import router from '@/router'

const state = {
  eventsData: null,
  eventData: {}
}
const getters = {
  eventsData: state => state.eventsData,
  eventData: state => state.eventData
}
const mutations = {
  updateEventsData (state, responseData) {
    state.eventsData = responseData
  },
  updateEventData (state, responseData) {
    state.eventData = responseData
  }
}
const actions = {
  postEvent ({commit}, postData) {
    axios.post('/events', postData.formData, postData.tokenData)
      .then(response => {
        commit('updateEventsData', null)
        commit('updateEventData', response.data)
        router.replace('/')
      })
  },
  getEventsData ({commit}) {
    axios.get('/events').then(response => {
      commit('updateEventsData', response.data.events)
    })
  },
  getEventData ({commit}, eventId) {
    axios.get('/events/' + eventId).then(response => {
      commit('updateEventData', response.data)
    })
  },
  editEventData ({commit}, editData) {
    axios.patch('/events/' + editData.eventId, editData.formData, editData.tokenData)
      .then(response => {
        commit('updateEventData', response.data)
        commit('updateEventsData', null)
        router.replace('/events/' + response.data.event.id)
      })
  },
  deleteEventData ({commit}, deleteData) {
    axios.delete('/events/' + deleteData.eventId, deleteData.tokenData)
    commit('updateEventData', {})
    commit('updateEventsData', null)
    router.replace('/')
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
