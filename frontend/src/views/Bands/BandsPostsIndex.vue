<template>
  <v-col>
    <CardPosts
      v-for="(post, index) in displayPosts"
      :key="index"
      :post="post"
      :delete-post="deletePost"
      :patch-post="patchPost"
      :change-like="changeLike"
    />
    <v-col>
      <PaginationBlocks :mold-display="moldDisplay" />
    </v-col>
  </v-col>
</template>

<script>
import { mapGetters } from "vuex";
import CardPosts from "@/components/Cards/CardPosts";
import PaginationBlocks from "@/components/PaginationBlocks";

export default {
  components: {
    CardPosts,
    PaginationBlocks,
  },
  props: ["id"],
  data() {
    return {
      displayPosts: [],
    };
  },
  async created() {
    const res = await this.$axios.get(`/bands/${this.id}/posts`, this.headers);
    this.posts = res.data;
    this.moldDisplay();
  },
  computed: {
    ...mapGetters(["isAuthenticatedBand", "userId", "headers", "token"]),
    isMyPage() {
      if (this.isAuthenticatedBand) {
        return this.userId === this.id;
      } else {
        return false;
      }
    },
  },
  methods: {
    moldDisplay() {
      this.$page.rowsPerPage = 5;
      this.$page.displayContents = this.posts;
      this.displayPosts = this.$page.displayContents;
    },
    async deletePost(postId) {
      await this.$axios.delete(
        `/bands/${this.id}/posts/${postId}`,
        this.headers
      );
      this.updatePage();
    },
    async patchPost(postId, postDescription) {
      const formData = new FormData();
      formData.append("post[description]", postDescription);
      await this.$axios.patch(
        `/bands/${this.id}/posts/${postId}`,
        formData,
        this.headers
      );
      this.updatePage();
    },
    changeLike(post) {
      if (!this.token) {
        return this.$router.push("/errors/auth");
      } else {
        const formData = new FormData();
        formData.append("post_id", post.id);
        if (post.favorite) {
          this.$axios.delete("/likes", {
            headers: this.token,
            data: formData,
          });
          post.favorite = false;
          post.likes_count -= 1;
        } else {
          this.$axios.post("/likes", formData, this.headers);
          post.favorite = true;
          post.likes_count += 1;
        }
      }
    },
    updatePage() {
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
  },
};
</script>
