<template>
  <div>
    <div v-for="(band, index) in bands" :key="index">
      <router-link :to="`/bands/${band.id}`">
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
  async created () {
    const res = await this.$axios.get('/bands')
    this.bands = res.data.bands
  }
}
</script>
