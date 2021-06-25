<template>
  <div>
    <h1>イベント内容の編集</h1>
    <div class="form">
      <label for="name">イベント名</label>
      <input type="text" v-model="event.name" id="name">
    </div>
    <div class="form">
      <label for="flyer">フライヤー画像</label>
      <input type="file" id="flyer" @change="setFlyer">
      <div v-if="url">
        <img :src="url">
      </div>
    </div>
    <div class="form">
      <label for="place">場所</label>
      <input type="text" v-model="event.place" id="place">
    </div>
    <div class="form">
      <label for="open-at">Open</label>
      <input type="datetime-local" v-model="event.openAt" id="open-at">
    </div>
    <div class="form">
      <label for="start-at">Start</label>
      <input type="datetime-local" v-model="event.startAt" id="start-at">
    </div>
    <div class="form">
      <label for="content">詳細</label>
      <textarea v-model="event.content" id="content" rows="20" cols="50"></textarea>
    </div>
    <button @click="patchEvent">更新する</button>
  </div>
</template>

<script>
export default {
  props: ['id'],
  data () {
    return {
      event: {},
      url: ''
    }
  },
  methods: {
    setFlyer (e) {
      this.flyer = e.target.files[0]
      this.url = URL.createObjectURL(this.image)
    },
    async patchEvent () {
      const token = { headers: this.$store.getters.token }
      const formData = new FormData()
      formData.append('event[name]', this.event.name)
      formData.append('event[flyer]', this.event.flyer)
      formData.append('event[place]', this.event.place)
      formData.append('event[open_at]', this.event.openAt)
      formData.append('event[start_at]', this.event.startAt)
      formData.append('event[content]', this.event.content)
      await this.$axios.patch(`/events/${this.id}`, formData, token)
      this.$router.replace(`/events/${this.id}`)
    }
  },
  async created () {
    const res = await this.$axios.get(`/events/${this.id}`)
    this.event = res.data
  }
}
</script>
