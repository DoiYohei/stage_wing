<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <v-row>
      <v-col>
        <v-card>
          <v-col class="d-flex flex-wrap">
            <v-col md="7" cols="12">
              <v-img :src="band.image.url" v-if="band.image" />
            </v-col>
            <v-col md="5" class="text-left pb-0">
              <v-card outlined>
                <v-tabs v-model="tabs" fixed-tabs>
                  <v-tab>Profile</v-tab>
                  <v-divider vertical />
                  <v-tab>Posts</v-tab>
                  <v-divider vertical />
                  <v-tab>Schedule</v-tab>
                </v-tabs>
              </v-card>
              <v-card max-height="700px" class="overflow-auto" flat>
                <v-tabs-items v-model="tabs" class="my-3">
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
                                <v-list-item
                                  :to="`/bands/${this.id}/posts/new`"
                                >
                                  新規Posts作成
                                </v-list-item>
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
                    <v-card-text v-text="band.profile" class="reflect-return" />
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
                    <CardPosts
                      v-for="(post, index) in displayPosts"
                      :key="index"
                      :post="post"
                      :is-my-page="isMyPage"
                      :delete-post="deletePost"
                      :patch-post="patchPost"
                      :change-like="changeLike"
                    />
                    <v-col>
                      <PaginationBlocks :mold-display="moldDisplay" />
                    </v-col>
                  </v-tab-item>
                  <v-tab-item class="text-right">
                    <v-card-text
                      v-for="(event, index) in band.performing_events"
                      :key="index"
                    >
                      <router-link :to="`/events/${event.id}`">
                        {{ $dayjs(event.open_at).format("YYYY MMM DD") }}
                        {{ event.name }}
                        @{{ event.place }}
                      </router-link>
                    </v-card-text>
                  </v-tab-item>
                </v-tabs-items>
              </v-card>
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
import CardPosts from "@/components/Cards/CardPosts";
import PaginationBlocks from "@/components/PaginationBlocks";

export default {
  components: {
    CardDialog,
    CardPosts,
    PaginationBlocks,
  },
  props: ["id"],
  data() {
    return {
      band: {},
      friendStatus: null,
      tabs: 0,
      dialog: 0,
      displayPosts: [],
    };
  },
  async created() {
    await this.fetchBand();
    this.moldDisplay();
  },
  computed: {
    ...mapGetters(["userType", "currentUserId", "headers", "token"]),
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
    async $route() {
      await this.fetchBand();
      this.moldDisplay();
    },
  },
  methods: {
    async fetchBand() {
      const res = await this.$axios.get(`/bands/${this.id}`, this.headers);
      this.band = res.data;
      this.friendStatus = res.data.friend_status;
    },
    moldDisplay() {
      this.$page.rowsPerPage = 5;
      this.$page.displayContents = this.band.posts;
      this.displayPosts = this.$page.displayContents;
    },
    async deleteBand() {
      this.$store.dispatch("deleteBand", this.headers);
      this.$router.replace("/");
    },
    async deletePost(postId) {
      await this.$axios.delete(
        `/bands/${this.id}/posts/${postId}`,
        this.headers
      );
      this.updatePage();
    },
    async patchPost(postId, postDescription) {
      const formData = new FormData();
      formData.append("post[description]", postDescription);
      await this.$axios.patch(
        `/bands/${this.id}/posts/${postId}`,
        formData,
        this.headers
      );
      this.updatePage();
    },
    changeLike(post) {
      if (!this.currentUserId) {
        return this.$router.push("/errors/auth");
      } else {
        const formData = new FormData();
        formData.append("post_id", post.id);
        if (post.favorite) {
          this.$axios.delete("/likes", {
            headers: this.token,
            data: formData,
          });
          post.favorite = false;
          post.likes_count -= 1;
        } else {
          this.$axios.post("/likes", formData, this.headers);
          post.favorite = true;
          post.likes_count += 1;
        }
      }
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
    updatePage() {
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
    closeDialog() {
      this.dialog = false;
    },
  },
};
</script>
