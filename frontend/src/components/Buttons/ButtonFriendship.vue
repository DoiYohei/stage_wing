<template>
  <v-btn
    @click="changeFriendship"
    :color="isFollowing ? 'grey lighten-2' : 'grey darken-2'"
    :outlined="isFollowing"
    small
  >
    {{ btnText }}
  </v-btn>
</template>

<script>
export default {
  props: {
    friendStatus: {
      type: String,
      default: null,
    },
    bandId: {
      type: Number,
      require: true,
    },
    index: {
      type: Number,
      default: null,
    },
  },
  computed: {
    isFollowing() {
      return this.friendStatus === "friend" || this.friendStatus == "inviting";
    },
    btnText() {
      if (this.friendStatus === "friend") {
        return "Friend";
      } else if (this.friendStatus === "inviting") {
        return "Friend申請中";
      } else if (this.friendStatus === "invited") {
        return "承認する";
      } else return "Friend申請する";
    },
  },
  methods: {
    changeFriendship() {
      const formData = new FormData();
      formData.append("followed_id", this.bandId);
      this.$emit("change-friendship", this.isFollowing, formData, this.index);
    },
  },
};
</script>
