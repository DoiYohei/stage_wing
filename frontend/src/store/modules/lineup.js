import axios from '@/axios'

const state = {
  lineup: null
}
const getters = {
  lineup: state => state.lineup
}
const mutations = {
  updateLineup (state, payload) {
    state.lineup = payload
  }
}
const actions = {
  getLineup ({commit}, eventId) {
    return axios.get('/events/' + eventId + '/lineups')
      .then(response => {
        commit('updateLineup', response.data)
      })
  },
  postLineup ({commit}, data) {
    const lineups = []
    for (let performerId of data.performerIds) {
      let lineup = {
        event_id: data.eventId,
        performer_id: performerId
      }
      lineups.push(lineup)
    }
    if (data.unregisteredPerformers) {
      const unregisteredPerformers = {
        event_id: data.eventId,
        unregistered_performers: data.unregisteredPerformers
      }
      lineups.push(unregisteredPerformers)
    }
    return axios.post(
      '/events/' + data.eventId + '/lineups',
      {lineups: lineups},
      data.token
    ).then(response => commit('updateLineup', response.data))
  },
  editLineup ({commit}, data) {
    return axios.patch(
      '/events/' + data.eventId + '/lineups/' + data.lineupId,
      {lineup: data.formData},
      data.token
    )
  },
  deleteLineup ({commit}, data) {
    return axios.delete(
      '/events/' + data.eventId + '/lineups/' + data.lineupId,
      data.token
    )
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
