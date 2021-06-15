import router from '@/router'
import axios from '@/axios'

const state = {
  authData: null
}
const getters = {
  authData: state => state.authData
}
const mutations = {
  updateAuthData (state, responseData) {
    state.authData = responseData
  }
}
const actions = {
  signup ({dispatch}, formData) {
    return axios.post('/auth/sign_up', formData)
      .then(response => {
        dispatch('setAuthData', response.headers)
        router.replace('/')
      })
  },
  login ({dispatch}, authParams) {
    axios.post('/auth/sign_in', {
      email: authParams.email,
      password: authParams.password
    })
      .then(response => {
        dispatch('setAuthData', response.headers)
        router.replace('/')
      })
  },
  autoLogin ({commit}) {
    // localStorageにトークンが無ければ抜ける。
    const authDataLS = JSON.parse(localStorage.getItem('authDataLS'))
    if (!authDataLS) return
    // トークンの期限が切れていれば、localStorageからデータを消して抜ける。
    const now = new Date()
    const expiryMs = authDataLS['expiry'] * 1000
    const isExpired = now.getTime() >= expiryMs
    if (isExpired) localStorage.removeItem('authDataLS')
    // トークンの期限が有効ならオートログインする。
    commit('updateAuthData', authDataLS)
  },
  logout ({dispatch}, tokenData) {
    axios.delete('/auth/sign_out', tokenData)
    dispatch('deleteTokenData')
    router.replace('/', () => {})
  },
  setAuthData ({commit}, responseData) {
    commit('updateAuthData', responseData)
    localStorage.setItem('authDataLS', JSON.stringify(responseData))
  },
  deleteTokenData ({commit}) {
    commit('updateAuthData', null)
    localStorage.removeItem('authDataLS')
  }
}

export default {
  state,
  getters,
  mutations,
  actions
}
