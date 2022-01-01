<template>
  <v-container>
    <v-row>
      <v-col class="text-h5">Event編集</v-col>
    </v-row>
    <v-row>
      <v-col>
        <v-card>
          <v-col class="d-flex justify-md-start flex-wrap">
            <v-col md="7" sm="12">
              <v-img v-if="flyerUrl" :src="flyerUrl" />
            </v-col>
            <v-col class="text-left pb-0">
              <v-card-text>
                <v-file-input
                  v-model="newFlyer"
                  @change="fetchUrl"
                  @blur="fetchOriginal"
                  label="フライヤーを変更する"
                  chips
                />
              </v-card-text>
              <v-card-title>
                <v-text-field v-model="event.name" label="イベント名" />
              </v-card-title>
              <div class="d-flex flex-column flex-xl-row">
                <v-card-text>
                  <vue-ctk-date-time-picker
                    v-model="event.open_at"
                    format="YYYY-MM-DD HH:mm"
                    label="Open"
                    id="open-at"
                  />
                </v-card-text>
                <v-card-text>
                  <vue-ctk-date-time-picker
                    v-model="event.start_at"
                    format="YYYY-MM-DD HH:mm"
                    label="Start"
                    id="start-at"
                  />
                </v-card-text>
              </div>
              <v-card-text>
                <v-text-field v-model="event.place" label="場所" />
              </v-card-text>
              <v-card-text>
                <v-text-field
                  v-model="event.ticket_price"
                  label="チケット料金(半角数字)"
                  prefix="¥"
                  :rules="rules"
                />
              </v-card-text>
              <v-card-text>
                <v-switch
                  v-model="event.reservation"
                  inset
                  label="チケット取り置きを受けつける(本サイトに登録されているバンドのみ可能)"
                />
              </v-card-text>
              <v-card-text>
                <v-textarea v-model="event.content" label="詳細" outlined />
              </v-card-text>
              <v-card-actions>
                <v-btn width="100%" elevation="4" @click="patchEvent">
                  更新する
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
export default {
  props: ["id"],
  data() {
    return {
      event: {},
      newFlyer: null,
      flyerUrl: "",
      rules: [
        (value) => {
          const pattern = /^[0-9]*$/;
          return pattern.test(value) || "半角数字で入力してください";
        },
      ],
    };
  },
  async created() {
    const token = { headers: this.$store.getters.token };
    const res = await this.$axios.get(`/events/${this.id}/edit`, token);
    this.event = res.data;
    this.flyerUrl = res.data.flyer.url;
  },
  methods: {
    fetchUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.flyerUrl = fr.result;
          });
        }
      } else {
        this.flyerUrl = "";
      }
    },
    fetchOriginal() {
      if (!this.flyerUrl) {
        this.flyerUrl = this.event.flyer.url;
      }
    },
    async patchEvent() {
      const token = { headers: this.$store.getters.token };
      const formData = new FormData();
      formData.append("event[name]", this.event.name);
      formData.append("event[place]", this.event.place);
      formData.append("event[ticket_price]", this.event.ticket_price);
      formData.append("event[open_at]", this.event.open_at);
      formData.append("event[start_at]", this.event.start_at);
      formData.append("event[content]", this.event.content);
      formData.append("event[reservation]", this.event.reservation);
      if (this.newFlyer) formData.append("event[flyer]", this.newFlyer);
      await this.$axios.patch(`/events/${this.id}`, formData, token);
      this.$router.replace(`/events/${this.id}`);
    },
  },
  watch: {
    newFlyer() {
      if (!this.flyerUrl) {
        this.flyerUrl = this.event.flyer.url;
      }
    },
  },
};
</script>
