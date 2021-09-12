<template>
  <v-container>
    <v-row>
      <v-col md="4" offset-md="4" v-if="isMyPage">
        <router-link :to="`/bands/${id}/posts/new`">新規投稿作成</router-link>
      </v-col>
      <v-col md="4" offset-md="4" v-for="(post, index) in posts" :key="index">
        <span>{{ post.created_at }}</span>
        <span>{{ post.title }}</span>
        <v-btn
          v-if="isLiked(post.id)"
          icon
          color="red"
          @click="changeLike(post.id)"
        >
          <v-icon>mdi-heart</v-icon>
        </v-btn>
        <v-btn v-else icon @click="changeLike(post.id)">
          <v-icon>mdi-heart-outline</v-icon>
        </v-btn>
        <span>{{ post.likes_count }}</span>
        <div v-if="isMyPage">
          <router-link :to="`/bands/${id}/posts/${post.id}/edit`"
            >編集する</router-link
          >
          <button @click="deletePost(post.id)">削除する</button>
        </div>
        <div v-if="post.format === 'photo'">
          <img :src="post.photo.thumb.url" />
        </div>
        <div v-if="post.format === 'audio'">
          <audio controls :src="post.audio.url"></audio>
        </div>
        <div v-if="post.format === 'soundcloud'">
          <iframe
            width="50%"
            height="166"
            scrolling="no"
            frameborder="no"
            :src="`https://w.soundcloud.com/player/?url=https%3A//api.soundcloud.com/tracks/${post.media_pass}`"
          ></iframe>
        </div>
        <div v-if="post.format === 'youtube'">
          <youtube :video-id="post.media_pass"></youtube>
        </div>
        <div>{{ post.description }}</div>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      posts: [],
      myLikes: [],
    };
  },
  async created() {
    const token = this.$store.getters.token;
    const bandId = { band_id: Number(this.id) };
    const res = await this.$axios.get("/posts", {
      params: bandId,
      headers: token,
    });
    this.posts = res.data.posts;
    this.myLikes = res.data.liked_post_ids;
  },
  computed: {
    isMyPage() {
      if (this.$store.getters.authData) {
        return this.$store.getters.currentUserId === Number(this.id);
      }
      return false;
    },
    isLiked() {
      return (postId) => {
        return this.myLikes ? this.myLikes.includes(postId) : false;
      };
    },
  },
  methods: {
    async deletePost(postId) {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(`/posts/${postId}`, token);
      const newPosts = this.posts.filter((post) => post.id !== postId);
      this.posts = newPosts;
    },
    changeLike(postId) {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("post_id", postId);
      if (this.isLiked(postId)) {
        this.$axios.delete("/likes", {
          headers: this.$store.getters.token,
          data: formData,
        });
        const newMyLikes = this.myLikes.filter((myLike) => myLike !== postId);
        this.myLikes = newMyLikes;
        return;
      }
      this.$axios.post("/likes", formData, token);
      this.myLikes.push(postId);
    },
  },
};
</script>
