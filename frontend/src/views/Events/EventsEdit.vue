<template>
  <div>
    <h1>イベント内容の編集</h1>
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
    <button @click="updateEvent">更新する</button>
  </div>
</template>

<script>
export default {
  props: ['id'],
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
    updateEvent () {
      const eventId = this.id
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
      this.$store.dispatch('editEventData', {eventId, formData, tokenData})
    }
  },
  created () {
    const eventData = this.$store.getters.eventData.event
    if (eventData) {
      this.name = eventData.name
      this.place = eventData.place
      this.openAt = eventData.openAt
      this.startAt = eventData.startAt
      this.content = eventData.content
    }
  }
}
</script>
