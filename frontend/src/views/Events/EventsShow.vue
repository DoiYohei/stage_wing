<template>
  <v-container>
    <v-row>
      <v-col md="4" offset-md="4">
        <template v-if="event.owner_id">
          <div>{{ ownerName }}</div>
        </template>
        <p v-else>作成者は退会しました</p>
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
      <template v-for="(comment, index) of event.parent_comments">
        <!-- 子コンポーネントのcomputedでエラーが発生するため、dataを取得するまでv-if="ownerName"で待つ -->
        <comment-comp
          v-if="ownerName"
          :eventId="Number(id)"
          :bands="bands"
          :comment="comment"
          :comments="event.comments"
          :key="`comment${index}`"
        />
      </template>
      <v-col md="4" offset-md="4">
        <v-textarea v-model="newComment" label="コメント" outlined />
        <v-col cols="12">
          <v-btn elevation="4" @click="postComment">コメントする</v-btn>
        </v-col>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import CommentComp from "@/components/CommentComp";

export default {
  components: {
    CommentComp,
  },
  props: ["id"],
  data() {
    return {
      event: {},
      bands: [],
      ownerName: "",
      newComment: "",
    };
  },
  async created() {
    const eventRes = await this.$axios.get(`/events/${this.id}`);
    this.event = eventRes.data;
    const bandsRes = await this.$axios.get("/bands");
    this.bands = bandsRes.data.bands;
    const owner = this.bands.filter((band) => band.id === this.event.owner_id);
    this.ownerName = owner[0].name;
  },
  computed: {
    isEventOwner() {
      return this.$store.getters.currentUserId === this.event.owner_id;
    },
  },
  methods: {
    async deleteEvent() {
      const token = { headers: this.$store.getters.token };
      await this.$axios.delete(`/events/${this.id}`, token);
      this.$router.replace("/");
    },
    async postComment() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("comment[event_id]", this.id);
      formData.append("comment[content]", this.newComment);
      await this.$axios.post(`/events/${this.id}/comments`, formData, token);
    },
  },
};
</script>
