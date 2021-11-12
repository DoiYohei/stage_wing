<template>
  <v-app>
    <header>
      <router-link to="/">Stage Wing</router-link>
      <router-link to="/events">Event</router-link>
      <router-link to="/bands">Band</router-link>
      <template v-if="!isAuthenticated">
        <router-link to="/signup">Sign Up</router-link>
        <router-link to="/login">Log In</router-link>
      </template>
      <template v-else>
        <span class="logout" @click="logOut">Log Out</span>
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
export default {
  name: "App",
  computed: {
    isAuthenticated() {
      return this.$store.getters.authData !== null;
    },
    isAuthenticatedBand() {
      return this.$store.getters.userType === "band";
    },
    isAuthenticatedAudience() {
      return this.$store.getters.userType === "audience";
    },
    userId() {
      return this.$store.getters.currentUserId;
    },
  },
  methods: {
    logOut() {
      const token = { headers: this.$store.getters.token };
      const userType = this.$store.getters.userType;
      this.$store.dispatch("logout", { token, userType });
      if (this.$route.path !== "/") {
        return this.$router.replace("/");
      }
    },
  },
};
</script>

<style>
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
</style>
