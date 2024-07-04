<template>
  <span>
    <v-btn
      @click.stop="dialog = true"
      :color="friendship.isFollowing ? 'grey lighten-2' : 'grey darken-2'"
      :outlined="friendship.isFollowing"
      small
      data-jest="state-btn"
      class="mx-2 my-1 px-2"
    >
      {{ friendship.btn }}
    </v-btn>
    <v-dialog
      v-model="dialog"
      width="380"
      overlay-color="white"
      overlay-opacity="0.2"
    >
      <v-card>
        <v-card-title>
          <CardAvatar :avatar="band" size="50" userType="bands" />
        </v-card-title>
        <v-divider />
        <v-card-text data-jest="state-text" class="pt-6 pb-2 reflect-return">{{
          friendship.description
        }}</v-card-text>
        <v-card-actions>
          <v-spacer />
          <v-btn
            @click="changeFriendState"
            color="grey darken-3"
            block
            data-jest="action-btn"
            >{{ friendship.action }}</v-btn
          >
          <v-spacer />
        </v-card-actions>
        <v-card-actions class="pb-6">
          <v-spacer />
          <v-btn @click="dialog = false" color="grey darken-3" block
            >キャンセル
          </v-btn>
          <v-spacer />
        </v-card-actions>
      </v-card>
    </v-dialog>
  </span>
</template>

<script>
import CardAvatar from "@/components/Cards/CardAvatar";

export default {
  components: {
    CardAvatar,
  },
  props: {
    band: {
      type: Object,
      require: true,
    },
    friendState: {
      type: String,
      default: null,
    },
    index: {
      type: Number,
      default: null,
    },
  },
  data() {
    return {
      dialog: false,
    };
  },
  computed: {
    friendship() {
      if (this.friendState === "friend") {
        return {
          action: "FRIENDを解除する",
          btn: "FRIEND",
          description:
            "FRIENDです。\nFRIENDを解除するとチャットができなくなります。\nまた、チャット履歴も削除されます。",
          opposition: "invited",
          isFollowing: true,
        };
      } else if (this.friendState === "inviting") {
        return {
          action: "申請を解除する",
          btn: "REQUESTING",
          description:
            "FRIEND申請中です。\n承認されるとチャットができるようになります。",
          opposition: null,
          isFollowing: true,
        };
      } else if (this.friendState === "invited") {
        return {
          action: "承認する",
          btn: "REQUESTED",
          description:
            "FRIEND申請を受けています。\n承認するとチャットができるようになります。",
          opposition: "friend",
          isFollowing: false,
        };
      } else
        return {
          action: "FRIEND申請する",
          btn: "NOT FRIEND",
          description:
            "FRIENDではありません。\nFRIENDになるとチャットができるようになります。",
          opposition: "inviting",
          isFollowing: false,
        };
    },
  },
  methods: {
    changeFriendState() {
      this.$emit("change-friend-state", this.band, this.friendship, this.index);
      this.dialog = false;
    },
  },
};
</script>
