<template>
  <v-card color="#121212" flat class="d-flex flex-wrap">
    <v-col md="7" cols="12">
      <v-img :src="bandImage" aspect-ratio="1.37" />
    </v-col>
    <v-col md="5" class="text-left pb-0">
      <v-card color="#121212" flat>
        <v-card-title v-text="band.name" class="grey--text text--lighten-2" />
        <v-card-text v-text="band.profile" class="reflect-return" />
        <v-card-actions>
          <v-btn icon :href="band.website" :disabled="!band.website">
            <v-icon :color="band.website ? 'grey lighten-2' : ''">
              mdi-link-variant
            </v-icon>
          </v-btn>
          <v-btn icon :href="band.twitter" :disabled="!band.twitter">
            <v-icon :color="band.twitter ? 'grey lighten-2' : ''">
              mdi-twitter
            </v-icon>
          </v-btn>
          <v-spacer />
          <v-btn v-if="isMyPage" :to="`/bands/${band.id}/edit`" icon>
            <v-icon color="grey lighten-1">mdi-pencil-plus-outline</v-icon>
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
    isMyPage: {
      type: Boolean,
      require: true,
    },
  },
  computed: {
    bandImage() {
      return this.band.image && this.band.image.url
        ? this.band.image.url
        : require("@/assets/img/no-band-img.jpg");
    },
  },
};
</script>
