<template>
  <v-container>
    <v-row>
      <v-col>
        <template v-for="(message, index) in messages">
          <div :key="index">
            <div>{{ speaker(message.band_id) }}</div>
            <div>
              {{ $dayjs(message.created_at).format("YYYY MMM DD - hh:mm") }} :
              {{ message.content }}
            </div>
          </div>
        </template>
        <v-textarea v-model="inputMessage" />
        <v-btn @click="sendMessage">送信</v-btn>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: ["room_id"],
  data() {
    return {
      inputMessage: "",
      messages: [],
      bands: [],
    };
  },
  channels: {
    RoomChannel: {
      connected() {
        console.log("connected");
      },
      received(data) {
        console.log("received");
        this.messages.push(data);
      },
    },
  },
  async created() {
    const res = await this.$axios.get(
      `/rooms/${this.room_id}/messages`,
      this.headers
    );
    this.messages = res.data.messages;
    this.bands = res.data.bands;
    const params = `uid=${this.token["uid"]}&access-token=${this.token["access-token"]}&client=${this.token["client"]}`;
    this.$cable.connection.connect(
      `ws://${process.env.VUE_APP_WS}/cable?${params}`
    );
    this.$cable.subscribe({ channel: "RoomChannel", room: this.room_id });
  },
  computed: {
    ...mapGetters(["headers", "token"]),
    speaker() {
      return (bandId) => {
        const speaker = this.bands.find((band) => band.id === bandId);
        return speaker.name;
      };
    },
  },
  methods: {
    sendMessage() {
      this.$cable.perform({
        channel: "RoomChannel",
        room: this.room_id,
        action: "speak",
        data: { message: this.inputMessage },
      });
      this.inputMessage = "";
    },
  },
  beforeRouteLeave(to, from, next) {
    this.$cable.connection.disconnect();
    next();
  },
};
</script>
