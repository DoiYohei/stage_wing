<template>
  <v-col>
    <CardEventsIndex :events="events" />
  </v-col>
</template>

<script>
import CardEventsIndex from "@/components/Cards/CardEventsIndex";

export default {
  components: {
    CardEventsIndex,
  },
  props: ["id"],
  data() {
    return {
      events: [],
    };
  },
  async created() {
    const res = await this.$axios.get(`/bands/${this.id}/events`);
    this.events = res.data;
  },
};
</script>
