<template>
  <div>
    <div>{{band.name}}</div>
    <template v-if="isMyPage">
      <router-link :to="'/bands/' + id + '/edit'">編集する</router-link>
      <button @click='deleteBand'>削除する</button>
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
  watch: {
    bandData: function (newData) {
      this.band = newData
    }
  },
  methods: {
    deleteBand () {
      this.$store.dispatch('deleteBandData', {
        headers: this.$store.getters.authData
      })
      this.$store.dispatch('deleteTokenData')
    }
  },
  created () {
    if (!this.bandData || this.bandData.id !== Number(this.id)) {
      return this.$store.dispatch('getBandData', this.id)
    }
    this.band = this.bandData
  }
}
</script>
