<template>
  <v-container fluid>
    <v-row v-if="$vuetify.breakpoint.mdAndDown">
      <v-card width="100%">
        <v-row align="center">
          <v-col cols="6">
            <v-card-text>
              <v-text-field
                v-model="keywordInput"
                prepend-icon="mdi-magnify"
                placeholder="Event名で検索"
                clearable
                dense
                hide-details
              />
            </v-card-text>
          </v-col>
          <v-col offset="4">
            <v-btn icon @click="show = !show">
              <v-icon>
                {{ show ? "mdi-chevron-up" : "mdi-chevron-down" }}
              </v-icon>
            </v-btn>
          </v-col>
        </v-row>
        <v-expand-transition>
          <v-col v-show="show">
            <v-card class="d-flex flex-wrap">
              <v-col cols="6">
                <v-card-text>
                  <vue-ctk-date-time-picker
                    v-model="dateInput"
                    format="YYYY-MM-DD"
                    label="開催日で検索"
                    only-date
                  />
                </v-card-text>
              </v-col>
              <v-col cols="6">
                <v-card-text>
                  <v-select
                    v-model="select"
                    @change="sortOrder"
                    :items="sortList"
                    item-text="value"
                    label="並び替え"
                    dense
                    hide-details
                    outlined
                    return-object
                  />
                </v-card-text>
              </v-col>
              <v-col class="py-0">
                <v-card-text>
                  <v-checkbox
                    v-model="selectPastEvents"
                    label="開催が終了したイベント"
                    dense
                  />
                </v-card-text>
              </v-col>
            </v-card>
          </v-col>
        </v-expand-transition>
      </v-card>
    </v-row>
    <v-row>
      <v-col class="d-flex flex-wrap">
        <v-col v-if="$vuetify.breakpoint.lgAndUp" xl="2" lg="3" md="4">
          <v-card outlined>
            <v-card-text>
              <v-text-field
                v-model="keywordInput"
                placeholder="Event名で検索"
                prepend-icon="mdi-magnify"
                clearable
                hide-details
              />
            </v-card-text>
            <v-col>
              <v-card>
                <v-card-actions>
                  <vue-ctk-date-time-picker
                    v-model="dateInput"
                    format="YYYY-MM-DD"
                    label="開催日で検索"
                    only-date
                  />
                </v-card-actions>
                <v-card-actions>
                  <v-select
                    v-model="select"
                    @change="sortOrder"
                    :items="sortList"
                    item-text="value"
                    label="並び替え"
                    dense
                    hide-details
                    outlined
                    return-object
                  />
                </v-card-actions>
                <v-card-actions class="py-0">
                  <v-checkbox
                    v-model="selectPastEvents"
                    label="開催が終了したイベント"
                    dense
                  />
                </v-card-actions>
              </v-card>
            </v-col>
          </v-card>
        </v-col>
        <v-col class="pa-0">
          <v-card flat class="d-flex flex-wrap">
            <v-col
              v-for="(event, index) in displayEvents"
              :key="index"
              xl="3"
              md="4"
              sm="6"
              cols="12"
            >
              <v-card
                :to="`/events/${event.id}`"
                class="text-left d-flex align-center"
              >
                <v-avatar size="68" tile class="ml-3 my-3">
                  <v-img :src="event.flyer.thumb.url" />
                </v-avatar>
                <div
                  class="
                    d-flex
                    flex-sm-column
                    align-sm-start align-center
                    flex-wrap
                  "
                >
                  <v-card-subtitle class="pb-sm-0">
                    {{ $dayjs(event.open_at).format("YYYY MMM DD") }}
                  </v-card-subtitle>
                  <v-card-subtitle class="text-subtitle-1 pt-sm-0">
                    {{ event.name }}
                  </v-card-subtitle>
                </div>
              </v-card>
            </v-col>
          </v-card>
          <v-col>
            <PaginationBlocks :mold-display="moldDisplay" />
            <div v-if="!this.displayEvents.length" class="mt-16">
              該当するイベントがありません
            </div>
          </v-col>
        </v-col>
      </v-col>
    </v-row>
    <v-btn
      v-if="isAuthenticatedBand"
      to="/event/new"
      color="grey"
      dark
      fab
      right
      fixed
    >
      <v-icon dark>mdi-plus</v-icon>
    </v-btn>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import PaginationBlocks from "@/components/PaginationBlocks";

export default {
  components: {
    PaginationBlocks,
  },
  data() {
    return {
      futureEvents: [],
      pastEvents: [],
      keywordInput: "",
      dateInput: "",
      select: { key: 1, value: "開催が早い順" },
      sortList: [
        { key: 1, value: "開催が早い順" },
        { key: 2, value: "開催が遅い順" },
      ],
      selectPastEvents: false,
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
      if (this.selectPastEvents) {
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
    sortOrder() {
      if (this.select.key === 1) {
        this.filteredEvents.sort(
          (a, b) => new Date(a.open_at) - new Date(b.open_at)
        );
      } else {
        this.filteredEvents.sort(
          (a, b) => new Date(b.open_at) - new Date(a.open_at)
        );
      }
      this.moldDisplay();
    },
    moldDisplay() {
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
