<template>
  <div>
    <v-container>
      <v-row>
        <v-text-field v-model="keywordInput" label="Band 検索" />
      </v-row>
    </v-container>
    <div v-for="(band, index) in filteredBands" :key="index">
      <router-link :to="`/bands/${band.id}`">
        <div>{{ band.name }}</div>
        <hr />
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      fetchedBands: [],
      keywordInput: "",
    };
  },
  async created() {
    const res = await this.$axios.get("/bands");
    this.fetchedBands = res.data.bands;
  },
  computed: {
    filteredBands() {
      let keyword = this.keywordInput.toLowerCase().trim();
      if (!keyword) return this.fetchedBands;
      return this.fetchedBands.filter((band) => {
        return band.name.toLowerCase().includes(keyword);
      });
    },
  },
};
</script>
