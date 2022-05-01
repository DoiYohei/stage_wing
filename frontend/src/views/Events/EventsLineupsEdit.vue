<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="#121212" flat>
          <v-card-title class="pb-0">
            <v-spacer />
            Lineup 編集
            <v-spacer />
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col xl="6" offset-xl="3" lg="8" offset-lg="2" sm="10" offset-sm="1">
        <v-card>
          <v-col>
            <FormLineup v-model="lineup" />
            <ButtonSubmitForms @submit-forms="patchLineup">
              更新する
            </ButtonSubmitForms>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";
import FormLineup from "@/components/Forms/FormLineup";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    FormLineup,
    ButtonSubmitForms,
  },
  props: ["id"],
  data() {
    return {
      lineup: {
        performers: [],
        unregisteredBands: [],
        registeredBands: [],
      },
      originalLineupIds: [],
    };
  },
  async created() {
    const res = await this.$axios.get(`/events/${this.id}/lineups`);
    this.lineup.performers = res.data.performers;
    this.originalLineupIds = res.data.lineup_ids;
    if (res.data.unregistered_performers) {
      this.lineup.unregisteredBands =
        res.data.unregistered_performers.split("*/");
    }
    this.lineup.registeredBands = res.data.bands;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    async patchLineup() {
      const originalLineupLength = this.originalLineupIds.length;
      const newLineupLength = this.lineup.performers.length;

      // 更新する総Lineup数が元の総Lineup数より多い場合、元の数分をpatch、多い分をpostする
      if (originalLineupLength <= newLineupLength) {
        for (let i = 0; i < originalLineupLength; i++) {
          let lineupId = this.originalLineupIds[i];
          let lineupFormData = new FormData();
          lineupFormData.append("lineup[event_id]", this.id);
          lineupFormData.append(
            "lineup[performer_id]",
            this.lineup.performers[i].id
          );
          await this.$axios.patch(
            `/events/${this.id}/lineups/${lineupId}`,
            lineupFormData,
            this.headers
          );
        }
        const numberOfNew = newLineupLength - originalLineupLength;
        if (numberOfNew > 0) {
          for (let j = originalLineupLength; j < newLineupLength; j++) {
            let lineupFormData = new FormData();
            lineupFormData.append("lineup[event_id]", this.id);
            lineupFormData.append(
              "lineup[performer_id]",
              this.lineup.performers[j].id
            );
            await this.$axios.post(
              `/events/${this.id}/lineups`,
              lineupFormData,
              this.headers
            );
          }
        }
      }

      // 更新する総Lineup数が元の総Lineup数より少ない場合、更新する分をpatch、少ない分をdeleteする
      if (originalLineupLength > newLineupLength) {
        for (let i = 0; i < newLineupLength; i++) {
          let lineupId = this.originalLineupIds[i];
          let lineupFormData = new FormData();
          lineupFormData.append("lineup[event_id]", this.id);
          lineupFormData.append(
            "lineup[performer_id]",
            this.lineup.performers[i].id
          );
          await this.$axios.patch(
            `/events/${this.id}/lineups/${lineupId}`,
            lineupFormData,
            this.headers
          );
        }
        for (let j = newLineupLength; j < originalLineupLength; j++) {
          let lineupId = this.originalLineupIds[j];
          await this.$axios.delete(
            `/events/${this.id}/lineups/${lineupId}`,
            this.headers
          );
        }
      }

      // 登録されていないBandsは、Eventsテーブルにpatchする
      const unregisteredPerformers = this.lineup.unregisteredBands.join("*/");
      const eventFormData = new FormData();
      eventFormData.append(
        "event[unregistered_performers]",
        unregisteredPerformers
      );
      await this.$axios.patch(
        `/events/${this.id}`,
        eventFormData,
        this.headers
      );

      // 更新したEventの詳細ページへ
      this.$router.replace(`/events/${this.id}`);
    },
  },
};
</script>
