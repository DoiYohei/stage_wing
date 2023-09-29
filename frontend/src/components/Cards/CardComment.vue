<template>
  <v-card flat class="d-flex align-center flex-wrap">
    <CardAvatar
      :avatar="comment.commenter"
      max-width="175"
      :userType="comment.commenter.user_type"
      class="my-2"
    />
    <v-card flat>
      <v-card-text class="grey--text text--lighten-2 py-0 pr-0">
        {{ comment.content }}
      </v-card-text>
    </v-card>
    <v-card flat class="d-flex align-center">
      <v-card-subtitle class="grey--text py-0">
        - {{ $dayjs(comment.created_at).format("YYYY MMM DD") }}
      </v-card-subtitle>
      <v-card-actions v-if="isCommentOwner" data-jest="trash-btn" class="py-0">
        <v-btn @click.stop="dialog = true" icon small>
          <v-icon>mdi-trash-can-outline</v-icon>
        </v-btn>
      </v-card-actions>
      <DialogYesNo
        v-model="dialog"
        question="このコメントを削除しますか？"
        @select-excution="deleteComment"
        @close-dialog="closeDialog"
      />
      <slot />
    </v-card>
  </v-card>
</template>

<script>
import CardAvatar from "@/components/Cards/CardAvatar";
import DialogYesNo from "@/components/Dialogs/DialogYesNo";
import { mapGetters } from "vuex";
import { audienceImage, bandImage } from "@/utils/images";

export default {
  components: {
    DialogYesNo,
    CardAvatar,
  },
  props: {
    comment: {
      type: Object,
      required: true,
    },
  },
  data() {
    return {
      dialog: false,
    };
  },
  computed: {
    ...mapGetters(["userType", "userId"]),
    isCommentOwner() {
      const isSameUserType = this.userType === this.comment.commenter.user_type;
      return isSameUserType ? this.userId === this.comment.commenter.id : false;
    },
    commenterImage() {
      const image = this.comment.commenter.image.url;
      return this.comment.commenter.user_type === "bands"
        ? bandImage(image)
        : audienceImage(image);
    },
  },
  methods: {
    deleteComment() {
      this.$emit("delete-comment", this.comment.id);
      this.closeDialog();
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
