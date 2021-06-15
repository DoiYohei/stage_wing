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
    <div class="form">
      <label for="image">プロフィール画像</label>
      <input type="file" id="image" @change="setImage">
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
      password: '',
      image: ''
    }
  },
  methods: {
    setImage (e) {
      this.image = e.target.files[0]
    },
    signUp () {
      const formData = new FormData()
      formData.append('name', this.name)
      formData.append('email', this.email)
      formData.append('password', this.password)
      formData.append('image', this.image)
      this.$store.dispatch('signup', formData)
    }
  }
}
</script>
