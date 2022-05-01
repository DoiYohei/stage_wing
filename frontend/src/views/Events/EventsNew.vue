<template>
  <FormEvent v-model="event" @submit-forms="postEvent">
    <template #page-title>新規 Event 作成</template>
    <template #lineup>
      <v-col>
        <v-card color="grey darken-4">
          <v-card-subtitle class="text-left text-subtitle-1">
            Lineup
          </v-card-subtitle>
          <FormLineup v-model="lineup" />
        </v-card>
      </v-col>
    </template>
    <template #btn-text>投稿する</template>
  </FormEvent>
</template>

<script>
import { mapGetters } from "vuex";
import FormEvent from "@/components/Forms/FormEvent";
import FormLineup from "@/components/Forms/FormLineup";

export default {
  components: {
    FormEvent,
    FormLineup,
  },
  data() {
    return {
      event: {
        name: "",
        place: "",
        ticketPrice: "",
        openAt: "",
        startAt: "",
        content: "",
        reservation: false,
      },
      lineup: {
        performers: [],
        unregisteredBands: [],
        registeredBands: [],
      },
    };
  },
  async created() {
    // 出演者の入力時に検索機能を使うため、本サービスに登録されているBand一覧を取得
    const res = await this.$axios.get("/bands");
    this.lineup.registeredBands = res.data.bands;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async postEvent(flyer) {
      const unregisteredPerformers = this.lineup.unregisteredBands.join("*/");

      // 新規Eventを投稿
      const eventFormData = new FormData();
      eventFormData.append("event[name]", this.event.name);
      eventFormData.append("event[place]", this.event.place);
      eventFormData.append("event[ticket_price]", this.event.ticketPrice);
      eventFormData.append("event[open_at]", this.event.openAt);
      eventFormData.append("event[start_at]", this.event.startAt);
      eventFormData.append("event[content]", this.event.content);
      eventFormData.append("event[reservation]", this.event.reservation);
      eventFormData.append(
        "event[unregistered_performers]",
        unregisteredPerformers
      );
      if (flyer) eventFormData.append("event[flyer]", flyer);
      const eventRes = await this.$axios.post(
        "/events",
        eventFormData,
        this.headers
      );

      // 投稿したEventのLineupを登録
      const eventId = eventRes.data.id;
      if (this.lineup.performers) {
        for (let performer of this.lineup.performers) {
          let lineupFormData = new FormData();
          lineupFormData.append("lineup[event_id]", eventId);
          lineupFormData.append("lineup[performer_id]", performer.id);
          await this.$axios.post(
            `/events/${eventId}/lineups`,
            lineupFormData,
            this.headers
          );
        }
      }

      // 投稿したEventの詳細ページへ
      this.$router.replace(`/events/${eventId}`);
    },
  },
};
</script>
