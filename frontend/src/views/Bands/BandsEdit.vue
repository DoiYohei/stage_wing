<template>
  <div>
    <h1>アカウント情報編集</h1>
    <div class="form">
      <label for="name">バンド名</label>
      <input type="text" v-model="band.name" id="name">
    </div>
    <div class="form">
      <label for="email">Email</label>
      <input type="text" v-model="band.email" id="email">
    </div>
    <div class="form">
      <label for="profile">profile</label>
      <input type="text" v-model="band.profile" id="profile">
    </div>
    <div class="form">
      <label for="image">プロフィール画像</label>
      <input type="file" id="image" @change="setImage">
      <div v-if="url">
        <img :src="url">
      </div>
    </div>
    <button @click="patchBand">更新する</button>
  </div>
</template>

<script>
export default {
  props: ['id'],
  data () {
    return {
      band: {},
      url: ''
    }
  },
  methods: {
    setImage (e) {
      this.image = e.target.files[0]
      this.url = URL.createObjectURL(this.image)
    },
    async patchBand () {
      const token = { headers: this.$store.getters.token }
      const formData = new FormData()
      formData.append('name', this.band.name)
      formData.append('email', this.band.email)
      formData.append('profile', this.band.profile)
      formData.append('image', this.band.image)
      await this.$axios.patch('/auth/account/edit', formData, token)
      this.$router.replace(`/bands/${this.id}`)
    }
  },
  async created () {
    const res = await this.$axios.get(`/bands/${this.id}`)
    this.band = res.data
  }
}
</script>
