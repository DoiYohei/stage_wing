<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card flat class="d-flex justify-space-between flex-wrap">
          <v-card flat class="d-flex">
            <v-card-title>{{ band.name }}</v-card-title>
            <v-card-actions v-if="isMyPage">
              <v-menu>
                <template v-slot:activator="{ on, attrs }">
                  <v-btn icon v-bind="attrs" v-on="on">
                    <v-icon>mdi-dots-horizontal</v-icon>
                  </v-btn>
                </template>
                <v-card-text class="pa-0">
                  <v-list>
                    <v-list-item-group>
                      <v-list-item :to="`/bands/${this.id}/posts/new`">
                        新規Posts作成
                      </v-list-item>
                      <v-list-item to="/liked_posts">お気に入り</v-list-item>
                      <v-list-item :to="`/bands/${id}/friendships`">
                        Friends
                      </v-list-item>
                      <v-list-item :to="`/bands/${id}/chats`">
                        Chat
                      </v-list-item>
                      <v-list-item :to="`/bands/${id}/tickets`">
                        Tickets
                      </v-list-item>
                      <v-list-item :to="`/bands/${id}/edit`">
                        Profileを編集する
                      </v-list-item>
                      <v-dialog v-model="dialog" width="45vw">
                        <template #activator="{ on, attrs }">
                          <v-list-item v-bind="attrs" v-on="on">
                            退会する
                          </v-list-item>
                        </template>
                        <CardDialog
                          dialog-text="退会しますか？"
                          :select-excution="deleteAccount"
                          :select-cancel="closeDialog"
                        />
                      </v-dialog>
                    </v-list-item-group>
                  </v-list>
                </v-card-text>
              </v-menu>
            </v-card-actions>
            <v-card-actions v-if="isAuthenticatedBand && !isMyPage">
              <v-card-text v-if="isInvited">
                Friend申請されています
              </v-card-text>
              <v-btn
                color="primary"
                elevation="2"
                :outlined="isFollowing"
                @click="changeFriendship"
              >
                {{ friendDisplay }}
              </v-btn>
            </v-card-actions>
          </v-card>
          <v-card-actions>
            <v-tabs v-if="$vuetify.breakpoint.mdAndUp" v-model="tabs" grow>
              <v-tab :to="`/bands/${id}`" exact>Biography</v-tab>
              <v-tab :to="`/bands/${id}/posts`">Post</v-tab>
              <v-tab :to="`/bands/${id}/events`">Live</v-tab>
            </v-tabs>
            <v-menu v-if="$vuetify.breakpoint.smAndDown">
              <template #activator="{ on, attrs }">
                <v-btn icon v-bind="attrs" v-on="on">
                  <v-app-bar-nav-icon />
                </v-btn>
              </template>
              <v-list>
                <v-list-item :to="`/bands/${id}`" exact>
                  <v-list-item-title>Biography</v-list-item-title>
                </v-list-item>
                <v-list-item :to="`/bands/${id}/posts`">
                  <v-list-item-title>Post</v-list-item-title>
                </v-list-item>
                <v-list-item :to="`/bands/${id}/events`">
                  <v-list-item-title>Live</v-list-item-title>
                </v-list-item>
              </v-list>
            </v-menu>
          </v-card-actions>
        </v-card>
        <v-divider />
        <CardBandProfiles v-if="isProfileTab" :band="band" />
        <router-view v-if="!isProfileTab" />
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapActions, mapGetters } from "vuex";
import CardBandProfiles from "@/components/Cards/CardBandProfiles";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  components: {
    CardBandProfiles,
    CardDialog,
  },
  props: ["id"],
  data() {
    return {
      band: {},
      friendStatus: null,
      tabs: "",
      dialog: false,
    };
  },
  created() {
    this.fetchBand();
  },
  watch: {
    $route(to, from) {
      if (to.params.id !== from.params.id) {
        this.fetchBand();
      }
    },
  },
  computed: {
    ...mapGetters(["isAuthenticatedBand", "userId", "headers"]),
    isProfileTab() {
      return this.$route.path === `/bands/${this.id}`;
    },
    isMyPage() {
      if (this.isAuthenticatedBand) {
        return this.userId === this.band.id;
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
      if (this.isFriend) return "Friend";
      if (this.isInviting) return "Pending";
      if (this.isInvited) return "Accept";
      return "Friend Request";
    },
  },
  methods: {
    ...mapActions(["deleteAccount"]),
    async fetchBand() {
      const res = await this.$axios.get(`/bands/${this.id}`, this.headers);
      this.band = res.data;
      this.friendStatus = res.data.friend_status;
    },
    changeFriendship() {
      const formData = new FormData();
      formData.append("followed_id", this.id);
      if (this.isFollowing) {
        this.$axios.delete("/friendships", this.headers, formData);
        if (this.friendStatus === "friend") {
          this.friendStatus = "invited";
          return;
        }
        if (this.friendStatus === "inviting") {
          this.friendStatus = "";
          return;
        }
      }
      this.$axios.post("/friendships", formData, this.headers);
      if (this.friendStatus === "invited") {
        this.friendStatus = "friend";
        return;
      }
      this.friendStatus = "inviting";
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
