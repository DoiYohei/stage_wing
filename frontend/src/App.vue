<template>
  <v-app>
    <TheAppHeader v-if="!isHome" v-model="drawer" />
    <NavigationMenu v-model="drawer" />
    <v-main :class="headerSpace"><router-view /></v-main>
    <TheAppFooter v-if="!isHome" />
  </v-app>
</template>

<script>
import TheAppHeader from "@/components/TheAppHeader";
import NavigationMenu from "@/components/NavigationMenu";
import TheAppFooter from "@/components/TheAppFooter";

export default {
  components: {
    TheAppHeader,
    NavigationMenu,
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
    headerSpace() {
      return this.isHome ? "" : "mt-16";
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
</style>
