<template>
  <div>
    <h1>Latest Events</h1>
    <v-container>
      <v-row>
        <v-col md="6" offset-md="3">
          <v-carousel
            cycle
            light
            hide-delimiter-background
            :show-arrows="false"
            height="auto"
          >
            <v-carousel-item
              v-for="(event, index) in events"
              :key="index"
              :to="`/events/${event.id}`"
            >
              <img :src="eventFlyer(event.flyer.url)" alt="Flyer" />
              <v-row>
                <v-col md="8" offset-md="2">
                  <div>{{ event.name }}</div>
                  <div>{{ $dayjs(event.open_at).format("YYYY MMM DD") }}</div>
                </v-col>
              </v-row>
            </v-carousel-item>
          </v-carousel>
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
  computed: {
    eventFlyer() {
      return (flyerUrl) => {
        return flyerUrl ? flyerUrl : require("@/assets/img/no-image.jpg");
      };
    },
  },
};
</script>
