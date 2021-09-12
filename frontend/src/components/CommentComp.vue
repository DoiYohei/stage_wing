<template>
  <v-container>
    <v-row>
      <v-col>
        <v-col>
          @{{ commenterName }}
          {{ comment.content }}
          <v-btn elevation="4" v-if="isCommentOwner" @click="deleteComment"
            >削除する
          </v-btn>
        </v-col>
        <v-col md="4" offset-md="4">
          <v-textarea v-model="newComment" label="コメント" outlined />
          <v-btn elevation="4" @click="postComment">返信する</v-btn>
        </v-col>
        <template v-if="hasReplies">
          <v-col
            offset-md="1"
            v-for="reply of repliesToComment"
            :key="reply.id"
          >
            <comment-comp
              :eventId="eventId"
              :bands="bands"
              :comment="reply"
              :comments="comments"
            />
          </v-col>
        </template>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CommentComp from "@/components/CommentComp";

export default {
  name: "comment-comp",
  components: {
    CommentComp,
  },
  props: {
    eventId: {
      type: Number,
      required: true,
    },
    bands: {
      type: Array,
      required: true,
    },
    comment: {
      type: Object,
      required: true,
    },
    comments: {
      type: Array,
      required: true,
    },
  },
  data() {
    return {
      newComment: "",
    };
  },
  computed: {
    commenterName() {
      const commenter = this.bands.filter(
        (band) => band.id === this.comment.band_id
      );
      return commenter[0].name;
    },
    isCommentOwner() {
      return this.$store.getters.currentUserId === this.comment.band_id;
    },
    repliesToComment() {
      return this.comments.filter((el) => el.parent_id === this.comment.id);
    },
    hasReplies() {
      return this.comments.some((el) => el.parent_id === this.comment.id);
    },
  },
  methods: {
    async deleteComment() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(
        `/events/${this.eventId}/comments/${this.comment.id}`,
        token
      );
    },
    async postComment() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("comment[event_id]", this.eventId);
      formData.append("comment[parent_id]", this.comment.id);
      formData.append("comment[content]", this.newComment);
      await this.$axios.post(
        `/events/${this.eventId}/comments`,
        formData,
        token
      );
    },
  },
};
</script>
