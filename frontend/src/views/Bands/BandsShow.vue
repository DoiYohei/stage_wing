<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
    <v-row>
      <v-col class="pt-0 px-0">
        <v-card color="#121212" flat class="d-md-flex justify-md-end">
          <v-card-actions class="px-0 pt-0 pb-1 px-md-2 py-md-4">
            <v-tabs
              v-model="tab"
              :background-color="$vuetify.breakpoint.mdAndUp ? '#121212' : ''"
              fixed-tabs
            >
              <v-tab v-for="content in contents" :key="content">
                {{ content }}
              </v-tab>
            </v-tabs>
          </v-card-actions>
        </v-card>
        <v-tabs-items v-model="tab">
          <v-tab-item>
            <TheBandsBiography
              :band="band"
              :friend-state="friendState"
              :is-my-page="isMyPage"
              @start-chat="startChat"
              @change-friend-state="changeFriendState"
            />
          </v-tab-item>
          <v-tab-item>
            <TheBandsPosts
              :posts="band.posts"
              :is-my-page="isMyPage"
              @delete-post="deletePost"
              @patch-post="patchPost"
              @change-like="changeLike"
            />
          </v-tab-item>
          <v-tab-item>
            <v-card color="#121212" flat>
              <v-col>
                <SearchInputPastEvent v-model="showPast" color="#121212" />
                <v-card-text v-if="!eventsForShow.length" class="px-3">
                  出演予定のイベントはありません
                </v-card-text>
              </v-col>
              <v-col>
                <CardEvent :events="eventsForShow" />
              </v-col>
            </v-card>
          </v-tab-item>
        </v-tabs-items>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import TheBandsBiography from "@/components/TheBands/TheBandsBiography";
import TheBandsPosts from "@/components/TheBands/TheBandsPosts";
import SearchInputPastEvent from "@/components/SearchInputs/SearchInputPastEvent";
import CardEvent from "@/components/Cards/CardEvent";
import { mapGetters, mapActions } from "vuex";
import { popFutureItems } from "@/utils/searches";
import { goTo404 } from "@/utils/routers";
import { fetchRooms, findPartnerRoom, goToChatShow } from "@/utils/chats";
import { changeFriendship } from "@/utils/friendships";
import { deletePost, patchPost } from "@/utils/posts";
import { changeLike } from "@/utils/likes";

export default {
  components: {
    TheBandsBiography,
    TheBandsPosts,
    SearchInputPastEvent,
    CardEvent,
  },
  props: ["id"],
  data() {
    return {
      band: {},
      friendState: null,
      tab: 0,
      contents: ["Biography", "Post", "Live"],
      showPast: false,
      futureEvents: [],
    };
  },
  created() {
    this.fetchBand();
  },
  watch: {
    $route(to, from) {
      if (to.params.id !== from.params.id) this.fetchBand();
    },
  },
  computed: {
    ...mapGetters(["bandId", "headers"]),
    isMyPage() {
      return this.bandId === this.band.id;
    },
    eventsForShow() {
      return this.showPast ? this.band.events : this.futureEvents;
    },
  },
  methods: {
    async fetchBand() {
      try {
        const res = await this.$axios.get(`/bands/${this.id}`, this.headers);
        this.band = res.data;
        this.friendState = res.data.friend_state;
        this.futureEvents = popFutureItems(this.band.events);
      } catch (error) {
        if (error.response) goTo404();
      }
    },
    async startChat() {
      try {
        const res = await fetchRooms();
        const room = findPartnerRoom(res.data, Number(this.id));
        goToChatShow(room.id, this.id);
      } catch (error) {
        if (error.response) {
          this.showError("チャットを開始できません。");
        }
      }
    },
    changeFriendState(band, friendship) {
      changeFriendship(band.id, friendship.isFollowing);
      this.friendState = friendship.opposition;
    },
    deletePost(postId) {
      deletePost(postId);
    },
    patchPost(postId, postDescription) {
      patchPost(postId, postDescription);
    },
    changeLike(post) {
      changeLike(post);
    },
    ...mapActions(["showError"]),
  },
};
</script>
