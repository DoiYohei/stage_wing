<template>
  <v-card flat class="d-flex align-center flex-wrap">
    <CardAvatar :avatar="comment.commenter" class="my-2" />
    <v-card flat>
      <v-card-text class="grey--text text--lighten-2 py-0 pr-0">
        {{ comment.content }}
      </v-card-text>
    </v-card>
    <v-card flat class="d-flex align-center">
      <v-card-subtitle class="grey--text py-0">
        - {{ $dayjs(comment.created_at).format("YYYY MMM DD") }}
      </v-card-subtitle>
      <v-dialog v-model="dialog" width="360">
        <template #activator="{ on, attrs }">
          <v-card-actions class="py-0">
            <v-btn v-if="isCommentOwner" v-on="on" v-bind="attrs" icon small>
              <v-icon>mdi-trash-can-outline</v-icon>
            </v-btn>
          </v-card-actions>
        </template>
        <CardDialog
          dialogText="このコメントを削除しますか？"
          @select-excution="deleteComment"
          @close-dialog="closeDialog"
        />
      </v-dialog>
      <slot />
    </v-card>
  </v-card>
</template>

<script>
import { mapGetters } from "vuex";
import CardAvatar from "@/components/Cards/CardAvatar";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  components: {
    CardDialog,
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
    commenterIsBand() {
      return this.comment.commenter.user_type === "bands";
    },
    commenterImage() {
      const image = this.comment.commenter.image.url;
      if (image) {
        return image;
      } else {
        return this.commenterIsBand
          ? require("@/assets/img/no-band-img.jpg")
          : require("@/assets/img/no-audience-img.jpeg");
      }
    },
  },
  methods: {
    deleteComment() {
      this.$emit("delete-comment", this.comment.id);
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
