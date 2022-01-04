<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">新規Event作成</v-col>
    </v-row>
    <v-row>
      <v-col>
        <v-card>
          <v-col class="d-flex justify-md-start flex-wrap">
            <v-col md="7" sm="12">
              <v-img v-if="flyerUrl" :src="flyerUrl" />
            </v-col>
            <v-col class="test-left pb-0">
              <v-card-text>
                <v-file-input
                  v-model="flyer"
                  @change="fetchUrl"
                  label="フライヤー"
                  placeholder="ファイルを選択してください"
                  chips
                />
              </v-card-text>
              <v-card-title>
                <v-text-field v-model="name" label="イベント名" />
              </v-card-title>
              <div class="d-flex flex-column flex-xl-row">
                <v-card-text>
                  <vue-ctk-date-time-picker
                    v-model="openAt"
                    format="YYYY-MM-DD HH:mm"
                    label="Open"
                    id="open-at"
                  />
                </v-card-text>
                <v-card-text>
                  <vue-ctk-date-time-picker
                    v-model="startAt"
                    format="YYYY-MM-DD HH:mm"
                    label="Start"
                    id="start-at"
                  />
                </v-card-text>
              </div>
              <v-card-text>
                <v-text-field v-model="place" label="場所" />
              </v-card-text>
              <div class="d-flex flex-column">
                <v-card-text>
                  <v-text-field
                    v-model="ticketPrice"
                    label="チケット料金(半角数字)"
                    prefix="¥"
                    :rules="rules"
                  />
                </v-card-text>
                <v-card-text>
                  <v-switch
                    v-model="reservation"
                    inset
                    label="チケット取り置きを受けつける(本サイトに登録されているバンドのみ可能)"
                  />
                </v-card-text>
              </div>
              <v-card-text>
                <v-textarea v-model="content" label="詳細" outlined />
              </v-card-text>
              <v-card tile outlined>
                <v-card-subtitle class="text-left text-subtitle-1">
                  Lineup
                </v-card-subtitle>
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
              </v-card>
              <v-card-actions class="mt-5">
                <v-btn width="100%" elevation="4" @click="postEvent">
                  投稿する
                </v-btn>
              </v-card-actions>
            </v-col>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { mapGetters } from "vuex";

export default {
  data() {
    return {
      name: "",
      flyer: [],
      place: "",
      ticketPrice: "",
      openAt: "",
      startAt: "",
      content: "",
      performers: [],
      unregisteredBands: [],
      reservation: false,
      flyerUrl: "",
      registeredBands: [],
      rules: [
        (value) => {
          const pattern = /^[0-9]*$/;
          return pattern.test(value) || "半角数字で入力してください";
        },
      ],
    };
  },
  async created() {
    // 出演者の入力時に検索機能を使うため、本サービスに登録されているBand一覧を取得
    const res = await this.$axios.get("/bands");
    this.registeredBands = res.data.bands;
  },
  computed: {
    ...mapGetters(["headers"]),
  },
  methods: {
    fetchUrl(file) {
      // 選択したflyer(画像ファイル)を表示するためにURLを取得
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        }
        const fr = new FileReader();
        fr.readAsDataURL(file);
        fr.addEventListener("load", () => {
          this.flyerUrl = fr.result;
        });
      } else {
        this.flyerUrl = "";
      }
    },
    async postEvent() {
      const unregisteredPerformers = this.unregisteredBands.join("*/");

      // 新規Eventを投稿
      const eventFormData = new FormData();
      eventFormData.append("event[name]", this.name);
      eventFormData.append("event[flyer]", this.flyer);
      eventFormData.append("event[place]", this.place);
      eventFormData.append("event[ticket_price]", this.ticketPrice);
      eventFormData.append("event[open_at]", this.openAt);
      eventFormData.append("event[start_at]", this.startAt);
      eventFormData.append("event[content]", this.content);
      eventFormData.append("event[reservation]", this.reservation);
      eventFormData.append(
        "event[unregistered_performers]",
        unregisteredPerformers
      );
      const eventRes = await this.$axios.post(
        "/events",
        eventFormData,
        this.headers
      );

      // 投稿したEventのLineupを登録
      const eventId = eventRes.data.id;
      if (this.performers) {
        for (let performer of this.performers) {
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
