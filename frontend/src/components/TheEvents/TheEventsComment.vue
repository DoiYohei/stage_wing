<template>
  <v-col>
    <v-card flat>
      <CardComment :comment="comment" @delete-comment="deleteComment">
        <v-card flat>
          <v-card-actions class="py-0">
            <v-btn icon small @click="show = !show">
              <v-icon small>
                {{ show ? "mdi-chevron-up" : "mdi-chevron-down" }}
              </v-icon>
            </v-btn>
          </v-card-actions>
        </v-card>
      </CardComment>
      <v-expand-transition>
        <div v-show="show" tile class="ml-2 reply-comment">
          <template v-if="comment.replies.length">
            <v-col
              v-for="reply of comment.replies"
              :key="reply.id"
              data-jest="reply"
              class="py-0"
            >
              <CardComment :comment="reply" @delete-comment="deleteComment" />
            </v-col>
          </template>
          <v-col class="py-0">
            <FormComment
              v-model="newReply"
              btn-text="返信"
              label="返信コメント"
              @submit-form="replyComment"
              class="px-0 pb-0"
            />
          </v-col>
        </div>
      </v-expand-transition>
    </v-card>
  </v-col>
</template>

<script>
import CardComment from "@/components/Cards/CardComment";
import FormComment from "@/components/Forms/FormComment";

export default {
  components: {
    CardComment,
    FormComment,
  },
  props: {
    comment: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      newReply: "",
      show: false,
    };
  },
  methods: {
    replyComment() {
      this.$emit("post-comment", this.newReply, this.comment.id);
    },
    deleteComment(commentId) {
      this.$emit("delete-comment", commentId);
    },
  },
};
</script>
