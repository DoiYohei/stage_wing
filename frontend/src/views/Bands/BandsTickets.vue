<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <CardPageTitle title="チケット取り置き状況" />
    <v-row>
      <v-card color="#121212" flat>
        <v-col>
          <SearchInputPastEvent v-model="showPast" color="#121212" />
          <v-card-text v-if="!eventsForShow.length" class="px-3">
            出演予定のイベントはありません
          </v-card-text>
        </v-col>
      </v-card>
    </v-row>
    <v-row>
      <v-col v-for="(event, index) in eventsForShow" :key="index" :cols="cols">
        <v-card>
          <v-card-subtitle class="text-left pb-0">
            {{ $dayjs(event.date).format("YYYY年MM月DD日") }}
          </v-card-subtitle>
          <v-card flat class="d-flex align-center pb-2">
            <v-card :to="`/events/${event.id}`" max-width="75%" flat>
              <v-card-subtitle
                class="text-h6 white--text pr-0 py-0 overflow-ellipsis"
                >{{ event.name }}
              </v-card-subtitle>
            </v-card>
            <v-card-title class="pl-2 pr-0 py-0">
              ({{ event.audiences.length }})
            </v-card-title>
            <v-spacer />
            <v-card-actions v-if="event.audiences.length" class="py-0 px-1">
              <v-btn icon @click="event.show = !event.show">
                <v-icon>
                  {{ event.show ? "mdi-chevron-up" : "mdi-chevron-down" }}
                </v-icon>
              </v-btn>
            </v-card-actions>
          </v-card>
          <v-expand-transition>
            <v-list v-show="event.show" class="pt-0 px-8">
              <template v-for="(audience, index) in event.audiences">
                <v-list-item :key="index" class="pa-0">
                  <v-list-item-content class="pb-0">
                    {{ index + 1 }}.
                    <CardAvatar
                      :avatar="audience"
                      max-width="175"
                      userType="audiences"
                      size="20"
                      class="ml-4"
                    />
                  </v-list-item-content>
                </v-list-item>
                <v-divider :key="audience.id" />
              </template>
            </v-list>
          </v-expand-transition>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import SearchInputPastEvent from "@/components/SearchInputs/SearchInputPastEvent";
import CardAvatar from "@/components/Cards/CardAvatar";
import { mapGetters } from "vuex";
import { respondCols } from "@/utils/grids";
import { audienceImage } from "@/utils/images";
import { goHome } from "@/utils/routers";
import { popFutureItems } from "@/utils/searches";

export default {
  components: {
    CardPageTitle,
    SearchInputPastEvent,
    CardAvatar,
  },
  props: ["id"],
  data() {
    return {
      futureEvents: [],
      allEvents: [],
      showPast: false,
    };
  },
  async created() {
    if (Number(this.id) !== this.bandId) goHome();
    try {
      const res = await this.$axios.get(
        `/bands/${this.id}/tickets`,
        this.headers
      );
      this.allEvents = res.data;
      this.futureEvents = popFutureItems(this.allEvents);
    } catch (error) {
      if (error.response) goHome();
    }
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
    cols() {
      return respondCols(this.$vuetify.breakpoint, 3, 4, 6, 6, 12);
    },
    eventsForShow() {
      return this.showPast ? this.allEvents : this.futureEvents;
    },
    audienceImage() {
      return (image) => audienceImage(image);
    },
  },
};
</script>
