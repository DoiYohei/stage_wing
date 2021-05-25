<template>
  <div>
    <h1>アカウント情報編集</h1>
    <div class="form">
      <label for="name">バンド名</label>
      <input type="text" v-model="name" id="name">
    </div>
    <div class="form">
      <label for="email">Email</label>
      <input type="text" v-model="email" id="email">
    </div>
    <button @click="updateData">更新する</button>
  </div>
</template>

<script>
import axios from '@/axios'

export default {
  props: ['id'],
  data () {
    return {
      name: '',
      email: ''
    }
  },
  methods: {
    updateData () {
      const formData = {
        name: this.name,
        email: this.email
      }
      const tokenData = {
        headers: this.$store.getters.authData
      }
      this.$store.dispatch('editBandData', {formData, tokenData})
    }
  },
  created () {
    axios.get('/bands/' + this.id)
      .then(response => {
        this.name = response.data.band.name
        this.email = response.data.band.email
      })
  }
}
</script>
