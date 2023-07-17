<template>
  <v-container fluid>
    <v-row>
      <v-card
        v-if="$vuetify.breakpoint.mdAndDown"
        color="grey darken-4"
        width="100%"
        flat
        tile
      >
        <v-row align="end" class="px-2 px-sm-3">
          <v-col sm="9" md="6">
            <SearchInputName v-model="keyword" label="Event" />
          </v-col>
          <v-col cols="1" class="pl-0 mr-6">
            <v-btn icon @click="show = !show">
              <v-icon>
                {{ show ? "mdi-chevron-up" : "mdi-chevron-down" }}
              </v-icon>
            </v-btn>
          </v-col>
        </v-row>
        <v-expand-transition>
          <v-col v-show="show" class="px-2 px-sm-3">
            <v-card
              v-show="show"
              color="grey darken-4"
              flat
              class="d-flex flex-wrap"
            >
              <SearchInputEventSort
                v-model="select"
                @sort-order="sliceEventsForShow"
              />
              <SearchInputEventDate v-model="date" />
              <SearchInputPastEvent v-model="showPast" color="grey darken-4" />
            </v-card>
          </v-col>
        </v-expand-transition>
      </v-card>
      <v-col class="d-flex flex-wrap px-0 px-sm-1 px-xl-3">
        <v-col v-if="$vuetify.breakpoint.lgAndUp" xl="2" lg="3">
          <v-card color="grey darken-4" flat class="pa-3">
            <SearchInputName v-model="keyword" label="Event" />
            <v-card color="grey darken-4" flat class="mt-3">
              <SearchInputEventSort
                v-model="select"
                @sort-order="sliceEventsForShow"
              />
              <SearchInputEventDate v-model="date" />
              <SearchInputPastEvent v-model="showPast" color="grey darken-4" />
            </v-card>
          </v-card>
        </v-col>
        <v-col>
          <v-col v-if="!eventsForShow.length" class="mt-16">
            <v-card color="#121212" flat>
              <v-card-text class="text-center">
                該当するイベントがありません
              </v-card-text>
            </v-card>
          </v-col>
          <CardEvent :events="eventsForShow" />
          <v-col>
            <PaginationBlocks
              v-model="page"
              :contents="filteredEvents"
              :rows="rows"
            />
          </v-col>
        </v-col>
      </v-col>
    </v-row>
    <ButtonToNew v-if="bandId" pass="/events/new" />
  </v-container>
</template>

<script>
import SearchInputName from "@/components/SearchInputs/SearchInputName";
import SearchInputEventDate from "@/components/SearchInputs/SearchInputEventDate";
import SearchInputEventSort from "@/components/SearchInputs/SearchInputEventSort";
import SearchInputPastEvent from "@/components/SearchInputs/SearchInputPastEvent";
import CardEvent from "@/components/Cards/CardEvent";
import PaginationBlocks from "@/components/PaginationBlocks";
import ButtonToNew from "@/components/Buttons/ButtonToNew";
import { mapGetters } from "vuex";
import {
  popFutureItems,
  sortDatesByEarliestToLatest,
  sortDatesByLatestToEarliest,
  narrowDownNames,
  narrowDownDates,
} from "@/utils/searches";
import { sliceContentsForShow } from "@/utils/pagination";

export default {
  components: {
    SearchInputName,
    SearchInputEventDate,
    SearchInputEventSort,
    SearchInputPastEvent,
    CardEvent,
    PaginationBlocks,
    ButtonToNew,
  },
  data() {
    return {
      futureEvents: [],
      allEvents: [],
      keyword: "",
      date: "",
      select: { key: 1, value: "開催が早い順" },
      showPast: false,
      show: false,
      eventsForShow: [],
      page: 1,
    };
  },
  async created() {
    const res = await this.$axios.get("/events");
    this.allEvents = res.data.events;
    this.futureEvents = popFutureItems(this.allEvents);
    this.sliceEventsForShow();
  },
  computed: {
    ...mapGetters(["bandId"]),
    filteredEvents() {
      let events = this.showPast ? this.allEvents : this.futureEvents;
      this.select.key === 1
        ? sortDatesByEarliestToLatest(events)
        : sortDatesByLatestToEarliest(events);
      events = narrowDownNames(this.keyword, events);
      events = narrowDownDates(this.date, events);
      return events;
    },
    rows() {
      return this.$vuetify.breakpoint.smAndDown ? 10 : 30;
    },
  },
  watch: {
    filteredEvents() {
      this.page = 1;
      this.sliceEventsForShow();
    },
    page() {
      this.sliceEventsForShow();
    },
  },
  methods: {
    sliceEventsForShow() {
      this.eventsForShow = sliceContentsForShow(
        this.filteredEvents,
        this.page,
        this.rows
      );
    },
  },
};
</script>
