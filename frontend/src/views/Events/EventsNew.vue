<template>
  <v-container>
    <CardPageTitle title="新規 Event 作成" />
    <FormEvent
      v-model="event"
      @submit-forms="postEvent"
      :is-error="isEventError"
      submit-text="投稿"
    >
      <template #lineup>
        <v-textarea
          v-model="allLineup"
          @click.stop="lineupDialog = true"
          background-color="grey darken-4"
          label="Lineup"
          rows="1"
          auto-grow
          outlined
          readonly
        />
        <DialogLineupForm
          v-model="lineup"
          :dialog="lineupDialog"
          @select-submit="pushLineup"
          @select-clear="clearLineup"
        >
          <template #submit-text>決定</template>
          <template #clear-text>削除</template>
        </DialogLineupForm>
      </template>
    </FormEvent>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import CardPageTitle from "@/components/Cards/CardPageTitle";
import FormEvent from "@/components/Forms/FormEvent";
import DialogLineupForm from "@/components/Dialogs/DialogLineupForm";

export default {
  components: {
    CardPageTitle,
    FormEvent,
    DialogLineupForm,
  },
  data() {
    return {
      event: {
        fllyer: "",
        name: "",
        place: "",
        ticket_price: "",
        date: "",
        open_at: "",
        start_at: "",
        content: "",
        reservation: false,
      },
      lineup: {
        newLineup: [],
        newNoIdLineup: [],
      },
      isEventError: false,
      allLineup: [],
      lineupDialog: false,
    };
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    pushLineup() {
      let allLineupArray = [];
      if (this.lineup.newLineup) {
        for (let newBand of this.lineup.newLineup) {
          allLineupArray.push(newBand.name);
        }
      }
      if (this.lineup.newNoIdLineup) {
        allLineupArray.push(...this.lineup.newNoIdLineup);
      }
      if (allLineupArray) {
        if (allLineupArray.length > 1) {
          this.allLineup = allLineupArray.join(" / ");
        }
        if (allLineupArray.length === 1) {
          this.allLineup = allLineupArray[0];
        }
      }
      this.lineupDialog = false;
    },
    clearLineup() {
      this.lineup.newLineup = [];
      this.lineup.newNoIdLineup = [];
      this.allLineup = [];
      this.lineupDialog = false;
    },
    async postEvent(flyer) {
      let eventId;

      // 新規Eventを投稿
      try {
        const eventFormData = new FormData();
        eventFormData.append("event[name]", this.event.name);
        eventFormData.append("event[place]", this.event.place);
        eventFormData.append("event[ticket_price]", this.event.ticket_price);
        eventFormData.append("event[date]", this.event.date);
        eventFormData.append("event[open_at]", this.event.open_at);
        eventFormData.append("event[start_at]", this.event.start_at);
        eventFormData.append("event[content]", this.event.content);
        eventFormData.append("event[reservation]", this.event.reservation);
        eventFormData.append(
          "event[unregistered_performers]",
          this.lineup.newNoIdLineup.join("*/")
        );
        if (flyer) eventFormData.append("event[flyer]", flyer);
        const eventRes = await this.$axios.post(
          "/events",
          eventFormData,
          this.headers
        );
        eventId = eventRes.data.id;
      } catch (error) {
        if (error.response) this.isEventError = true;
      }

      // 投稿したEventのLineupを登録
      if (!this.isEvnetError) {
        try {
          if (this.lineup.newLineup) {
            for (let newBand of this.lineup.newLineup) {
              let lineupFormData = new FormData();
              lineupFormData.append("lineup[event_id]", eventId);
              lineupFormData.append("lineup[performer_id]", newBand.id);
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
              query: { lineupCreateError: true },
            });
          }
        }
      }
    },
  },
};
</script>
