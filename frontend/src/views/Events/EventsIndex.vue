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
export default {
  data () {
    return {
      events: []
    }
  },
  computed: {
    isAuthenticated () {
      return this.$store.getters.authData !== null
    },
    eventsData () {
      return this.$store.getters.eventsData
    }
  },
  watch: {
    eventsData: function (newData) {
      this.events = newData
    }
  },
  created () {
    if (this.eventsData === null) {
      return this.$store.dispatch('getEventsData')
    }
    this.events = this.eventsData
  }
}
</script>
