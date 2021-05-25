<template>
  <div>
    <template v-if="owner">
      <div>{{owner.name}}</div>
    </template>
    <p v-else>作成者は退会しました</p>
    <template v-if="isEventOwner">
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
export default {
  props: ['id'],
  data () {
    return {
      event: [],
      owner: []
    }
  },
  computed: {
    eventData () {
      return this.$store.getters.eventData
    },
    isEventOwner () {
      const authData = this.$store.getters.authData
      if (authData & this.owner) {
        return authData.uid === this.owner.email
      }
    }
  },
  watch: {
    eventData: function (newData) {
      this.event = newData.event
      this.owner = newData.owner
    }
  },
  methods: {
    deleteEvent () {
      const eventId = this.id
      const tokenData = {
        headers: this.$store.getters.authData
      }
      this.$store.dispatch('deleteEventData', {eventId, tokenData})
    }
  },
  created () {
    if (!this.eventData.event || this.eventData.event.id !== Number(this.id)) {
      return this.$store.dispatch('getEventData', this.id)
    }
    this.event = this.eventData.event
    this.owner = this.eventData.owner
  }
}
</script>
