<template>
  <v-container>
    <v-row>
      <v-col>
        <DialogShowText v-model="isError">
          {{ errorText }}
        </DialogShowText>
        <TheBandsHeader
          v-model="tab"
          :band="band"
          :friend-status="friendStatus"
          :is-my-page="isMyPage"
          @start-chat="startChat"
          @change-friendship="changeFriendship"
        />
        <v-tabs-items v-model="tab">
          <v-tab-item>
            <TheBandsBiography :band="band" :is-my-page="isMyPage" />
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
                <CardActionsEventPastSelect v-model="showPast" />
                <v-card-text v-if="!displayEvents.length" class="px-3">
                  出演予定のイベントはありません
                </v-card-text>
              </v-col>
            </v-card>
            <CardEvents :events="displayEvents" />
          </v-tab-item>
        </v-tabs-items>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import DialogShowText from "@/components/Dialogs/DialogShowText";
import TheBandsHeader from "@/components/TheBands/TheBandsHeader";
import TheBandsBiography from "@/components/TheBands/TheBandsBiography";
import TheBandsPosts from "@/components/TheBands/TheBandsPosts";
import CardActionsEventPastSelect from "@/components/CardActions/CardActionsEventPastSelect";
import CardEvents from "@/components/Cards/CardEvents";

export default {
  components: {
    DialogShowText,
    TheBandsHeader,
    TheBandsBiography,
    TheBandsPosts,
    CardActionsEventPastSelect,
    CardEvents,
  },
  props: ["id"],
  data() {
    return {
      band: {},
      friendStatus: null,
      tab: 0,
      showPast: false,
      futureEvents: [],
      isError: false,
      errorText: "",
    };
  },
  created() {
    this.fetchBand();
  },
  watch: {
    $route(to, from) {
      if (to.params.id !== from.params.id) this.fetchBand();
    },
    isError(newValue) {
      if (!newValue) this.errorText = "";
    },
  },
  computed: {
    ...mapGetters(["bandId", "headers", "token"]),
    isMyPage() {
      return this.bandId === this.band.id;
    },
    displayEvents() {
      return this.showPast ? this.band.events : this.futureEvents;
    },
  },
  methods: {
    async fetchBand() {
      try {
        const res = await this.$axios.get(`/bands/${this.id}`, this.headers);
        this.band = res.data;
        this.friendStatus = res.data.friend_status;

        // 今日開催のEventはfutureEventsに含める
        const now = new Date();
        const today = new Date(
          now.getFullYear(),
          now.getMonth(),
          now.getDate()
        );
        this.futureEvents = this.band.events.filter((event) => {
          return today.getTime() <= new Date(event.date).getTime();
        });
      } catch (error) {
        if (error.response) this.$router.replace("/errors/not_found");
      }
    },
    async startChat() {
      try {
        const res = await this.$axios.get(
          `/bands/${this.bandId}/rooms`,
          this.headers
        );
        const room = res.data.find(
          (data) => data.friend_id === Number(this.id)
        );
        let roomId = room.id;
        if (!roomId) {
          const formData = new FormData();
          formData.append("band_room[band_id]", this.id);
          const res = await this.$axios.post("/rooms", formData, this.headers);
          roomId = res.data;
        }
        this.$router.push({
          path: `/bands/${this.bandId}/chats/${roomId}`,
          query: { partnerId: this.id },
        });
      } catch (error) {
        this.showError(error.response, "チャットを開始できません。");
      }
    },
    changeFriendship(isFollowing, formData) {
      if (isFollowing) {
        this.$axios.delete("/friendships", {
          headers: this.token,
          data: formData,
        });
        if (this.friendStatus === "friend") {
          return (this.friendStatus = "invited");
        } else {
          return (this.friendStatus = "");
        }
      } else {
        this.$axios.post("/friendships", formData, this.headers);
        if (this.friendStatus === "invited") {
          return (this.friendStatus = "friend");
        } else {
          return (this.friendStatus = "inviting");
        }
      }
    },
    async deletePost(postId) {
      try {
        await this.$axios.delete(`/posts/${postId}`, this.headers);
        this.updatePage();
      } catch (error) {
        this.showError(error.response, "投稿を削除できませんでした。");
      }
    },
    async patchPost(postId, postDescription) {
      try {
        const formData = new FormData();
        formData.append("post[description]", postDescription);
        await this.$axios.patch(`/posts/${postId}`, formData, this.headers);
        this.updatePage();
      } catch (error) {
        this.showError(error.response, "投稿を更新できませんでした。");
      }
    },
    changeLike(post) {
      if (!this.token) {
        return this.$router.push("/errors/unauthorized");
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
    showError(error, text) {
      if (error) {
        this.isError = true;
        this.errorText = text;
      }
    },
    updatePage() {
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
  },
};
</script>
