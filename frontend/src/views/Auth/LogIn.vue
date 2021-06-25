<template>
  <div class="login">
    <h1>Log In</h1>
    <div class="form">
      <label for="email">Email</label>
      <input type="email" v-model="email" id="email">
    </div>
    <div class="form">
      <label for="password">Password</label>
      <input type="password" v-model="password" id="password">
    </div>
    <button @click="logIn">Log In</button>
  </div>
</template>

<script>
export default {
  data () {
    return {
      email: '',
      password: ''
    }
  },
  methods: {
    logIn () {
      const formData = new FormData()
      formData.append('email', this.email)
      formData.append('password', this.password)
      this.$store.dispatch('login', formData)
    }
  }
}
</script>
