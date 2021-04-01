<template>
  <div>
    <div>{{owner.name}}</div>
    <template v-if="isAuthenticated">
      <router-link :to="'/events/' + id + '/edit'">編集する</router-link>
      <button @click='deleteEvent'>削除する</button>
    </template>
    <div>{{event.name}}</div>
    <div>{{event.open_at}}</div>
    <div>{{event.start_at}}</div>
    <div>{{event.place}}</div>
    <div>{{event.content}}</div>
  </div>
</template>

<script>
import axios from '@/axios'
import router from '@/router'

export default {
  props: ['id'],
  data () {
    return {
      event: [],
      owner: []
    }
  },
  created () {
    axios.get('/events/' + this.id).then(response => {
      this.event = response.data.event
      this.owner = response.data.owner
    })
  },
  computed: {
    isAuthenticated () {
      return this.$store.getters.authData !== null
    }
  },
  methods: {
    deleteEvent () {
      axios.delete('/events/' + this.id, {
        headers: this.$store.getters.authData
      })
      router.replace('/')
    }
  }
}
</script>
