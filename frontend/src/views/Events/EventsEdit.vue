<template>
  <div>
    <h1>イベント内容の編集</h1>
    <v-container>
      <v-row>
        <v-col md="4" offset-md="4">
          <v-text-field v-model="event.name" label="イベント名" />
        </v-col>
        <v-col md="4" offset-md="4">
          <v-text-field v-model="event.place" label="場所" />
        </v-col>
        <v-col md="2" offset-md="4">
          <vue-ctk-date-time-picker
            v-model="event.open_at"
            format="YYYY-MM-DD HH:mm"
            label="Open"
            id="open-at"
          />
        </v-col>
        <v-col md="2">
          <vue-ctk-date-time-picker
            v-model="event.start_at"
            format="YYYY-MM-DD HH:mm"
            label="Start"
            id="start-at"
          />
        </v-col>
        <v-col md="4" offset-md="4">
          <v-textarea v-model="event.content" label="詳細" outlined />
        </v-col>
        <v-col md="4" offset-md="4">
          <v-sheet>
            <v-switch
              v-model="event.reservation"
              inset
              :label="reservationMessage"
            />
          </v-sheet>
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="patchEvent">更新する</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      event: {},
    };
  },
  computed: {
    reservationMessage() {
      if (this.event.reservation) {
        return "チケット取り置きを受けつける";
      } else {
        return "チケット取り置きを受けつけない";
      }
    },
  },
  methods: {
    setFlyer(e) {
      this.flyer = e.target.files[0];
      this.url = URL.createObjectURL(this.image);
    },
    async patchEvent() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("event[name]", this.event.name);
      formData.append("event[flyer]", this.event.flyer);
      formData.append("event[place]", this.event.place);
      formData.append("event[open_at]", this.event.open_at);
      formData.append("event[start_at]", this.event.start_at);
      formData.append("event[content]", this.event.content);
      formData.append("event[reservation]", this.event.reservation);
      await this.$axios.patch(`/events/${this.id}`, formData, token);
      this.$router.replace(`/events/${this.id}`);
    },
  },
  async created() {
    const res = await this.$axios.get(`/events/${this.id}`);
    this.event = res.data;
  },
};
</script>
