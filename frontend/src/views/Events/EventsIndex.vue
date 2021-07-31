<template>
  <div>
    <router-link to="/event/new" v-if="isAuthenticated"
      >Eventを投稿する</router-link
    >
    <v-container>
      <v-row>
        <v-col cols="8">
          <v-col md="6" offset-md="6">
            <v-text-field v-model="keywordInput" label="Event名で検索" />
          </v-col>
          <v-col md="3" offset-md="6">
            <vue-ctk-date-time-picker
              v-model="dateInput"
              format="YYYY-MM-DD"
              label="開催日で検索"
              only-date
            />
          </v-col>
        </v-col>
        <v-col md="2">
          <v-checkbox
            v-model="selectPastEvents"
            label="開催が終了したイベントを検索"
          />
        </v-col>
        <v-col md="2">
          <v-select
            v-model="select"
            :items="sortList"
            item-text="value"
            @change="sortOrder"
            return-object
            solo
          />
        </v-col>
        <v-col cols="12" v-for="(event, index) in filteredEvents" :key="index">
          <hr />
          <router-link :to="`/events/${event.id}`">
            <span>{{ $dayjs(event.open_at).format("YYYY MMM DD") }}</span>
            <span> {{ event.name }}</span>
          </router-link>
          <hr />
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      futureEvents: [],
      pastEvents: [],
      keywordInput: "",
      dateInput: "",
      select: { key: 1, value: "開催日が近い順" },
      sortList: [
        { key: 1, value: "開催日が近い順" },
        { key: 2, value: "開催日が遠い順" },
      ],
      selectPastEvents: false,
    };
  },
  async created() {
    const res = await this.$axios.get("/events");
    const now = new Date();
    this.futureEvents = res.data.events.filter((event) => {
      return now.getTime() <= new Date(event.open_at).getTime();
    });
    this.pastEvents = res.data.events.filter((event) => {
      return now.getTime() >= new Date(event.open_at).getTime();
    });
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters.authData !== null;
    },
    filteredEvents() {
      let events = [];
      if (this.selectPastEvents) events = this.pastEvents;
      if (!this.selectPastEvents) events = this.futureEvents;
      let keyword = this.keywordInput.toLowerCase().trim();
      if (!keyword && !this.dateInput) return events;
      return events.filter((event) => {
        return (
          event.name.toLowerCase().includes(keyword) &&
          event.open_at.includes(this.dateInput)
        );
      });
    },
  },
  methods: {
    sortOrder() {
      if (this.select.key === 1) {
        return this.filteredEvents.sort(
          (a, b) => new Date(a.open_at) - new Date(b.open_at)
        );
      }
      if (this.select.key === 2) {
        return this.filteredEvents.sort(
          (a, b) => new Date(b.open_at) - new Date(a.open_at)
        );
      }
    },
  },
};
</script>
