<template>
  <v-container>
    <v-row>
      <v-card color="#121212" flat>
        <v-col>
          <CardActionsEventPastSelect v-model="showPast" />
          <v-card-text v-if="!displayEvents.length" class="px-3">
            出演予定のイベントはありません
          </v-card-text>
        </v-col>
      </v-card>
    </v-row>
    <v-row>
      <v-col
        v-for="(event, index) in displayEvents"
        :key="index"
        xl="3"
        lg="4"
        sm="6"
        cols="12"
      >
        <v-expansion-panels v-model="event.id">
          <v-expansion-panel>
            <v-expansion-panel-header>
              <v-card flat>
                <v-card-subtitle class="text-left py-0">
                  {{ $dayjs(event.date).format("YYYY年MM月DD日") }}
                </v-card-subtitle>
                <v-card-title class="py-0">
                  <router-link :to="`/events/${event.id}`" class="pr-2">
                    {{ event.name }}
                  </router-link>
                  ({{ event.audiences.length }})
                </v-card-title>
              </v-card>
            </v-expansion-panel-header>
            <v-expansion-panel-content>
              <v-simple-table>
                <tbody>
                  <tr
                    v-for="(audience, index) in event.audiences"
                    :key="index"
                    class="text-left"
                  >
                    <td>{{ index + 1 }}.</td>
                    <td>
                      <v-avatar size="24" class="mr-2">
                        <v-img :src="audienceImage(audience.image.url)" />
                      </v-avatar>
                      {{ audience.name }}
                    </td>
                  </tr>
                </tbody>
              </v-simple-table>
              <v-divider />
            </v-expansion-panel-content>
          </v-expansion-panel>
        </v-expansion-panels>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardActionsEventPastSelect from "@/components/CardActions/CardActionsEventPastSelect";

export default {
  components: {
    CardActionsEventPastSelect,
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
    try {
      if (Number(this.id) !== this.bandId) throw { response: "status 401" };
      const res = await this.$axios.get(
        `/bands/${this.id}/tickets`,
        this.headers
      );
      this.allEvents = res.data;

      // 今日開催のEventはfutureEventsに含める
      const now = new Date();
      const today = new Date(now.getFullYear(), now.getMonth(), now.getDate());
      this.futureEvents = this.allEvents.filter((event) => {
        return today.getTime() <= new Date(event.date).getTime();
      });
    } catch (error) {
      if (error.response) this.$router.replace("/");
    }
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
    displayEvents() {
      return this.showPast ? this.allEvents : this.futureEvents;
    },
    audienceImage() {
      return (image) => {
        return image ? image : require("@/assets/img/no-audience-img.jpeg");
      };
    },
  },
};
</script>
