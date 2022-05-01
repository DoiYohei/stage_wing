<template>
  <v-card :to="bandPage" flat>
    <v-card-actions class="pa-0">
      <v-avatar :size="size" class="mr-2">
        <v-img :src="avatarImage" />
      </v-avatar>
      <v-card-text class="white--text font-weight-medium pa-0">
        {{ avatar.name }}
      </v-card-text>
    </v-card-actions>
  </v-card>
</template>

<script>
export default {
  props: {
    avatar: {
      type: Object,
      require: true,
    },
    size: {
      type: String,
      default: "28",
    },
  },
  computed: {
    isAudience() {
      return this.avatar.user_type === "audiences";
    },
    avatarImage() {
      const image = this.avatar.image.url;
      if (image) {
        return image;
      } else if (!this.isAudience) {
        return require("@/assets/img/no-band-img.jpg");
      } else return require("@/assets/img/no-audience-img.jpeg");
    },
    bandPage() {
      return !this.isAudience ? `/bands/${this.avatar.id}` : "";
    },
  },
};
</script>
