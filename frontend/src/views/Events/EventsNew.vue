<template>
  <FormEvent v-model="event" :is-error="isError" @submit-forms="postEvent">
    <template #page-title>新規 Event 作成</template>
    <template #error-text>
      {{ errorText }}
    </template>
    <template #lineup>
      <v-col class="pt-0 pb-6">
        <v-card color="#313131">
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
        ticket_price: null,
        open_at: "",
        start_at: "",
        content: "",
        reservation: false,
      },
      lineup: {
        performers: [],
        unregisteredBands: [],
        registeredBands: [],
      },
      isError: false,
      errorText: "",
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
      let eventId = null;

      // 新規Eventを投稿
      try {
        const unregisteredPerformers = this.lineup.unregisteredBands.join("*/");
        if (unregisteredPerformers.length > 1000) {
          throw { overLength: true };
        } else {
          const eventFormData = new FormData();
          eventFormData.append("event[name]", this.event.name);
          eventFormData.append("event[place]", this.event.place);
          eventFormData.append("event[ticket_price]", this.event.ticket_price);
          eventFormData.append("event[open_at]", this.event.open_at);
          eventFormData.append("event[start_at]", this.event.start_at);
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
          eventId = eventRes.data.id;
        }
      } catch (error) {
        this.isError = true;
        if (error.response) {
          this.errorText = "Eventの投稿ができませんでした。";
        }
        if (error.overLength) {
          this.errorText =
            "「本サイトに登録されていないBand」の総文字数が多いため投稿できません。「本サイトに登録されていないBand」の総文字数を800字程度に収めてください。";
        }
      }

      // 投稿したEventのLineupを登録
      if (!this.isError) {
        try {
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
          this.$router.replace(`/events/${eventId}`);
        } catch (error) {
          if (error.response) {
            this.$router.replace({
              path: `/events/${eventId}`,
              query: {
                lineupError: true,
                errorText: "Lineupに登録できないBandがありました。",
              },
            });
          }
        }
      }
    },
  },
};
</script>
