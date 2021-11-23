<template>
  <div>
    <h1>Latest Events</h1>
    <v-carousel cycle light hide-delimiter-background :show-arrows="false">
      <v-carousel-item
        v-for="(event, index) in events"
        :key="index"
        :src="event.flyer"
        :to="`/events/${event.id}`"
      >
        <v-row>
          <v-col md="4" offset-md="4">
            <div>{{ event.name }}</div>
            <div>{{ $dayjs(event.open_at).format("YYYY MMM DD") }}</div>
          </v-col>
        </v-row>
      </v-carousel-item>
    </v-carousel>
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
