<template>
  <div>
    <router-link :to="'/bands/' + id + '/posts'">Posts</router-link>
    <div>{{band.name}}</div>
    <div v-if="band.profile">
      <iframe :src="band.profile"></iframe>
    </div>
    <img :src="band.image">
    <template v-if="isMyPage">
      <router-link :to="'/bands/' + id + '/edit'">編集する</router-link>
      <button @click='deleteBand'>削除する</button>
    </template>
    <div>LIVEスケジュール</div>
    <template v-if="band.performing_events">
      <div v-for="(event, index) in band.performing_events" :key="index">
        <router-link :to="'/events/' + event.id">{{event.open_at}}: {{event.name}}</router-link>
      </div>
    </template>
  </div>
</template>

<script>
export default {
  props: ['id'],
  data () {
    return {
      band: []
    }
  },
  computed: {
    bandData () {
      return this.$store.getters.bandData
    },
    isMyPage () {
      const authData = this.$store.getters.authData
      if (authData) {
        return this.$store.getters.authData.uid === this.band.email
      }
    }
  },
  methods: {
    assignData () {
      this.band = this.bandData
    },
    deleteBand () {
      this.$store.dispatch('deleteBandData', {
        headers: this.$store.getters.authData
      })
      this.$store.dispatch('deleteTokenData')
    }
  },
  async created () {
    if (!this.bandData || this.bandData.id !== Number(this.id)) {
      await this.$store.dispatch('getBandData', this.id)
    }
    this.assignData()
  }
}
</script>
