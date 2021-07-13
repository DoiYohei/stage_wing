<template>
  <div>
    <router-link to="/event/new" v-if="isAuthenticated"
      >Eventを投稿する</router-link
    >
    <v-container>
      <v-row>
        <v-text-field v-model="keywordInput" label="Event名で検索" />
        <vue-ctk-date-time-picker
          v-model="dateInput"
          format="YYYY-MM-DD"
          label="開催日で検索"
          only-date
        />
      </v-row>
    </v-container>
    <div v-for="(event, index) in filteredEvents" :key="index">
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
      fetchedEvents: [],
      keywordInput: "",
      dateInput: "",
    };
  },
  async created() {
    const res = await this.$axios.get("/events");
    this.fetchedEvents = res.data.events;
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters.authData !== null;
    },
    filteredEvents() {
      let keyword = this.keywordInput.toLowerCase().trim();
      if (!keyword && !this.dateInput) return this.fetchedEvents;
      return this.fetchedEvents.filter((event) => {
        return (
          event.name.toLowerCase().includes(keyword) &&
          event.open_at.includes(this.dateInput)
        );
      });
    },
  },
};
</script>
