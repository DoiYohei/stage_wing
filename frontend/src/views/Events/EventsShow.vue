<template>
  <div>
    <template v-if="owner">
      <div>{{owner.name}}</div>
    </template>
    <p v-else>作成者は退会しました</p>
    <template v-if="isEventOwner">
      <router-link :to="'/events/' + id + '/edit'">イベント情報を編集する</router-link>
      <button @click='deleteEvent'>削除する</button>
    </template>
    <div>{{event.name}}</div>
    <div>{{event.open_at}}</div>
    <div>{{event.start_at}}</div>
    <div>{{event.place}}</div>
    <div>{{event.content}}</div>
    <p>Lineup: </p>
    <template v-if="performers">
      <div v-for="(performer, index) in performers" :key="index">
        <router-link :to="'/bands/' + performer.id">{{performer.name}}</router-link>
      </div>
    </template>
    <template v-if="unregisteredPerformers">
      <div>/ {{unregisteredPerformers.name}}</div>
    </template>
    <template v-if="isEventOwner">
      <router-link :to="'/events/' + id + '/lineup/edit'">Lineupを編集する</router-link>
    </template>
  </div>
</template>

<script>
export default {
  props: ['id'],
  data () {
    return {
      event: [],
      owner: [],
      performers: [],
      unregisteredPerformers: []
    }
  },
  computed: {
    eventData () {
      return this.$store.getters.eventData
    },
    lineupData () {
      return this.$store.getters.lineup
    },
    isEventOwner () {
      const authData = this.$store.getters.authData
      if (authData && this.owner) {
        return authData.uid === this.owner.email
      }
    }
  },
  methods: {
    assignData () {
      this.event = this.eventData.event
      this.owner = this.eventData.owner
      this.performers = this.lineupData.performers
      this.unregisteredPerformers = this.lineupData.unregistered_performers
    },
    deleteEvent () {
      const eventId = this.id
      const tokenData = {
        headers: this.$store.getters.authData
      }
      this.$store.dispatch('deleteEventData', {eventId, tokenData})
    }
  },
  async created () {
    if (!this.eventData.event || this.eventData.event.id !== Number(this.id)) {
      await this.$store.dispatch('getEventData', this.id)
        .then(() => this.$store.dispatch('getLineup', this.id))
    }
    if (!this.lineupData || this.lineupData.event_id !== Number(this.id)) {
      await this.$store.dispatch('getLineup', this.id)
    }
    this.assignData()
  }
}
</script>
