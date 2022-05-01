<template>
  <v-container>
    <v-row>
      <v-col>
        <v-card color="#121212" flat>
          <v-card-title class="pb-0">
            <v-spacer />
            <slot name="page-title" />
            <v-spacer />
          </v-card-title>
        </v-card>
      </v-col>
    </v-row>
    <v-row>
      <v-col>
        <v-card color="#121212" flat class="d-flex flex-wrap">
          <v-col md="7" sm="12" class="pa-0">
            <v-img :src="eventFlyer" aspect-ratio="1.25" />
          </v-col>
          <v-col class="text-left">
            <v-card-text>
              <v-file-input
                v-model="inputFlyer"
                @change="fetchFlyerUrl"
                @blur="fetchOriginal"
                label="フライヤーを変更する"
                chips
                dense
                hide-details
              />
            </v-card-text>
            <v-card-title>
              <v-text-field
                v-model="event.name"
                label="イベント名"
                dense
                hide-details
              />
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
              <v-text-field
                v-model="event.place"
                label="場所"
                dense
                hide-details
              />
            </v-card-text>
            <v-card-text>
              <v-text-field
                v-model="event.ticket_price"
                label="チケット料金(半角数字)"
                prefix="¥"
                :rules="rules"
                dense
                hide-details
              />
            </v-card-text>
            <v-card-text>
              <v-switch
                v-model="event.reservation"
                label="チケット取り置きを受けつける(本サイトに登録されているバンドのみ可能)"
                dense
                hide-details
                inset
                class="mt-0"
              />
            </v-card-text>
            <v-card-text>
              <v-textarea
                v-model="event.content"
                label="詳細"
                dense
                hide-details
                outlined
              />
            </v-card-text>
            <slot name="lineup" />
            <ButtonSubmitForms @submit-forms="submitForms">
              <slot name="btn-text" />
            </ButtonSubmitForms>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ButtonSubmitForms,
  },
  props: {
    value: {
      type: Object,
      require: true,
    },
  },
  data() {
    return {
      inputFlyer: null,
      flyerUrl: "",
      rules: [
        (value) => {
          const pattern = /^[0-9]*$/;
          return pattern.test(value) || "半角数字で入力してください";
        },
      ],
    };
  },
  computed: {
    event: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    eventFlyer() {
      return this.flyerUrl
        ? this.flyerUrl
        : require("@/assets/img/no-flyer.jpg");
    },
  },
  watch: {
    value() {
      this.fetchOriginal();
    },
    inputFlyer() {
      this.fetchOriginal();
    },
  },
  methods: {
    fetchFlyerUrl(file) {
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
      if (!this.flyerUrl && this.value.flyer) {
        this.flyerUrl = this.value.flyer.url;
      }
    },
    submitForms() {
      this.$emit("submit-forms", this.inputFlyer);
    },
  },
};
</script>
