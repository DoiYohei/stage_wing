<template>
  <v-app>
    <TheAppHeader v-if="!isHome || isSmallDisplay" v-model="drawer" />
    <TheAppNavigationDrawer v-model="drawer" />
    <TheAppDialog
      :isShow="isError"
      :text="errorText"
      @close-dialog="clearError"
    />
    <v-main><router-view v-model="drawer" /></v-main>
    <TheAppFooter />
  </v-app>
</template>

<script>
import TheAppHeader from "@/components/TheApps/TheAppHeader";
import TheAppNavigationDrawer from "@/components/TheApps/TheAppNavigationDrawer";
import TheAppDialog from "@/components/TheApps/TheAppDialog";
import TheAppFooter from "@/components/TheApps/TheAppFooter";
import { mapGetters, mapActions } from "vuex";

export default {
  components: {
    TheAppHeader,
    TheAppNavigationDrawer,
    TheAppDialog,
    TheAppFooter,
  },
  data() {
    return {
      drawer: false,
    };
  },
  computed: {
    ...mapGetters(["isError", "errorText"]),
    isHome() {
      return this.$route.path === "/";
    },
    isSmallDisplay() {
      return this.$vuetify.breakpoint.smAndDown;
    },
  },
  methods: {
    ...mapActions(["clearError"]),
  },
};
</script>

<style>
@charset "UTF-8";

html {
  font-size: 100%;
}
a {
  text-decoration: none;
}
img {
  max-width: 100%;
}

#app {
  font-family: "Avenir", Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}

.reflect-return {
  white-space: pre-wrap;
}

.reply-comment {
  border: thin;
  border-style: none none outset inset;
}

.overflow-ellipsis {
  overflow: hidden;
  white-space: nowrap;
  text-overflow: ellipsis;
  width: 100%;
}
</style>
