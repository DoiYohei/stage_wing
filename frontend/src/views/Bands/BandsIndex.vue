<template>
  <div>
    <div v-for="band in bands" :key="band.name">
      <router-link :to="'/bands/' + band.id">
        <div>{{band.name}}</div>
        <hr>
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  data () {
    return {
      bands: []
    }
  },
  computed: {
    bandsData () {
      return this.$store.getters.bandsData
    }
  },
  methods: {
    assignData () {
      this.bands = this.bandsData
    }
  },
  async created () {
    if (this.bandsData === null) {
      await this.$store.dispatch('getBandsData')
    }
    this.assignData()
  }
}
</script>
