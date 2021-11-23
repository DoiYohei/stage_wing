<template>
  <div>
    <v-container>
      <v-row>
        <v-col cols="12">
          <div>Lineup</div>
          <v-col md="4" offset-md="4">
            <v-autocomplete
              v-model="performers"
              :items="registeredBands"
              item-text="name"
              no-data-text="登録されていません"
              multiple
              return-object
              clearable
              outlined
            />
          </v-col>
          <v-col md="4" offset-md="4">
            <v-textarea
              v-model="unregisteredPerformers"
              label="登録されていないアーティスト"
              outlined
            />
          </v-col>
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="patchLineup">変更する</v-btn>
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
      performers: [],
      unregisteredPerformers: "",
      originalLineupIds: [],
      registeredBands: [],
    };
  },
  async created() {
    const lineupRes = await this.$axios.get(`/events/${this.id}/lineups`);
    this.performers = lineupRes.data.performers;
    this.originalLineupIds = lineupRes.data.lineup_ids;
    const eventRes = await this.$axios.get(`/events/${this.id}`);
    this.unregisteredPerformers = eventRes.data.unregistered_performers;

    // 出演者の入力時に検索機能を使うため、本サービスに登録されているBand一覧を取得
    const bandsRes = await this.$axios.get("/bands");
    this.registeredBands = bandsRes.data.bands;
  },
  methods: {
    async patchLineup() {
      const eventId = this.id;
      const token = {
        headers: this.$store.getters.token,
      };
      const originalLineupLength = this.originalLineupIds.length;
      const newLineupLength = this.performers.length;

      // 更新する総Lineup数が元の総Lineup数より多い場合、元の数分をpatch、多い分をpostする
      if (originalLineupLength <= newLineupLength) {
        for (let i = 0; i < originalLineupLength; i++) {
          let lineupId = this.originalLineupIds[i];
          let lineupFormData = new FormData();
          lineupFormData.append("lineup[event_id]", eventId);
          lineupFormData.append("lineup[performer_id]", this.performers[i].id);
          await this.$axios.patch(
            `/events/${eventId}/lineups/${lineupId}`,
            lineupFormData,
            token
          );
        }
        const numberOfNew = newLineupLength - originalLineupLength;
        if (numberOfNew > 0) {
          for (let j = originalLineupLength; j < newLineupLength; j++) {
            let lineupFormData = new FormData();
            lineupFormData.append("lineup[event_id]", eventId);
            lineupFormData.append(
              "lineup[performer_id]",
              this.performers[j].id
            );
            await this.$axios.post(
              `/events/${eventId}/lineups`,
              lineupFormData,
              token
            );
          }
        }
      }

      // 更新する総Lineup数が元の総Lineup数より少ない場合、更新する分をpatch、少ない分をdeleteする
      if (originalLineupLength > newLineupLength) {
        for (let i = 0; i < newLineupLength; i++) {
          let lineupId = this.originalLineupIds[i];
          let lineupFormData = new FormData();
          lineupFormData.append("lineup[event_id]", eventId);
          lineupFormData.append("lineup[performer_id]", this.performers[i].id);
          await this.$axios.patch(
            `/events/${eventId}/lineups/${lineupId}`,
            lineupFormData,
            token
          );
        }
        for (let j = newLineupLength; j < originalLineupLength; j++) {
          let lineupId = this.originalLineupIds[j];
          await this.$axios.delete(
            `/events/${eventId}/lineups/${lineupId}`,
            token
          );
        }
      }

      // 登録されていないBandsは、Eventsテーブルにpatchする
      const eventFormData = new FormData();
      eventFormData.append(
        "event[unregistered_performers]",
        this.unregisteredPerformers
      );
      await this.$axios.patch(`/events/${eventId}`, eventFormData, token);

      // 更新したEventの詳細ページへ
      this.$router.replace(`/events/${eventId}`);
    },
  },
};
</script>
