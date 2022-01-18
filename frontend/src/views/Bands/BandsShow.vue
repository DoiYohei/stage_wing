<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card>
          <v-col class="d-flex justify-md-start flex-wrap">
            <v-col md="7" sm="12">
              <v-img :src="band.image.url" v-if="band.image" />
            </v-col>
            <v-col class="text-left pb-0">
              <v-card outlined>
                <v-tabs v-model="tabs" fixed-tabs>
                  <v-tab>Profile</v-tab>
                  <v-divider vertical />
                  <v-tab>Posts</v-tab>
                  <v-divider vertical />
                  <v-tab>Schedule</v-tab>
                </v-tabs>
              </v-card>
              <v-tabs-items v-model="tabs" class="my-5">
                <v-tab-item>
                  <div class="d-flex">
                    <v-card-title v-text="band.name" />
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
                              <v-list-item to="/liked_posts">
                                お気に入り
                              </v-list-item>
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
                                <template v-slot:activator="{ on, attrs }">
                                  <v-list-item v-bind="attrs" v-on="on">
                                    退会する
                                  </v-list-item>
                                </template>
                                <CardDialog
                                  dialogText="退会しますか？"
                                  :select-excution="deleteBand"
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
                  </div>
                  <v-card-text v-text="band.profile" class="profile-content" />
                  <v-card-actions>
                    <v-btn icon :href="band.website">
                      <v-icon>mdi-link-variant</v-icon>
                    </v-btn>
                    <v-btn icon :href="band.twitter">
                      <v-icon>mdi-twitter</v-icon>
                    </v-btn>
                  </v-card-actions>
                </v-tab-item>
                <v-tab-item>
                  <v-card-actions>
                    <router-link :to="`/bands/${id}/posts`">
                      投稿一覧
                    </router-link>
                  </v-card-actions>
                </v-tab-item>
                <v-tab-item>
                  <v-card class="text-right">
                    <template v-for="(event, index) in band.performing_events">
                      <v-card-text :key="index">
                        <router-link :to="`/events/${event.id}`">
                          {{ $dayjs(event.open_at).format("YYYY MMM DD") }}
                          {{ event.name }}
                          @{{ event.place }}
                        </router-link>
                      </v-card-text>
                    </template>
                  </v-card>
                </v-tab-item>
              </v-tabs-items>
            </v-col>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardDialog from "@/components/Cards/CardDialog";

export default {
  components: {
    CardDialog,
  },
  props: ["id"],
  data() {
    return {
      band: {},
      friendStatus: null,
      tabs: 0,
      dialog: 0,
    };
  },
  created() {
    this.fetchBand();
  },
  computed: {
    ...mapGetters(["userType", "currentUserId", "headers"]),
    isAuthenticatedBand() {
      return this.userType === "band";
    },
    isMyPage() {
      if (this.isAuthenticatedBand) {
        return this.currentUserId === this.band.id;
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
      this.fetchBand();
    },
  },
  methods: {
    async fetchBand() {
      const res = await this.$axios.get(`/bands/${this.id}`, this.headers);
      this.band = res.data;
      this.friendStatus = res.data.friend_status;
    },
    async deleteBand() {
      this.$store.dispatch("deleteBand", this.headers);
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

<style>
.profile-content {
  white-space: pre-wrap;
}
</style>
