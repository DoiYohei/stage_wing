<template>
  <div>
    <v-container>
      <v-row>
        <v-col cols="12">
          <div>Lineup</div>
          <v-col
            md="4"
            offset-md="4"
            v-for="(performer, index) in performers"
            :key="index"
          >
            <v-text-field v-model="performer.name" />
          </v-col>
        </v-col>
        <v-col md="4" offset-md="4">
          <v-textarea
            v-model="unregisteredPerformers.name"
            label="登録されていないアーティスト"
            outlined
          />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="editLineup">変更する</v-btn>
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
      lineupIds: [],
    };
  },
  computed: {
    bandsData() {
      return this.$store.getters.bandsData;
    },
    countEmptyForm() {
      return this.performers.filter((el) => el.name === "").length;
    },
  },
  watch: {
    countEmptyForm(newData) {
      if (newData === 0) {
        this.performers.push({ name: "" });
      }
      if (newData >= 2) {
        // this.performersから、{name: ''}を持つ最後の要素を削除する
        const isEmptyForm = [];
        for (let performer of this.performers) {
          let isEmptyName = performer.name === "";
          isEmptyForm.push(isEmptyName);
        }
        this.performers.splice(isEmptyForm.lastIndexOf(true), 1);
      }
    },
  },
  methods: {
    async editLineup() {
      const eventId = this.id;
      const token = {
        headers: this.$store.getters.authData,
      };
      const newPerformerIds = [];
      for (let performer of this.performers) {
        let registeredPerformer = this.bandsData.find(
          (el) => el.name === performer.name
        );
        if (registeredPerformer) {
          newPerformerIds.push(registeredPerformer.id);
        }
      }
      const originalLineupLength = this.lineupIds.length;
      const newLineupLength = newPerformerIds.length;
      if (originalLineupLength <= newLineupLength) {
        for (let i = 0; i < originalLineupLength; i++) {
          let lineupId = this.lineupIds[i];
          let formData = {
            event_id: eventId,
            performer_id: newPerformerIds[i],
          };
          await this.$store.dispatch("editLineup", {
            eventId,
            lineupId,
            formData,
            token,
          });
        }
        const numberOfNew = newLineupLength - originalLineupLength;
        if (numberOfNew > 0) {
          const performerIds = [];
          for (let j = originalLineupLength; j < newLineupLength; j++) {
            let performerId = newPerformerIds[j];
            performerIds.push(performerId);
          }
          await this.$store.dispatch("postLineup", {
            eventId,
            performerIds,
            token,
          });
        }
      }
      if (originalLineupLength > newLineupLength) {
        for (let i = 0; i < newLineupLength; i++) {
          let lineupId = this.lineupIds[i];
          let formData = {
            event_id: eventId,
            performer_id: newPerformerIds[i],
          };
          await this.$store.dispatch("editLineup", {
            eventId,
            lineupId,
            formData,
            token,
          });
        }
        for (let j = newLineupLength; j < originalLineupLength; j++) {
          let lineupId = this.lineupIds[j];
          await this.$store.dispatch("deleteLineup", {
            eventId,
            lineupId,
            token,
          });
        }
      }
      const lineupId = this.unregisteredPerformers.id;
      const formData = {
        event_id: eventId,
        unregistered_performers: this.unregisteredPerformers.name,
      };
      await this.$store.dispatch("editLineup", {
        eventId,
        lineupId,
        formData,
        token,
      });
      this.$store
        .dispatch("getLineup", eventId)
        .then(() => this.$router.replace("/events/" + eventId));
    },
  },
  async created() {
    this.$store.dispatch("getBandsData");
    const res = await this.$axios.get(`/events/${this.id}/lineups`);
    this.performers = res.data.performers;
    this.lineupIds = res.data.lineup_ids;
    this.performers.push({ name: "" });
    this.unregisteredPerformers = res.data.unregistered_performers;
  },
};
</script>
