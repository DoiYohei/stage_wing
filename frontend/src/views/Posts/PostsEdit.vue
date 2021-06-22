<template>
  <div>
    <h1>投稿内容の編集</h1>
    <div class="form">
      <label for="title">タイトル</label>
      <input type="text" v-model="post.title" id="title">
    </div>
    <div class="form">
      <label for="format">投稿の種類</label>
      <select v-model="post.format" id="format">
        <option value="">選択してください</option>
        <option value="photo">画像</option>
        <option value="audio">音源</option>
        <option value="soundcloud">SoundCloud埋め込み</option>
        <option value="youtube">YouTube埋め込み</option>
        <option value="news">お知らせ</option>
      </select>
    </div>
    <template v-if="this.whatStyle === 'file'">
      <div class="form">
        <input type="file" id="file" @change="setFile">
      </div>
    </template>
    <template v-if="this.whatStyle === 'media_pass'">
      <div class="form">
        <input type="text" v-model="post.mediaPass" id="media-pass">
      </div>
    </template>
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
      post: {},
      file: ''
    }
  },
  computed: {
    token () {
      return { headers: this.$store.getters.authData }
    },
    whatStyle () {
      if (this.post.format === 'photo' || this.post.format === 'audio') return 'file'
      if (this.post.format === 'soundcloud' || this.post.format === 'youtube') return 'media_pass'
    }
  },
  methods: {
    setFile (e) {
      this.file = e.target.files[0]
    },
    async patchInputs () {
      const formData = new FormData()
      formData.append('post[title]', this.post.title)
      formData.append('post[format]', this.post.format)
      formData.append('post[description]', this.post.description)
      if (this.whatStyle === 'file') {
        formData.append(`post[${this.post.format}]`, this.file)
      }
      if (this.whatStyle === 'media_pass') {
        formData.append('post[media_pass]', this.post.mediaPass)
      }
      await this.$axios.patch(`/posts/${this.postId}`, formData, this.token)
      this.$router.replace(`/bands/${this.id}/posts`)
    }
  },
  async created () {
    const res = await this.$axios.get(`/posts/${this.postId}/edit`, this.token)
    this.post = res.data
    if (this.post.format === 'photo') this.file = this.post.photo.url
    if (this.post.format === 'audio') this.file = this.post.audio.url
  }
}
</script>
