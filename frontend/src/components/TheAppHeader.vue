<template>
  <v-app-bar fixed>
    <v-container class="fill-height">
      <v-toolbar-title>
        <router-link to="/">Stage Wing</router-link>
      </v-toolbar-title>
      <v-spacer />
      <v-toolbar-items>
        <v-btn plain large to="/events">Event</v-btn>
        <v-btn plain large to="/bands">Band</v-btn>
        <v-btn icon large>
          <v-avatar @click="drawer = !drawer" size="45">
            <v-img v-if="avatar" :src="avatar" />
            <v-img v-if="!avatar" src="@/assets/img/no_avatar.jpeg" />
          </v-avatar>
        </v-btn>
      </v-toolbar-items>
    </v-container>
  </v-app-bar>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: {
    value: {
      type: Boolean,
      require: true,
    },
  },
  computed: {
    ...mapGetters(["avatar"]),
    drawer: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
};
</script>
