<template>
  <v-container>
    <v-row>
      <v-col md="4" offset-md="2">
        <div class="text-h4 font-weight-black text-left">{{ band.name }}</div>
        <template v-if="isAuthenticatedBand && !isMyPage">
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
        <v-img :src="band.image" />
      </v-col>
      <v-col md="4">
        <v-card class="mt-10" width="570" height="430">
          <v-card-title>Profile</v-card-title>
          <v-card-text class="profile">{{ band.profile }}</v-card-text>
          <v-divider />
          <v-card-actions>
            <router-link :to="`/bands/${id}/posts`">Posts</router-link>
          </v-card-actions>
        </v-card>
      </v-col>
      <v-col md="4" offset-md="2" v-if="isMyPage">
        <router-link to="/liked_posts">お気に入り</router-link>
        <router-link :to="`/bands/${id}/friendships`">Friends</router-link>
        <router-link :to="`/bands/${id}/chats`">Chat</router-link>
        <router-link :to="`/bands/${id}/tickets`">Tickets</router-link>
        <router-link :to="`/bands/${id}/edit`">編集する</router-link>
        <button @click="deleteBand">退会する</button>
      </v-col>
    </v-row>
    <v-row>
      <v-col md="8" offset-md="2">
        <v-card>
          <v-card-title>LIVEスケジュール</v-card-title>
          <v-card-text v-if="band.performing_events">
            <div v-for="(event, index) in band.performing_events" :key="index">
              <router-link :to="`/events/${event.id}`"
                >{{ event.open_at }}: {{ event.name }}</router-link
              >
            </div>
          </v-card-text>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
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
  created() {
    this.fetchData();
  },
  computed: {
    isAuthenticatedBand() {
      return this.$store.getters.userType === "band";
    },
    isMyPage() {
      if (this.isAuthenticatedBand) {
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
  watch: {
    $route() {
      this.fetchData();
    },
  },
  methods: {
    async fetchData() {
      let headers = null;
      if (this.$store.getters.authData) {
        headers = { headers: this.$store.getters.token };
      }
      const res = await this.$axios.get(`/bands/${this.id}`, headers);
      this.band = res.data;
      this.friendStatus = res.data.friend_status;
    },
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

<style>
.profile {
  height: 300px;
}
</style>
