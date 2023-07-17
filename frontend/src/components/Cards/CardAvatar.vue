<template>
  <v-card :to="bandPage" :max-width="maxWidth" flat class="d-flex align-center">
    <v-avatar :size="size" class="mr-2">
      <v-img :src="avatarImage" />
    </v-avatar>
    <v-card-subtitle
      class="white--text font-weight-medium pt-1 pb-0 px-0 text-truncate"
    >
      {{ avatar.name }}
    </v-card-subtitle>
  </v-card>
</template>

<script>
import { audienceImage, bandImage } from "@/utils/images";

export default {
  props: {
    avatar: {
      type: Object,
      require: true,
    },
    maxWidth: {
      type: String,
      default: "",
    },
    size: {
      type: String,
      default: "28",
    },
    userType: {
      type: String,
      default: "",
    },
  },
  computed: {
    isBand() {
      return this.userType === "bands";
    },
    avatarImage() {
      const image = this.avatar.image.url;
      return this.isBand ? bandImage(image) : audienceImage(image);
    },
    bandPage() {
      return this.isBand ? `/bands/${this.avatar.id}` : "";
    },
  },
};
</script>
