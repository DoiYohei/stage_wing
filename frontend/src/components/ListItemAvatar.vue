<template>
  <v-list-item-avatar>
    <v-img :src="avatar" />
  </v-list-item-avatar>
</template>

<script>
export default {
  props: {
    image: {
      type: String,
      default: null,
    },
  },
  computed: {
    avatar() {
      return this.image ? this.image : require("@/assets/img/no-band-img.jpg");
    },
  },
};
</script>
