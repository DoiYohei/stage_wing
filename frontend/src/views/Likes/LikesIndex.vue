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
import { mapGetters } from "vuex";

export default {
  data() {
    return {
      posts: [],
      myLikes: null,
    };
  },
  async created() {
    const res = await this.$axios.get("/likes", this.headers);
    this.posts = res.data;
    this.myLikes = res.data.map((post) => post.id);
  },
  computed: {
    ...mapGetters(["headers", "token", "isAuthenticatedBand", "userId"]),
    isMyPost() {
      return (bandId) => {
        this.isAuthenticatedBand ? this.userId === bandId : false;
      };
    },
    isLiked() {
      return (post) => {
        this.myLikes ? this.myLikes.includes(post.id) : false;
      };
    },
  },
  methods: {
    async deletePost(postId) {
      await this.$axios.delete(`/posts/${postId}`, this.headers);
      const newPosts = this.posts.filter((post) => post.id !== postId);
      this.posts = newPosts;
    },
    changeLike(post) {
      if (!this.token) {
        return this.$router.push("/errors/auth");
      } else {
        const formData = new FormData();
        formData.append("post_id", post.id);
        if (this.isLiked(post)) {
          this.$axios.delete("/likes", {
            headers: this.token,
            data: formData,
          });
          const newMyLikes = this.myLikes.filter(
            (myLike) => myLike !== post.id
          );
          this.myLikes = newMyLikes;
          post.likes_count -= 1;
        } else {
          this.$axios.post("/likes", formData, this.headers);
          this.myLikes.push(post.id);
          post.likes_count += 1;
        }
      }
    },
  },
};
</script>
