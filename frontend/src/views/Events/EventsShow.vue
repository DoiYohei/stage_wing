<template>
  <v-container>
    <template v-if="!isLoadingData">
      <v-row>
        <v-col md="4" offset-md="4">
          <div>{{ ownerName }}</div>
          <template v-if="isEventOwner">
            <router-link :to="`/events/${id}/edit`"
              >イベント情報を編集する</router-link
            >
            <button @click="deleteEvent">削除する</button>
          </template>
          <div>{{ event.name }}</div>
          <img :src="event.flyer" />
          <div>
            Open: {{ $dayjs(event.open_at).format("YYYY MMM DD - hh:mm") }}
          </div>
          <div>
            Start: {{ $dayjs(event.start_at).format("YYYY MMM DD - hh:mm") }}
          </div>
          <div>{{ event.place }}</div>
          <div>{{ event.content }}</div>
          <p>Lineup:</p>
          <template v-if="event.performers">
            <div v-for="(performer, index) in event.performers" :key="index">
              <router-link :to="`/bands/${performer.id}`">{{
                performer.name
              }}</router-link>
            </div>
          </template>
          <template v-if="event.unregistered_performers">
            <div>/ {{ event.unregistered_performers }}</div>
          </template>
          <template v-if="isEventOwner">
            <router-link :to="`/events/${id}/lineup/edit`"
              >Lineupを編集する</router-link
            >
          </template>
        </v-col>
        <v-col md="4" offset-md="4">
          <div>Price: {{ event.ticket_price }}</div>
          <template v-if="isAudience">
            <div v-if="event.ticket">
              チケットを取り置きしています
              <v-btn @click="deleteTicket">キャンセルする</v-btn>
            </div>
            <template v-else-if="event.reservation">
              <router-link :to="`/events/${id}/tickets/new`"
                >チケットを取り置きする
              </router-link>
            </template>
            <div v-else>チケット取り置きはできません</div>
          </template>
        </v-col>
        <template v-for="(comment, index) of event.parent_comments">
          <comment-for-event :comment="comment" :key="`comment${index}`" />
        </template>
        <v-col md="4" offset-md="4">
          <v-textarea v-model="newComment" label="コメント" outlined />
          <v-col cols="12">
            <v-btn elevation="4" @click="postComment">コメントする</v-btn>
          </v-col>
        </v-col>
      </v-row>
    </template>
  </v-container>
</template>

<script>
import CommentForEvent from "@/components/CommentForEvent";

export default {
  components: {
    CommentForEvent,
  },
  props: ["id"],
  data() {
    return {
      event: null,
      bands: null,
      ownerName: "",
      newComment: "",
    };
  },
  async created() {
    let token = null;
    if (this.$store.getters.userType === "audience") {
      token = { headers: this.$store.getters.token };
    }
    const eventRes = await this.$store.dispatch("getEventData", {
      eventId: this.id,
      token,
    });
    this.event = eventRes;
    await this.$store.dispatch("getAudiences");
    const bandsRes = await this.$store.dispatch("getBandsData");
    this.bands = bandsRes;
    const owner = this.bands.filter((band) => band.id === this.event.owner_id);
    if (this.event.owner_id) {
      this.ownerName = owner[0].name;
    } else {
      this.ownerName = "作成者は退会しました";
    }
  },
  computed: {
    isEventOwner() {
      return (
        this.$store.getters.userType === "band" &&
        this.$store.getters.currentUserId === this.event.owner_id
      );
    },
    isLoadingData() {
      return !this.ownerName;
    },
    isAudience() {
      return this.$store.getters.userType === "audience";
    },
  },
  methods: {
    async deleteEvent() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(`/events/${this.id}`, token);
      this.$router.replace("/");
    },
    async postComment() {
      if (!this.$store.getters.authData) {
        return this.$router.push("/errors/auth");
      } else {
        const token = { headers: this.$store.getters.token };
        const formData = new FormData();
        formData.append("comment[event_id]", this.id);
        formData.append("comment[content]", this.newComment);
        await this.$axios.post(`/events/${this.id}/comments`, formData, token);
        this.$router.go({ path: this.$router.currentRoute.path, force: true });
      }
    },
    async deleteTicket() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(
        `/events/${this.id}/tickets/${this.event.ticket.id}`,
        token
      );
      this.$router.go({ path: this.$router.currentRoute.path, force: true });
    },
  },
};
</script>
