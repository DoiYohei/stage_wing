<template>
  <v-container :fluid="$vuetify.breakpoint.lg">
    <v-row v-if="$vuetify.breakpoint.mdAndDown">
      <v-col>
        <v-tabs v-model="tabs" background-color="grey darken-3" fixed-tabs>
          <template v-for="(friendship, index) in friendships">
            <v-divider :key="index" v-if="index !== 0" vertical />
            <v-tab :key="friendship.header">
              {{ friendship.header }}
            </v-tab>
          </template>
        </v-tabs>
        <v-tabs-items v-model="tabs">
          <v-tab-item>
            <ListFriendships
              :bands="friends"
              :friendship="friendships[0]"
              @change-friendship="changeFriendship"
              @start-chat="startChat"
            />
          </v-tab-item>
          <v-tab-item>
            <ListFriendships
              :bands="invitings"
              :friendship="friendships[1]"
              @change-friendship="changeFriendship"
            />
          </v-tab-item>
          <v-tab-item>
            <ListFriendships
              :bands="inviters"
              :friendship="friendships[2]"
              @change-friendship="changeFriendship"
              @start-chat="startChat"
            />
          </v-tab-item>
        </v-tabs-items>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.lgAndUp" :dense="$vuetify.breakpoint.lg">
      <ListFriendships
        :bands="friends"
        :friendship="friendships[0]"
        @change-friendship="changeFriendship"
        @start-chat="startChat"
      />
      <ListFriendships
        :bands="invitings"
        :friendship="friendships[1]"
        @change-friendship="changeFriendship"
      />
      <ListFriendships
        :bands="inviters"
        :friendship="friendships[2]"
        @change-friendship="changeFriendship"
        @start-chat="startChat"
      />
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import ListFriendships from "@/components/ListFriendships";

export default {
  components: {
    ListFriendships,
  },
  props: ["id"],
  data() {
    return {
      tabs: 0,
      friends: [],
      invitings: [],
      inviters: [],
      friendships: [
        {
          header: "Friend",
          status: "friend",
          oppositeStatus: "invited",
        },
        {
          header: "Friend申請中",
          status: "inviting",
          oppositeStatus: "",
        },
        {
          header: "Friend申請されている",
          status: "invited",
          oppositeStatus: "friend",
        },
      ],
    };
  },
  async created() {
    const res = await this.$axios.get(
      `/bands/${this.id}/friendships`,
      this.headers
    );
    this.friends = res.data.friends;
    this.invitings = res.data.inviting;
    this.inviters = res.data.inviters;
  },
  computed: {
    ...mapGetters(["headers", "token"]),
  },
  methods: {
    changeFriendship(isFollowing, formData) {
      if (isFollowing) {
        this.$axios.delete("/friendships", {
          headers: this.token,
          data: formData,
        });
      } else {
        this.$axios.post("/friendships", formData, this.headers);
      }
    },
    async startChat(bandId) {
      const res = await this.$axios.get("/rooms", this.headers);
      const room = res.data.find((data) => data.friend_id === bandId);
      let roomId = room.id;
      if (!roomId) {
        const formData = new FormData();
        formData.append("band_room[band_id]", bandId);
        const res = await this.$axios.post("/rooms", formData, this.headers);
        roomId = res.data;
      }
      this.$router.push({
        path: `/bands/${this.id}/chats/${roomId}`,
        query: { partnerId: bandId },
      });
    },
  },
};
</script>
