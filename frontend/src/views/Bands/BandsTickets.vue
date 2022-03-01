<template>
  <v-container>
    <v-row>
      <v-col
        v-for="(event, index) in events"
        :key="index"
        xl="3"
        lg="4"
        sm="6"
        cols="12"
      >
        <v-expansion-panels>
          <v-expansion-panel>
            <v-expansion-panel-header>
              <v-card flat>
                <v-card-subtitle class="text-left py-0">
                  {{ $dayjs(event.open_at).format("YYYY MMM DD") }}
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
                    <td>{{ audience.name }}</td>
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

export default {
  props: {
    id: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      events: [],
    };
  },
  async created() {
    const res = await this.$axios.get(
      `/bands/${this.id}/tickets`,
      this.headers
    );
    this.events = res.data;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
};
</script>
