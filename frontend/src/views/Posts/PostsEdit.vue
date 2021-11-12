<template>
  <div>
    <h1>投稿内容の編集</h1>
    <v-container>
      <v-row>
        <v-col md="4" offset-md="4">
          <v-text-field v-model="post.title" label="タイトル" />
        </v-col>
        <v-col md="4" offset-md="4">
          <v-textarea v-model="post.description" label="内容" outlined />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="patchInputs">変更する</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  props: ["id", "postId"],
  data() {
    return {
      post: {},
    };
  },
  computed: {
    token() {
      return { headers: this.$store.getters.token };
    },
  },
  methods: {
    async patchInputs() {
      const formData = new FormData();
      formData.append("post[title]", this.post.title);
      formData.append("post[description]", this.post.description);
      await this.$axios.patch(`/posts/${this.postId}`, formData, this.token);
      this.$router.replace(`/bands/${this.id}/posts`);
    },
  },
  async created() {
    const res = await this.$axios.get(`/posts/${this.postId}/edit`, this.token);
    this.post = res.data;
  },
};
</script>
