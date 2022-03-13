<template>
  <v-app>
    <AppHeader />
    <v-main><router-view /></v-main>
  </v-app>
</template>

<script>
import AppHeader from "@/components/AppHeader";

export default {
  components: {
    AppHeader,
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
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}

.reflect-return {
  white-space: pre-wrap;
}
</style>
