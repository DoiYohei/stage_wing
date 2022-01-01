<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">Lineup編集</v-col>
    </v-row>
    <v-row justify="center">
      <v-card>
        <v-card-text class="pb-0">
          <v-autocomplete
            v-model="performers"
            :items="registeredBands"
            item-text="name"
            no-data-text="登録されていません"
            label="本サイトに登録されているアーティスト"
            chips
            clearable
            deletable-chips
            multiple
            outlined
            return-object
          />
          <v-combobox
            v-model="unregisteredBands"
            label="本サイトに登録されていないアーティスト"
            hint="各アーティストごとにEnterキーを入力してください。"
            chips
            clearable
            deletable-chips
            multiple
            outlined
          />
        </v-card-text>
        <v-card-actions class="mt-5">
          <v-btn width="100%" elevation="4" @click="patchLineup">
            変更する
          </v-btn>
        </v-card-actions>
      </v-card>
    </v-row>
  </v-container>
</template>

<script>
export default {
  props: ["id"],
  data() {
    return {
      performers: [],
      unregisteredBands: [],
      originalLineupIds: [],
      registeredBands: [],
    };
  },
  async created() {
    const res = await this.$axios.get(`/events/${this.id}/lineups`);
    this.performers = res.data.performers;
    this.originalLineupIds = res.data.lineup_ids;
    if (res.data.unregistered_performers) {
      this.unregisteredBands = res.data.unregistered_performers.split("*/");
    }
    this.registeredBands = res.data.bands;
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
      const unregisteredPerformers = this.unregisteredBands.join("*/");
      const eventFormData = new FormData();
      eventFormData.append(
        "event[unregistered_performers]",
        unregisteredPerformers
      );
      await this.$axios.patch(`/events/${eventId}`, eventFormData, token);

      // 更新したEventの詳細ページへ
      this.$router.replace(`/events/${eventId}`);
    },
  },
};
</script>
