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
          <v-btn elevation="4" @click="postEvent">投稿する</v-btn>
        </v-col>
      </v-row>
    </v-container>
  </div>
</template>

<script>
export default {
  data() {
    return {
      name: "",
      flyer: [],
      place: "",
      openAt: "",
      startAt: "",
      content: "",
      performers: [],
      unregisteredPerformers: "",
      url: "",
      registeredBands: [],
    };
  },
  async created() {
    // 出演者の入力時に検索機能を使うため、本サービスに登録されているBand一覧を取得
    const res = await this.$axios.get("/bands");
    this.registeredBands = res.data.bands;
  },
  methods: {
    fetchUrl(file) {
      // 選択した画像ファイルを表示するための、URLを取得
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
    async postEvent() {
      const token = { headers: this.$store.getters.token };

      // 新規Eventを投稿
      const eventFormData = new FormData();
      eventFormData.append("event[name]", this.name);
      eventFormData.append("event[flyer]", this.flyer);
      eventFormData.append("event[place]", this.place);
      eventFormData.append("event[open_at]", this.openAt);
      eventFormData.append("event[start_at]", this.startAt);
      eventFormData.append("event[content]", this.content);
      eventFormData.append(
        "event[unregistered_performers]",
        this.unregisteredPerformers
      );
      const eventRes = await this.$axios.post("/events", eventFormData, token);

      // 投稿したEventの出演者を登録
      const eventId = eventRes.data.id;
      if (this.performers) {
        for (let performer of this.performers) {
          let lineupFormData = new FormData();
          lineupFormData.append("lineup[event_id]", eventId);
          lineupFormData.append("lineup[performer_id]", performer.id);
          await this.$axios.post(
            `/events/${eventId}/lineups`,
            lineupFormData,
            token
          );
        }
      }

      // 投稿したEventの詳細ページへ
      this.$router.replace(`/events/${eventId}`);
    },
  },
};
</script>
