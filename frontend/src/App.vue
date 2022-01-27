<template>
  <v-app>
    <header>
      <router-link to="/">Stage Wing</router-link>
      <router-link to="/events">Event</router-link>
      <router-link to="/bands">Band</router-link>
      <template v-if="!token">
        <router-link to="/signup">Sign Up</router-link>
        <router-link to="/login">Log In</router-link>
      </template>
      <template v-else>
        <span class="logout" @click="logout">Log Out</span>
      </template>
      <template v-if="isAuthenticatedBand">
        <router-link :to="`/bands/${userId}`">My Page</router-link>
      </template>
      <template v-if="isAuthenticatedAudience">
        <router-link :to="`/audiences/${userId}`">My Page</router-link>
      </template>
    </header>
    <router-view></router-view>
  </v-app>
</template>

<script>
import { mapGetters } from "vuex";
import { mapActions } from "vuex";

export default {
  name: "App",
  computed: {
    ...mapGetters([
      "token",
      "isAuthenticatedBand",
      "isAuthenticatedAudience",
      "userId",
    ]),
  },
  methods: {
    ...mapActions(["logout"]),
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

.logout {
  cursor: pointer;
}

.reflect-return {
  white-space: pre-wrap;
}
</style>
