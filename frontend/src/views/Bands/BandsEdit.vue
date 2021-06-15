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
    <div class="form">
      <label for="profile">profile</label>
      <input type="text" v-model="profile" id="profile">
    </div>
    <div class="form">
      <label for="image">プロフィール画像</label>
      <input type="file" id="image" @change="setImage">
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
      email: '',
      image: '',
      profile: ''
    }
  },
  methods: {
    setImage (e) {
      this.image = e.target.files[0]
    },
    updateData () {
      const token = {
        headers: this.$store.getters.authData
      }
      const formData = new FormData()
      formData.append('name', this.name)
      formData.append('email', this.email)
      formData.append('profile', this.profile)
      formData.append('image', this.image)
      this.$store.dispatch('editBandData', {formData, token})
    }
  },
  created () {
    axios.get('/bands/' + this.id)
      .then(response => {
        this.name = response.data.name
        this.email = response.data.email
        this.image = response.data.image
      })
  }
}
</script>
