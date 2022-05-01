<template>
  <v-container fluid>
    <v-row>
      <v-card v-if="$vuetify.breakpoint.mdAndDown" width="100%" outlined>
        <v-row align="center" class="mx-2">
          <v-col cols="10" sm="8" md="6">
            <CardActionsEventNameSearch v-model="keywordInput" />
          </v-col>
          <v-col class="d-flex justify-end">
            <v-btn icon @click="show = !show">
              <v-icon>
                {{ show ? "mdi-chevron-up" : "mdi-chevron-down" }}
              </v-icon>
            </v-btn>
          </v-col>
        </v-row>
        <v-expand-transition>
          <v-col v-show="show" class="py-0">
            <v-card flat class="d-flex flex-wrap">
              <v-col cols="10" sm="8" md="4">
                <CardActionsEventDateSearch v-model="dateInput" />
              </v-col>
              <v-col sm="5" md="4">
                <CardActionsEventSort
                  v-model="select"
                  @sort-order="moldDisplay"
                />
              </v-col>
              <v-col>
                <CardActionsEventPastSelect v-model="showPast" />
              </v-col>
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
                <CardActionsEventDateSearch v-model="dateInput" class="mb-3" />
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
      v-if="isAuthenticatedBand"
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
      pastEvents: [],
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
    const now = new Date();
    this.futureEvents = res.data.events.filter((event) => {
      return now.getTime() <= new Date(event.open_at).getTime();
    });
    this.pastEvents = res.data.events.filter((event) => {
      return now.getTime() >= new Date(event.open_at).getTime();
    });
    this.moldDisplay();
  },
  computed: {
    ...mapGetters(["isAuthenticatedBand"]),
    keyword() {
      if (this.keywordInput) {
        return this.keywordInput.toLowerCase().trim();
      } else {
        return "";
      }
    },
    date() {
      return this.dateInput ? this.dateInput : "";
    },
    filteredEvents() {
      let events = [];
      if (this.showPast) {
        events = this.pastEvents;
      } else {
        events = this.futureEvents;
      }
      return events.filter((event) => {
        return (
          event.name.toLowerCase().includes(this.keyword) &&
          event.open_at.includes(this.date)
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
        this.filteredEvents.sort(
          (a, b) => new Date(a.open_at) - new Date(b.open_at)
        );
      } else {
        this.filteredEvents.sort(
          (a, b) => new Date(b.open_at) - new Date(a.open_at)
        );
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
