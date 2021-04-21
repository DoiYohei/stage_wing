<template>
  <div id="app">
    <header>
      <router-link to="/">Stage Wing</router-link>
      <router-link to="/events">Event</router-link>
      <router-link to="/bands">Band</router-link>
      <template v-if="!isAuthenticated">
        <router-link to="/signup">Sign Up</router-link>
        <router-link to="/login">Log In</router-link>
      </template>
      <template v-else>
        <span  class="logout" @click="logOut">Log Out</span>
      </template>
    </header>
    <router-view></router-view>
  </div>
</template>

<script>
export default {
  name: 'App',
  computed: {
    isAuthenticated () {
      return this.$store.getters.authData !== null
    }
  },
  methods: {
    logOut () {
      this.$store.dispatch('logout', {
        headers: this.$store.getters.authData
      })
    }
  }
}
</script>

<style>
#app {
  font-family: 'Avenir', Helvetica, Arial, sans-serif;
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
