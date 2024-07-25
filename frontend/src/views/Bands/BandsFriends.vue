<template>
  <v-container :fluid="$vuetify.breakpoint.lg">
    <v-row v-if="$vuetify.breakpoint.xs">
      <v-col cols="12">
        <v-window v-model="tab">
          <v-window-item>
            <CardFriendship
              v-model="tab"
              :bands="friends"
              :states="statesOfFriends"
              :title="titles[0]"
              @change-friend-state="changeFriendState"
              @start-chat="startChat"
            />
          </v-window-item>
          <v-window-item>
            <CardFriendship
              v-model="tab"
              :bands="invitees"
              :states="statesOfInvitees"
              :title="titles[1]"
              @change-friend-state="changeFriendState"
            />
          </v-window-item>
          <v-window-item>
            <CardFriendship
              v-model="tab"
              :bands="inviters"
              :states="statesOfInviters"
              :title="titles[2]"
              @change-friend-state="changeFriendState"
              @start-chat="startChat"
            />
          </v-window-item>
        </v-window>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.md || $vuetify.breakpoint.sm">
      <v-col offset-sm="1" sm="10">
        <v-tabs
          v-model="tab"
          active-class="grey darken-1"
          background-color="grey darken-3"
          fixed-tabs
        >
          <template v-for="(title, index) in titles">
            <v-divider :key="index" v-if="index !== 0" vertical />
            <v-tab :key="title">{{ title }}</v-tab>
          </template>
        </v-tabs>
        <v-tabs-items v-model="tab">
          <v-tab-item>
            <CardFriendship
              :bands="friends"
              :states="statesOfFriends"
              @change-friend-state="changeFriendState"
              @start-chat="startChat"
            />
          </v-tab-item>
          <v-tab-item>
            <CardFriendship
              :bands="invitees"
              :states="statesOfInvitees"
              @change-friend-state="changeFriendState"
            />
          </v-tab-item>
          <v-tab-item>
            <CardFriendship
              :bands="inviters"
              :states="statesOfInviters"
              @change-friend-state="changeFriendState"
              @start-chat="startChat"
            />
          </v-tab-item>
        </v-tabs-items>
      </v-col>
    </v-row>
    <v-row v-if="$vuetify.breakpoint.lgAndUp" :dense="$vuetify.breakpoint.lg">
      <v-col cols="4">
        <CardFriendship
          :bands="friends"
          :states="statesOfFriends"
          :title="titles[0]"
          @change-friend-state="changeFriendState"
          @start-chat="startChat"
        />
      </v-col>
      <v-col cols="4">
        <CardFriendship
          :bands="invitees"
          :states="statesOfInvitees"
          :title="titles[1]"
          @change-friend-state="changeFriendState"
        />
      </v-col>
      <v-col cols="4">
        <CardFriendship
          :bands="inviters"
          :states="statesOfInviters"
          :title="titles[2]"
          @change-friend-state="changeFriendState"
          @start-chat="startChat"
        />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CardFriendship from "@/components/Cards/CardFriendship";
import { mapGetters, mapActions } from "vuex";
import { goHome } from "@/utils/routers";
import { fetchRooms, findPartnerRoom, goToChatShow } from "@/utils/chats";
import { changeFriendship } from "@/utils/friendships";

export default {
  components: {
    CardFriendship,
  },
  props: ["id"],
  data() {
    return {
      tab: 0,
      friends: [],
      invitees: [],
      inviters: [],
      statesOfFriends: [], // 現在値
      statesOfInvitees: [], // 現在値
      statesOfInviters: [], // 現在値
      titles: ["FRIEND", "FRIEND申請中", "FRIEND申請されている"],
    };
  },
  async created() {
    if (Number(this.id) !== this.bandId) {
      return goHome();
    } else {
      try {
        const res = await this.$axios.get(
          `/bands/${this.id}/friendships`,
          this.headers
        );
        this.friends = res.data.friends;
        this.invitees = res.data.invitees;
        this.inviters = res.data.inviters;

        // 以下二点を行うために、現在のFriendshipの状態(現在値)は別で管理する。
        // 1.各ユーザー名の隣に表示するFriendshipボタンで状態を切り替えられるようにする。
        // 2.各ユーザーの表示位置は初期表示位置を維持する。
        for (let n = 0; n < this.friends.length; n++) {
          this.statesOfFriends.push("friend");
        }
        for (let n = 0; n < this.invitees.length; n++) {
          this.statesOfInvitees.push("inviting");
        }
        for (let n = 0; n < this.inviters.length; n++) {
          this.statesOfInviters.push("invited");
        }
      } catch (error) {
        goHome();
      }
    }
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
  },
  methods: {
    changeFriendState(band, friendship, index) {
      changeFriendship(band.id, friendship.isFollowing);
      if (band.friend_state === "friend") {
        this.$set(this.statesOfFriends, index, friendship.opposition);
      } else if (band.friend_state === "inviting") {
        this.$set(this.statesOfInvitees, index, friendship.opposition);
      } else if (band.friend_state === "invited") {
        this.$set(this.statesOfInviters, index, friendship.opposition);
      } else {
        this.$set(this.statesOfInvitees, index, friendship.opposition);
      }
    },
    async startChat(partnerId) {
      try {
        const res = await fetchRooms();
        const room = findPartnerRoom(res.data, partnerId);
        goToChatShow(room.id, partnerId);
      } catch (error) {
        this.showResult("チャットを開始できません。");
      }
    },
    ...mapActions(["showResult"]),
  },
};
</script>
