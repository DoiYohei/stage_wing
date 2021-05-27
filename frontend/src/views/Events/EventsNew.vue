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
    <div class="form" v-for="(performer, index) in performers" :key="index">
      <label for="performer">Lineup</label>
      <input type="text" v-model="performer.name" class="performer">
    </div>
    <div class="form">
      <label for="unregistered-performers">登録されていないアーティスト</label>
      <textarea v-model="unregisteredPerformers" id="unregistered-performers" rows="20" cols="50"></textarea>
    </div>
    <button @click="postEvent">投稿する</button>
  </div>
</template>

<script>
import router from '@/router'

export default {
  data () {
    return {
      name: '',
      place: '',
      openAt: '',
      startAt: '',
      content: '',
      performers: [{name: ''}],
      unregisteredPerformers: ''
    }
  },
  computed: {
    bandsData () {
      return this.$store.getters.bandsData
    },
    countEmptyForm () {
      return this.performers.filter(el => el.name === '').length
    }
  },
  watch: {
    countEmptyForm (newData) {
      if (newData === 0) {
        this.performers.push({ name: '' })
      }
      if (newData >= 2) {
        // this.performersから、{name: ''}を持つ最後の要素を削除する
        const isEmptyForm = []
        for (let performer of this.performers) {
          let isEmptyName = performer.name === ''
          isEmptyForm.push(isEmptyName)
        }
        this.performers.splice(isEmptyForm.lastIndexOf(true), 1)
      }
    }
  },
  methods: {
    postEvent () {
      const performerIds = []
      for (let performer of this.performers) {
        let registeredPerformer = this.bandsData.find(el => el.name === performer.name)
        if (registeredPerformer) {
          performerIds.push(registeredPerformer.id)
        }
      }
      const eventForm = {
        event: {
          name: this.name,
          place: this.place,
          open_at: this.openAt,
          start_at: this.startAt,
          content: this.content
        }
      }
      const token = {
        headers: this.$store.getters.authData
      }
      this.$store.dispatch('postEvent', {eventForm, token})
        .then(() => {
          const lineupForm = {
            eventId: this.$store.getters.eventData.event.id,
            performerIds: performerIds,
            unregisteredPerformers: this.unregisteredPerformers,
            token: token
          }
          this.$store.dispatch('postLineup', lineupForm)
        })
        .then(() => router.replace('/'))
    }
  },
  created () {
    if (this.bandsData === null) {
      this.$store.dispatch('getBandsData')
    }
  }
}
</script>
