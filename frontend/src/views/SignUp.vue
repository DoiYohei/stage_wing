<template>
  <div class="signup">
    <h1>Sign Up</h1>
    <div class="form">
      <label for="name">Band Name</label>
      <input type="text" v-model="name" id="name">
    </div>
    <div class="form">
      <label for="email">Email</label>
      <input type="email" v-model="email" id="email">
    </div>
    <div class="form">
      <label for="password">Password</label>
      <input type="password" v-model="password" id="password">
    </div>
    <button @click="signUp">Sign Up</button>
  </div>
</template>

<script>
export default {
  data () {
    return {
      name: '',
      email: '',
      password: ''
    }
  },
  methods: {
    signUp () {
      this.$store.dispatch('signup', {
        name: this.name,
        email: this.email,
        password: this.password
      })
    }
  }
}
</script>
