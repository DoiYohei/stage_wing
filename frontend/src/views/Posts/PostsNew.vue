<template>
  <div>
    <h1>新規投稿作成</h1>
    <div class="form">
      <label for="title">タイトル</label>
      <input type="text" v-model="title" id="title">
    </div>
    <div class="form">
      <label for="format">投稿の種類</label>
      <select v-model="format" id="format">
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
        <input type="text" v-model="mediaPass" id="media-pass">
      </div>
    </template>
    <div class="form">
      <label for="description">内容</label>
      <textarea v-model="description" id="description"></textarea>
    </div>
    <button @click="postInputs">投稿する</button>
  </div>
</template>

<script>
export default {
  props: ['id'],
  data () {
    return {
      title: '',
      format: '',
      file: '',
      mediaPass: '',
      description: ''
    }
  },
  computed: {
    whatStyle () {
      if (this.format === 'photo' || this.format === 'audio') return 'file'
      if (this.format === 'soundcloud' || this.format === 'youtube') return 'media_pass'
    }
  },
  methods: {
    setFile (e) {
      this.file = e.target.files[0]
    },
    async postInputs () {
      const token = {
        headers: this.$store.getters.authData
      }
      const formData = new FormData()
      formData.append('post[title]', this.title)
      formData.append('post[format]', this.format)
      formData.append('post[description]', this.description)
      if (this.whatStyle === 'file') {
        formData.append(`post[${this.format}]`, this.file)
      }
      if (this.whatStyle === 'media_pass') {
        formData.append('post[media_pass]', this.mediaPass)
      }
      await this.$axios.post('/posts', formData, token)
      this.$router.replace(`/bands/${this.id}/posts`)
    }
  }
}
</script>
