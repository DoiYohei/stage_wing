<template>
  <v-card color="#121212" flat>
    <v-col>
      <CardPost
        v-for="(post, index) in postsForShow"
        :key="index"
        :post="post"
        @delete-post="deletePost"
        @patch-post="patchPost"
        @change-like="changeLike"
      />
      <v-col>
        <PaginationBlocks v-model="page" :contents="posts" :rows="rows" />
      </v-col>
      <ButtonToNew v-if="isMyPage" pass="/posts/new" />
    </v-col>
  </v-card>
</template>

<script>
import CardPost from "@/components/Cards/CardPost";
import PaginationBlocks from "@/components/PaginationBlocks";
import ButtonToNew from "@/components/Buttons/ButtonToNew";
import { sliceContentsForShow } from "@/utils/pagination";

export default {
  components: {
    CardPost,
    PaginationBlocks,
    ButtonToNew,
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
      postsForShow: [],
      page: 1,
      rows: 5,
    };
  },
  created() {
    this.slicePostsForShow();
  },
  watch: {
    page() {
      this.slicePostsForShow();
    },
  },
  methods: {
    slicePostsForShow() {
      this.postsForShow = sliceContentsForShow(
        this.posts,
        this.page,
        this.rows
      );
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
