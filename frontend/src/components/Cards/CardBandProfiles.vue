<template>
  <v-card flat class="d-flex flex-wrap">
    <v-col md="7" cols="12">
      <v-card-text>
        <v-img :src="bandImage" />
      </v-card-text>
    </v-col>
    <v-col md="5" class="text-left pb-0">
      <v-card flat>
        <v-card-title v-text="band.name" />
        <v-card-text v-text="band.profile" class="reflect-return" />
        <v-card-actions>
          <v-btn icon :href="band.website">
            <v-icon>mdi-link-variant</v-icon>
          </v-btn>
          <v-btn icon :href="band.twitter">
            <v-icon>mdi-twitter</v-icon>
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-col>
  </v-card>
</template>

<script>
export default {
  props: {
    band: {
      type: Object,
      require: true,
    },
  },
  computed: {
    bandImage() {
      return this.band.image && this.band.image.url
        ? this.band.image.url
        : require("@/assets/img/no-image.jpg");
    },
  },
};
</script>
