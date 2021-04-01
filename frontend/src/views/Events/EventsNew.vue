<template>
  <div>
    <h1>新規イベント投稿</h1>
    <div class="form">
      <label for="name">イベント名</label>
      <input type="text" v-model="name" id="name">
    </div>
    <div class="form">
      <label for="place">場所</label>
      <input type="text" v-model="place" id="place">
    </div>
    <div class="form">
      <label for="open-at">Open</label>
      <input type="datetime-local" v-model="openAt" id="open-at">
    </div>
    <div class="form">
      <label for="start-at">Start</label>
      <input type="datetime-local" v-model="startAt" id="start-at">
    </div>
    <div class="form">
      <label for="content">詳細</label>
      <textarea v-model="content" id="content" rows="20" cols="50"></textarea>
    </div>
    <button @click="postEvent">投稿する</button>
  </div>
</template>

<script>
import axios from '@/axios'
import router from '@/router'

export default {
  data () {
    return {
      name: '',
      place: '',
      openAt: '',
      startAt: '',
      content: ''
    }
  },
  methods: {
    postEvent () {
      const formData = {
        event: {
          name: this.name,
          place: this.place,
          open_at: this.openAt,
          start_at: this.startAt,
          content: this.content
        }
      }
      const tokenData = {
        headers: this.$store.getters.authData
      }
      axios.post('/events', formData, tokenData)
      router.replace('/')
    }
  }
}
</script>
