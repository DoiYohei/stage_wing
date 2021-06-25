<template>
  <div>
    <h1>投稿内容の編集</h1>
    <div class="form">
      <label for="title">タイトル</label>
      <input type="text" v-model="post.title" id="title">
    </div>
    <div class="form">
      <label for="description">内容</label>
      <textarea v-model="post.description" id="description"></textarea>
    </div>
    <button @click="patchInputs">変更する</button>
  </div>
</template>

<script>
export default {
  props: ['id', 'postId'],
  data () {
    return {
      post: {}
    }
  },
  computed: {
    token () {
      return { headers: this.$store.getters.token }
    }
  },
  methods: {
    async patchInputs () {
      const formData = new FormData()
      formData.append('post[title]', this.post.title)
      formData.append('post[description]', this.post.description)
      await this.$axios.patch(`/posts/${this.postId}`, formData, this.token)
      this.$router.replace(`/bands/${this.id}/posts`)
    }
  },
  async created () {
    const res = await this.$axios.get(`/posts/${this.postId}/edit`, this.token)
    this.post = res.data
  }
}
</script>
