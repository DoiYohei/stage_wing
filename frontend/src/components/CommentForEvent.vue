<template>
  <v-container>
    <v-row>
      <v-col>
        <v-col>
          @{{ comment.commenter.name }}
          {{ comment.content }}
          <v-btn elevation="4" v-if="isCommentOwner" @click="deleteComment"
            >削除する
          </v-btn>
        </v-col>
        <v-col md="4" offset-md="4">
          <v-textarea v-model="newComment" label="コメント" outlined />
          <v-btn elevation="4" @click="replyComment">返信する</v-btn>
        </v-col>
        <template v-if="hasReplies">
          <v-col
            offset-md="1"
            v-for="reply of repliesToComment"
            :key="reply.id"
          >
            <comment-for-event :comment="reply" />
          </v-col>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CommentForEvent from "@/components/CommentForEvent";

export default {
  name: "CommentForEvent",
  components: {
    CommentForEvent,
  },
  props: {
    comment: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      bands: null,
      audiences: null,
      newComment: "",
    };
  },
  computed: {
    isCommentOwner() {
      if (this.$store.getters.userType === "band") {
        return this.$store.getters.currentUserId === this.comment.commenter.id;
      } else if (this.$store.getters.userType === "audience") {
        return this.$store.getters.currentUserId === this.comment.commenter.id;
      } else {
        return false;
      }
    },
    repliesToComment() {
      return this.$store.getters.eventData.comments.filter(
        (el) => el.parent_id === this.comment.id
      );
    },
    hasReplies() {
      return this.$store.getters.eventData.comments.some(
        (el) => el.parent_id === this.comment.id
      );
    },
  },
  methods: {
    async deleteComment() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(
        `/events/${this.$store.getters.eventData.id}/comments/${this.comment.id}`,
        token
      );
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
    async replyComment() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("comment[event_id]", this.$store.getters.eventData.id);
      formData.append("comment[parent_id]", this.comment.id);
      formData.append("comment[content]", this.newComment);
      await this.$axios.post(
        `/events/${this.$store.getters.eventData.id}/comments`,
        formData,
        token
      );
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
  },
};
</script>
