<template>
  <div>
    <h1>Latest Events</h1>
    <v-container>
      <v-row>
        <v-col
          md="4"
          offset-md="4"
          v-for="(event, index) in events"
          :key="index"
        >
          <div>{{ event.name }}</div>
          <img :src="event.flyer" />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      events: {},
    };
  },
  async created() {
    const res = await this.$axios.get("/");
    this.events = res.data;
  },
};
</script>
