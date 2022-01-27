<template>
  <div>
    <h1>チケット取り置き</h1>
    <v-container>
      <v-row>
        <v-col md="4" offset-md="4">
          <div>
            以下のEventのチケットをお取り置きいたします。
            お目当てのバンドを選択して、完了をクリックしてください。
          </div>
        </v-col>
        <v-col md="4" offset-md="4">
          <div>{{ event.name }}</div>
          <div>
            Open: {{ $dayjs(event.open_at).format("YYYY MMM DD - hh:mm") }}
          </div>
          <div>
            Start: {{ $dayjs(event.start_at).format("YYYY MMM DD - hh:mm") }}
          </div>
          <div>Place: {{ event.place }}</div>
          <div>Price: ¥{{ event.ticket_price }}</div>
        </v-col>
        <v-col md="4" offset-md="4">
          <v-select
            :items="event.lineups"
            item-text="name"
            item-value="id"
            label="お目当てのバンド"
            placeholder="選択してください"
            persistent-placeholder
            filled
            v-model="selectedBand"
          />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="postTicket">完了</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  props: {
    id: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      event: {},
      selectedBand: null,
    };
  },
  async created() {
    const res = await this.$axios.get(
      `/events/${this.id}/tickets/new`,
      this.headers
    );
    this.event = res.data;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async postTicket() {
      const formData = new FormData();
      formData.append("ticket[event_id]", this.id);
      formData.append("ticket[band_id]", this.selectedBand);
      await this.$axios.post(
        `/events/${this.id}/tickets`,
        formData,
        this.headers
      );
      this.$router.replace(`/events/${this.id}`);
    },
  },
};
</script>
