<template>
  <v-container fluid>
    <v-row>
      <v-card v-if="$vuetify.breakpoint.mdAndDown" width="100%" outlined>
        <v-row align="end" class="mx-2">
          <v-col cols="10" sm="8" md="5">
            <CardActionsEventNameSearch v-model="keywordInput" />
          </v-col>
          <v-col>
            <v-btn icon @click="show = !show">
              <v-icon>
                {{ show ? "mdi-chevron-up" : "mdi-chevron-down" }}
              </v-icon>
            </v-btn>
          </v-col>
        </v-row>
        <v-expand-transition>
          <v-col v-show="show">
            <v-card flat class="d-flex flex-wrap" v-show="show">
              <CardActionsEventDateSearch v-model="dateInput" />
              <v-card flat max-width="37%">
                <CardActionsEventSort
                  v-model="select"
                  @sort-order="moldDisplay"
                />
              </v-card>
              <CardActionsEventPastSelect v-model="showPast" />
            </v-card>
          </v-col>
        </v-expand-transition>
      </v-card>
      <v-col class="d-flex flex-wrap">
        <v-col v-if="$vuetify.breakpoint.lgAndUp" xl="2" lg="3">
          <v-card>
            <v-col>
              <CardActionsEventNameSearch v-model="keywordInput" />
              <v-card flat class="mt-3">
                <CardActionsEventDateSearch v-model="dateInput" />
                <CardActionsEventSort
                  v-model="select"
                  @sort-order="moldDisplay"
                />
                <CardActionsEventPastSelect v-model="showPast" />
              </v-card>
            </v-col>
          </v-card>
        </v-col>
        <v-col class="pa-0">
          <v-col v-if="!displayEvents.length" class="mt-16">
            <v-card color="#121212" flat>
              <v-card-text class="text-center">
                該当するイベントがありません
              </v-card-text>
            </v-card>
          </v-col>
          <CardEvents :events="displayEvents" />
          <v-col>
            <PaginationBlocks @change-page="moldDisplay" />
          </v-col>
        </v-col>
      </v-col>
    </v-row>
    <v-btn
      v-if="bandId"
      to="/events/new"
      color="grey"
      dark
      fab
      right
      bottom
      fixed
    >
      <v-icon dark>mdi-plus</v-icon>
    </v-btn>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardActionsEventNameSearch from "@/components/CardActions/CardActionsEventNameSearch";
import CardActionsEventDateSearch from "@/components/CardActions/CardActionsEventDateSearch";
import CardActionsEventSort from "@/components/CardActions/CardActionsEventSort";
import CardActionsEventPastSelect from "@/components/CardActions/CardActionsEventPastSelect";
import CardEvents from "@/components/Cards/CardEvents";
import PaginationBlocks from "@/components/PaginationBlocks";

export default {
  components: {
    CardActionsEventNameSearch,
    CardActionsEventDateSearch,
    CardActionsEventSort,
    CardActionsEventPastSelect,
    CardEvents,
    PaginationBlocks,
  },
  data() {
    return {
      futureEvents: [],
      allEvents: [],
      keywordInput: "",
      dateInput: "",
      select: { key: 1, value: "開催が早い順" },
      showPast: false,
      show: false,
      displayEvents: [],
    };
  },
  async created() {
    const res = await this.$axios.get("/events");
    this.allEvents = res.data.events;

    // 今日開催のEventはfutureEventsに含める
    const now = new Date();
    const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
    this.futureEvents = this.allEvents.filter((event) => {
      return today.getTime() <= new Date(event.date).getTime();
    });
    this.moldDisplay();
  },
  computed: {
    ...mapGetters(["bandId"]),
    keyword() {
      if (this.keywordInput) {
        return this.keywordInput.toLowerCase().trim();
      } else {
        return "";
      }
    },
    filteredEvents() {
      let events = [];
      if (this.showPast) {
        events = this.allEvents;
      } else {
        events = this.futureEvents;
      }
      return events.filter((event) => {
        return (
          event.name.toLowerCase().includes(this.keyword) &&
          event.date.includes(this.dateInput)
        );
      });
    },
    rowsPerPage() {
      return this.$vuetify.breakpoint.smAndDown ? 10 : 30;
    },
  },
  methods: {
    moldDisplay() {
      if (this.select.key === 1) {
        this.filteredEvents.sort((a, b) => new Date(a.date) - new Date(b.date));
      } else {
        this.filteredEvents.sort((a, b) => new Date(b.date) - new Date(a.date));
      }
      this.$page.rowsPerPage = this.rowsPerPage;
      this.$page.displayContents = this.filteredEvents;
      this.displayEvents = this.$page.displayContents;
    },
  },
  watch: {
    filteredEvents() {
      this.$page.current = 1;
      this.moldDisplay();
    },
  },
};
</script>
