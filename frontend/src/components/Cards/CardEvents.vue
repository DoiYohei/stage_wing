<template>
  <v-card color="#121212" flat class="d-flex flex-wrap">
    <v-col
      v-for="(event, index) in events"
      :key="index"
      xl="3"
      md="4"
      sm="6"
      cols="12"
    >
      <v-card :to="`/events/${event.id}`" class="text-left d-flex align-center">
        <v-avatar size="68" tile class="ml-3 my-3">
          <v-img :src="eventFlyer(event.flyer.url)" />
        </v-avatar>
        <div
          class="d-flex flex-sm-column align-sm-start align-center flex-wrap"
        >
          <v-card-subtitle class="pb-sm-0">
            {{ $dayjs(event.date).format("YYYY年MM月DD日") }}
          </v-card-subtitle>
          <v-card-subtitle class="text-subtitle-1 pt-sm-0">
            {{ event.name }}
          </v-card-subtitle>
        </div>
      </v-card>
    </v-col>
  </v-card>
</template>

<script>
export default {
  props: {
    events: {
      type: Array,
      require: true,
    },
  },
  computed: {
    eventFlyer() {
      return (flyer) => {
        return flyer ? flyer : require("@/assets/img/no-flyer.jpg");
      };
    },
  },
};
</script>
