<template>
  <v-container :fluid="$vuetify.breakpoint.lgAndDown">
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
          text-for-submit="決定"
          text-for-clear="削除"
        />
      </template>
    </FormEvent>
  </v-container>
</template>

<script>
import CardPageTitle from "@/components/Cards/CardPageTitle";
import FormEvent from "@/components/Forms/FormEvent";
import DialogLineupForm from "@/components/Dialogs/DialogLineupForm";
import { mapGetters } from "vuex";
import { postEvent } from "@/utils/events";
import { postLineup } from "@/utils/lineup";

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
      allLineup: "", // 表示用Lineup
      lineupDialog: false,
    };
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    pushLineup() {
      // 入力されたLineupを表示用Lineup(allLineup)に反映させる。
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
      let eventId; // EventのPOST後に生成されたidを入れる。LineupのPOSTに使用する。

      // 新規Eventを投稿
      try {
        const res = await postEvent(this.event, this.lineup, flyer);
        eventId = res.data.id;
      } catch (error) {
        this.isEventError = true;
      }

      // 投稿したEventのLineupを登録。
      if (!this.isEventError && this.lineup.newLineup) {
        try {
          await postLineup(this.lineup.newLineup, eventId);
          this.$router.replace(`/events/${eventId}`);
        } catch (error) {
          // Lineup登録時のエラーはEventページ遷移後に表示する。
          this.$router.replace({
            path: `/events/${eventId}`,
            query: { lineupCreateError: true },
          });
        }
      }
    },
  },
};
</script>
