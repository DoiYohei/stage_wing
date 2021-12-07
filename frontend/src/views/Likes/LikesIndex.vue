<template>
  <div>
    <h1>お気に入り</h1>
    <v-container>
      <v-row>
        <v-col md="4" offset-md="4" v-for="(post, index) in posts" :key="index">
          <span>{{ post.created_at }}</span>
          <span>{{ post.title }}</span>
          <v-btn
            v-if="isLiked(post)"
            icon
            color="red"
            @click="changeLike(post)"
          >
            <v-icon>mdi-heart</v-icon>
          </v-btn>
          <v-btn v-else icon @click="changeLike(post)">
            <v-icon>mdi-heart-outline</v-icon>
          </v-btn>
          <span>{{ post.likes_count }}</span>
          <div v-if="isMyPost(post.band_id)">
            <router-link :to="`/bands/${post.band_id}/posts/${post.id}/edit`"
              >編集する</router-link
            >
            <button @click="deletePost(post.id)">削除する</button>
          </div>
          <div v-if="post.format === 'photo'">
            <img :src="post.photo.url" />
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
  </div>
</template>

<script>
export default {
  data() {
    return {
      posts: [],
      myLikes: null,
    };
  },
  async created() {
    const token = { headers: this.$store.getters.token };
    const res = await this.$axios.get("/likes", token);
    this.posts = res.data;
    this.myLikes = res.data.map((post) => post.id);
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters.authData;
    },
    isMyPost() {
      return (bandId) => {
        if (this.$store.getters.userType === "band") {
          return this.$store.getters.currentUserId === bandId;
        } else {
          return false;
        }
      };
    },
    isLiked() {
      return (post) => {
        return this.myLikes ? this.myLikes.includes(post.id) : false;
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
    changeLike(post) {
      if (!this.isAuthenticated) {
        return this.$router.push("/errors/auth");
      } else {
        const token = { headers: this.$store.getters.token };
        const formData = new FormData();
        formData.append("post_id", post.id);
        if (this.isLiked(post)) {
          this.$axios.delete("/likes", {
            headers: this.$store.getters.token,
            data: formData,
          });
          const newMyLikes = this.myLikes.filter(
            (myLike) => myLike !== post.id
          );
          this.myLikes = newMyLikes;
          post.likes_count -= 1;
        } else {
          this.$axios.post("/likes", formData, token);
          this.myLikes.push(post.id);
          post.likes_count += 1;
        }
      }
    },
  },
};
</script>
