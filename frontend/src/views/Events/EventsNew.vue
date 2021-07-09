<template>
  <div>
    <h1>新規イベント投稿</h1>
    <v-container>
      <v-row>
        <v-col md="4" offset-md="4">
          <v-text-field v-model="name" label="イベント名" />
        </v-col>
        <v-col md="2" offset-md="4">
          <v-file-input
            v-model="flyer"
            @change="fetchUrl"
            label="フライヤー"
            placeholder="ファイルを選択してください"
            chips
          />
        </v-col>
        <v-col md="2">
          <v-img v-if="url" :src="url" />
        </v-col>
        <v-col md="4" offset-md="4">
          <v-text-field v-model="place" label="場所" />
        </v-col>
        <v-col md="2" offset-md="4">
          <vue-ctk-date-time-picker
            v-model="openAt"
            format="YYYY-MM-DD HH:mm"
            label="Open"
            id="open-at"
          />
        </v-col>
        <v-col md="2">
          <vue-ctk-date-time-picker
            v-model="startAt"
            format="YYYY-MM-DD HH:mm"
            label="Start"
            id="start-at"
          />
        </v-col>
        <v-col md="4" offset-md="4">
          <v-textarea v-model="content" label="詳細" outlined />
        </v-col>
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
            v-model="unregisteredPerformers"
            label="登録されていないアーティスト"
            outlined
          />
        </v-col>
        <v-col cols="12">
          <v-btn elevation="4" @click="postEvent">投稿する</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
import router from "@/routes";

export default {
  data() {
    return {
      name: "",
      flyer: [],
      place: "",
      openAt: "",
      startAt: "",
      content: "",
      performers: [{ name: "" }],
      unregisteredPerformers: "",
      url: "",
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
    fetchUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        }
        const fr = new FileReader();
        fr.readAsDataURL(file);
        fr.addEventListener("load", () => {
          this.url = fr.result;
        });
      } else {
        this.url = "";
      }
    },
    postEvent() {
      const performerIds = [];
      for (let performer of this.performers) {
        let registeredPerformer = this.bandsData.find(
          (el) => el.name === performer.name
        );
        if (registeredPerformer) {
          performerIds.push(registeredPerformer.id);
        }
      }
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("event[name]", this.name);
      formData.append("event[flyer]", this.flyer);
      formData.append("event[place]", this.place);
      formData.append("event[open_at]", this.openAt);
      formData.append("event[start_at]", this.startAt);
      formData.append("event[content]", this.content);
      this.$store
        .dispatch("postEvent", { formData, token })
        .then(() => {
          const lineupForm = {
            eventId: this.$store.getters.eventData.id,
            performerIds: performerIds,
            unregisteredPerformers: this.unregisteredPerformers,
            token: token,
          };
          this.$store.dispatch("postLineup", lineupForm);
        })
        .then(() =>
          router.replace("/events/" + this.$store.getters.eventData.id)
        );
    },
  },
  created() {
    if (this.bandsData === null) {
      this.$store.dispatch("getBandsData");
    }
  },
};
</script>
