<template>
  <v-card class="py-3">
    <v-card flat>
      <v-card-text class="py-0">
        <CardTextComments
          :comment="comment"
          :delivery-delete="deliveryDelete"
        />
        <v-btn icon @click="show = !show">
          <v-icon small>
            {{ show ? "mdi-chevron-up" : "mdi-chevron-down" }}
          </v-icon>
        </v-btn>
      </v-card-text>
    </v-card>
    <v-expand-transition>
      <div v-show="show">
        <template v-if="comment.replies.length">
          <v-col v-for="reply of comment.replies" :key="reply.id" class="py-0">
            <v-card flat>
              <v-card-text class="py-0">
                <CardTextComments
                  :comment="reply"
                  :delivery-delete="deliveryDelete"
                />
              </v-card-text>
            </v-card>
          </v-col>
        </template>
        <v-col class="py-0">
          <v-card-text v-show="show" class="text-right">
            <v-textarea
              v-model="newReply"
              class="mb-3"
              label="返信コメント"
              row-height="6"
              auto-grow
              hide-details
              outlined
            />
            <v-btn elevation="4" @click="replyComment">返信する</v-btn>
          </v-card-text>
        </v-col>
      </div>
    </v-expand-transition>
  </v-card>
</template>

<script>
import CardTextComments from "@/components/CardTexts/CardTextComments";

export default {
  name: "CardComments",
  components: {
    CardTextComments,
  },
  props: {
    comment: {
      type: Object,
      required: true,
    },
    postComment: {
      type: Function,
      required: true,
    },
    deleteComment: {
      type: Function,
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
      this.postComment(this.newReply, this.comment.id);
    },
    deliveryDelete(commentId) {
      this.deleteComment(commentId);
    },
  },
};
</script>
