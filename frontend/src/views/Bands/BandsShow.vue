<template>
  <div>
    <router-link :to="`/bands/${id}/posts`">Posts</router-link>
    <div>{{ band.name }}</div>
    <div v-if="band.profile">
      <iframe :src="band.profile"></iframe>
    </div>
    <img :src="band.image" />
    <template v-if="isAuthenticated && !isMyPage">
      <p v-if="isInvited">Friend申請されています</p>
      <v-btn
        color="primary"
        elevation="2"
        :outlined="isFollowing"
        @click="changeFriendship"
      >
        {{ friendDisplay }}
      </v-btn>
    </template>
    <template v-if="isMyPage">
      <router-link :to="`/bands/${id}/friendships`">Friends</router-link>
      <router-link :to="`/bands/${id}/chats`">Chat</router-link>
      <router-link :to="`/bands/${id}/edit`">編集する</router-link>
      <button @click="deleteBand">退会する</button>
    </template>
    <div>LIVEスケジュール</div>
    <template v-if="band.performing_events">
      <div v-for="(event, index) in band.performing_events" :key="index">
        <router-link :to="`/events/${event.id}`"
          >{{ event.open_at }}: {{ event.name }}</router-link
        >
      </div>
    </template>
  </div>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      band: {},
      friendStatus: null,
    };
  },
  async created() {
    let headers = null;
    if (this.$store.getters.authData) {
      headers = { headers: this.$store.getters.token };
    }
    const res = await this.$axios.get(`/bands/${this.id}`, headers);
    this.band = res.data;
    this.friendStatus = res.data.friend_status;
  },
  computed: {
    isAuthenticated() {
      return this.$store.getters.authData !== null;
    },
    isMyPage() {
      if (this.$store.getters.authData) {
        return this.$store.getters.currentUserId === this.band.id;
      } else {
        return false;
      }
    },
    isFollowing() {
      return this.friendStatus === "friend" || this.friendStatus == "inviting";
    },
    isFriend() {
      return this.friendStatus === "friend";
    },
    isInviting() {
      return this.friendStatus === "inviting";
    },
    isInvited() {
      return this.friendStatus === "invited";
    },
    friendDisplay() {
      if (this.isFriend) return "Friendです";
      if (this.isInviting) return "Friend申請中";
      if (this.isInvited) return "Friend承認する";
      return "Friend申請する";
    },
  },
  methods: {
    async deleteBand() {
      const token = { headers: this.$store.getters.token };
      this.$store.dispatch("deleteBand", token);
    },
    changeFriendship() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("followed_id", this.id);
      if (this.isFollowing) {
        this.$axios.delete("/friendships", token, formData);
        if (this.friendStatus === "friend") {
          this.friendStatus = "invited";
          return;
        }
        if (this.friendStatus === "inviting") {
          this.friendStatus = "";
          return;
        }
      }
      this.$axios.post("/friendships", formData, token);
      if (this.friendStatus === "invited") {
        this.friendStatus = "friend";
        return;
      }
      this.friendStatus = "inviting";
    },
  },
};
</script>
