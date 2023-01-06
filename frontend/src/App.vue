<template>
  <v-app>
    <TheAppHeader
      v-if="!isHome || $vuetify.breakpoint.smAndDown"
      v-model="drawer"
    />
    <TheAppNavigationDrawer v-model="drawer" />
    <v-main><router-view v-model="drawer" /></v-main>
    <TheAppFooter v-if="!isHome" />
  </v-app>
</template>

<script>
import TheAppHeader from "@/components/TheApps/TheAppHeader";
import TheAppNavigationDrawer from "@/components/TheApps/TheAppNavigationDrawer";
import TheAppFooter from "@/components/TheApps/TheAppFooter";

export default {
  components: {
    TheAppHeader,
    TheAppNavigationDrawer,
    TheAppFooter,
  },
  data() {
    return {
      drawer: false,
    };
  },
  computed: {
    isHome() {
      return this.$route.path === "/";
    },
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
</style>
