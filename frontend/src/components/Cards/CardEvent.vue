<template>
  <v-row>
    <v-col v-for="(event, index) in events" :key="index" :cols="cols">
      <v-card :to="`/events/${event.id}`" class="text-left d-flex align-center">
        <v-avatar size="68" tile class="ml-3 my-3">
          <v-img :src="eventFlyer(event.flyer.url)" />
        </v-avatar>
        <v-card
          height="68"
          tile
          flat
          class="d-flex flex-column align-start overflow-ellipsis"
        >
          <v-card-subtitle class="pt-1 pb-0">
            {{ $dayjs(event.date).format("YYYY年MM月DD日") }}
          </v-card-subtitle>
          <v-card-subtitle
            class="text-subtitle-1 font-weight-black py-1 pr-4 overflow-ellipsis"
          >
            {{ event.name }}
          </v-card-subtitle>
        </v-card>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import { respondCols } from "@/utils/grids";
import { eventFlyer } from "@/utils/images";

export default {
  props: {
    events: {
      type: Array,
      require: true,
    },
  },
  computed: {
    cols() {
      return respondCols(this.$vuetify.breakpoint, 3, 4, 4, 6, 12);
    },
    eventFlyer() {
      return (flyer) => eventFlyer(flyer);
    },
  },
};
</script>
