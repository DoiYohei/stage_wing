import axios from '@/axios'
import router from '@/router'

const state = {
  bandsData: null,
  bandData: {}
}
const getters = {
  bandsData: state => state.bandsData,
  bandData: state => state.bandData
}
const mutations = {
  updateBandsData (state, responseData) {
    state.bandsData = responseData
  },
  updateBandData (state, responseData) {
    state.bandData = responseData
  }
}
const actions = {
  getBandsData ({commit}) {
    axios.get('/bands').then(response => {
      commit('updateBandsData', response.data.bands)
    })
  },
  getBandData ({commit}, bandId) {
    axios.get('/bands/' + bandId).then(response => {
      commit('updateBandData', response.data.band)
    })
  },
  editBandData ({commit}, editData) {
    axios.patch('/auth/account/edit', editData.formData, {
      headers: editData.headers
    }).then(response => {
      commit('updataBandData', response.data)
      commit('updataBandsData', null)
      router.replace('/bands/' + response.data.uid)
    })
  },
  deleteBandData ({commit}) {
    axios.delete('/auth/account/delete')
    commit('updateBandData', {})
    router.replace('/')
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
