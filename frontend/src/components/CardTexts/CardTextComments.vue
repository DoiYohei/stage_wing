<template>
  <span>
    <v-avatar size="24">
      <v-img :src="comment.commenter.image.url" />
    </v-avatar>
    <router-link
      :to="`/bands/${comment.commenter.id}`"
      v-if="comment.commenter.user_type === 'bands'"
    >
      {{ comment.commenter.name }}
    </router-link>
    <span v-if="comment.commenter.user_type !== 'bands'">
      {{ comment.commenter.name }}
    </span>
    <span>
      {{ $dayjs(comment.created_at).format("YYYY MMM DD") }}
      {{ comment.content }}
    </span>
    <v-dialog v-model="dialog" width="45vw">
      <template #activator="{ on, attrs }">
        <v-btn
          v-if="isCommentOwner(comment.commenter)"
          v-on="on"
          v-bind="attrs"
          icon
        >
          <v-icon>mdi-trash-can-outline</v-icon>
        </v-btn>
      </template>
      <CardDialog
        dialogText="このコメントを削除しますか？"
        :selectExcution="orderDelete"
        :select-cancel="closeDialog"
      />
    </v-dialog>
  </span>
</template>

<script>
import { mapGetters } from "vuex";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  name: "CardTextComments",
  props: {
    comment: {
      type: Object,
      required: true,
    },
    deliveryDelete: {
      type: Function,
      required: true,
    },
  },
  data() {
    return {
      dialog: false,
    };
  },
  components: {
    CardDialog,
  },
  computed: {
    ...mapGetters(["userType", "userId"]),
    isCommentOwner() {
      return (commenter) => {
        const isSameUserType = this.userType === commenter.user_type;
        isSameUserType ? this.userId === commenter.id : false;
      };
    },
  },
  methods: {
    orderDelete() {
      this.deliveryDelete(this.comment.id);
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
