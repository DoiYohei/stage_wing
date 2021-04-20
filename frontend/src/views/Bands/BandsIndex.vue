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
  watch: {
    bandsData: function (newData) {
      this.bands = newData
    }
  },
  created () {
    if (this.bandsData === null) {
      return this.$store.dispatch('getBandsData')
    }
    this.bands = this.bandsData
  }
}
</script>
