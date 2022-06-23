<template>
  <v-card color="#121212" flat>
    <v-col>
      <v-btn v-if="isMyPage" to="/posts/new" light fab right bottom fixed>
        <v-icon dark>mdi-plus</v-icon>
      </v-btn>
      <CardPost
        v-for="(post, index) in displayPosts"
        :key="index"
        :post="post"
        @delete-post="deletePost"
        @patch-post="patchPost"
        @change-like="changeLike"
      />
      <v-col>
        <PaginationBlocks @change-page="moldDisplay" />
      </v-col>
    </v-col>
  </v-card>
</template>

<script>
import CardPost from "@/components/Cards/CardPost";
import PaginationBlocks from "@/components/PaginationBlocks";

export default {
  components: {
    CardPost,
    PaginationBlocks,
  },
  props: {
    posts: {
      type: Array,
      require: true,
    },
    isMyPage: {
      type: Boolean,
      require: true,
    },
  },
  data() {
    return {
      displayPosts: [],
    };
  },
  created() {
    this.moldDisplay();
  },
  watch: {
    posts() {
      this.moldDisplay();
    },
  },
  methods: {
    moldDisplay() {
      this.$page.rowsPerPage = 5;
      this.$page.displayContents = this.posts;
      this.displayPosts = this.$page.displayContents;
    },
    deletePost(postId) {
      this.$emit("delete-post", postId);
    },
    patchPost(postId, postDescription) {
      this.$emit("patch-post", postId, postDescription);
    },
    changeLike(post) {
      this.$emit("change-like", post);
    },
  },
};
</script>
