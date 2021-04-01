<template>
  <div>
    <router-link to="/event/new" v-if="isAuthenticated">Eventを投稿する</router-link>
    <div v-for="event in events" :key="event.name">
      <router-link :to="'/events/' + event.id">
        <div>{{event.open_at}}</div>
        <span> {{event.name}}</span>
        <hr>
      </router-link>
    </div>
  </div>
</template>

<script>
import axios from '@/axios'

export default {
  data () {
    return {
      events: []
    }
  },
  created () {
    axios.get('/events').then(response => {
      this.events = response.data.events
    })
  },
  computed: {
    isAuthenticated () {
      return this.$store.getters.authData !== null
    }
  }
}
</script>
