<template>
  <div>
    <router-link :to="`/bands/${id}/posts/new`">新規投稿作成</router-link>
    <div v-for="(post, index) in posts" :key="index">
      <span>{{post.created_at}}</span>
      <span>{{post.title}}</span>
      <router-link :to="`/bands/${id}/posts/${post.id}/edit`">編集する</router-link>
      <button @click="deletePost(post.id)">削除する</button>
      <div v-if="post.format === 'photo'">
        <img :src="post.photo.thumb.url">
      </div>
      <div v-if="post.format === 'audio'">
        <audio controls :src="post.audio.url"></audio>
      </div>
      <div v-if="post.format === 'soundcloud'">
        <iframe width="50%" height="166" scrolling="no" frameborder="no"  :src="'https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/' + post.media_pass"></iframe>
      </div>
      <div v-if="post.format === 'youtube'">
        <youtube :video-id="post.media_pass"></youtube>
      </div>
      <div>{{post.description}}</div>
    </div>
  </div>
</template>

<script async custom-element="amp-soundcloud" src="https://cdn.ampproject.org/v0/amp-soundcloud-0.1.js"></script>

<script>
export default {
  props: ['id'],
  data () {
    return {
      posts: []
    }
  },
  methods: {
    getPosts () {
      const bandId = {band_id: Number(this.id)}
      const res = await this.$axios.get('/posts', {params: bandId})
      this.posts = res.data
    },
    async deletePost (post_id) {
      const token = {headers: this.$store.getters.authData}
      await this.$axios.delete(`/posts/${post_id}`, token)
      this.getPosts()
    }
  },
  async created () {
    this.getPosts()
  }
}
</script>
