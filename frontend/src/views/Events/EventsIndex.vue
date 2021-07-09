<template>
  <div>
    <router-link to="/event/new" v-if="isAuthenticated"
      >Eventを投稿する</router-link
    >
    <div v-for="(event, index) in events" :key="index">
      <router-link :to="`/events/${event.id}`">
        <span>{{ $dayjs(event.open_at).format("YYYY MMM DD") }}</span>
        <span> {{ event.name }}</span>
        <hr />
      </router-link>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      events: [],
    };
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters.authData !== null;
    },
  },
  async created() {
    const res = await this.$axios.get("/events");
    this.events = res.data.events;
  },
};
</script>
