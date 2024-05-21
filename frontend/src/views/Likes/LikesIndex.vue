<template>
  <v-container>
    <CardPageTitle title="お気に入り" />
    <v-row>
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
          <PaginationBlocks v-model="page" :contents="allPosts" :rows="rows" />
        </v-col>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import CardPost from "@/components/Cards/CardPost";
import PaginationBlocks from "@/components/PaginationBlocks";
import { mapGetters } from "vuex";
import { goHome } from "@/utils/routers";
import { sliceContentsForShow } from "@/utils/pagination";
import { deletePost, patchPost } from "@/utils/posts";
import { changeLike } from "@/utils/likes";

export default {
  components: {
    CardPageTitle,
    CardPost,
    PaginationBlocks,
  },
  data() {
    return {
      allPosts: [],
      postsForShow: [],
      page: 1,
      rows: 5,
    };
  },
  async created() {
    try {
      const res = await this.$axios.get("/likes", this.headers);
      this.allPosts = res.data;
      this.slicePostsForShow();
    } catch (error) {
      goHome();
    }
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  watch: {
    page() {
      this.slicePostsForShow();
    },
  },
  methods: {
    slicePostsForShow() {
      this.postsForShow = sliceContentsForShow(
        this.allPosts,
        this.page,
        this.rows
      );
    },
    deletePost(postId) {
      deletePost(postId);
    },
    patchPost(postId, postDescription) {
      patchPost(postId, postDescription);
    },
    changeLike(post) {
      changeLike(post);
    },
  },
};
</script>
