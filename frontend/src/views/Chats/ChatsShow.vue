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
    const token = { headers: this.$store.getters.token };
    const res = await this.$axios.get(`/rooms/${this.room_id}/messages`, token);
    this.messages = res.data.messages;
    this.bands = res.data.bands;
    const authData = this.$store.getters.token;
    const params = `uid=${authData["uid"]}&access-token=${authData["access-token"]}&client=${authData["client"]}`;
    this.$cable.connection.connect(
      `ws://${process.env.VUE_APP_WS}/cable?${params}`
    );
    this.$cable.subscribe({ channel: "RoomChannel", room: this.room_id });
  },
  computed: {
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
