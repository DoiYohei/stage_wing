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
          <v-col md="7" cols="12" class="pa-0">
            <v-img :src="eventFlyer" aspect-ratio="1.25" />
          </v-col>
          <v-col class="text-left">
            <ValidationObserver v-slot="{ invalid }">
              <v-card-text>
                <ValidationProvider
                  name="フライヤー"
                  rules="ext:jpg,jpeg,gif,png|size:10000"
                  v-slot="{ errors }"
                >
                  <v-file-input
                    v-model="inputFlyer"
                    @change="fetchFlyerUrl"
                    @blur="fetchOriginal"
                    :error-messages="errors"
                    label="フライヤーを変更する"
                    chips
                    dense
                  />
                </ValidationProvider>
              </v-card-text>
              <v-card-text>
                <ValidationProvider
                  name="イベント名"
                  rules="max:50|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="event.name"
                    :error-messages="errors"
                    label="イベント名（必須）"
                    prefix="*"
                    dense
                  />
                </ValidationProvider>
              </v-card-text>
              <v-card
                color="#121212"
                flat
                class="d-flex flex-column flex-xl-row"
              >
                <v-card-text class="pr-xl-0">
                  <ValidationProvider
                    name="Open"
                    rules="required"
                    v-slot="{ errors, dirty, invalid }"
                  >
                    *Open
                    <DatePicker
                      v-model="event.open_at"
                      format="YYYY MMM. DD - HH:mm"
                      :placeholder="placeholder(event.open_at)"
                      time-title-format="YYYY MMM. DD - HH:mm"
                      type="datetime"
                      confirm
                      show-time-header
                      class="ml-2"
                    />
                    <v-card-text
                      v-if="dirty && invalid"
                      class="red--text pt-1 pb-0 pl-0"
                    >
                      {{ errors[0] }}
                    </v-card-text>
                  </ValidationProvider>
                </v-card-text>
                <v-card-text class="pl-xl-0">
                  <ValidationProvider
                    name="Start"
                    rules="required"
                    v-slot="{ errors, dirty, invalid }"
                  >
                    *Start
                    <DatePicker
                      v-model="event.start_at"
                      :error-messages="errors"
                      format="YYYY MMM. DD - HH:mm"
                      :placeholder="placeholder(event.start_at)"
                      time-title-format="YYYY MMM. DD - HH:mm"
                      type="datetime"
                      confirm
                      show-time-header
                      class="ml-4"
                    />
                    <v-card-text
                      v-if="dirty && invalid"
                      class="red--text pt-1 pb-0 pl-0"
                    >
                      {{ errors[0] }}
                    </v-card-text>
                  </ValidationProvider>
                </v-card-text>
              </v-card>
              <v-card-text>
                <ValidationProvider
                  name="場所"
                  rules="max:50|required"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="event.place"
                    :error-messages="errors"
                    label="場所（必須）"
                    prefix="*"
                    dense
                  />
                </ValidationProvider>
              </v-card-text>
              <v-card-text>
                <ValidationProvider
                  name="チケット料金"
                  rules="integer"
                  v-slot="{ errors }"
                >
                  <v-text-field
                    v-model="event.ticket_price"
                    :error-messages="errors"
                    label="チケット料金（半角数字）"
                    prefix="¥"
                    dense
                  />
                </ValidationProvider>
              </v-card-text>
              <v-card-text>
                <v-checkbox
                  v-model="event.reservation"
                  hint="利用する場合はチェックを入れてください（本サイトに登録されているバンドのみ利用可能）"
                  label="チケット取り置き機能"
                  dense
                  persistent-hint
                  class="mt-0"
                />
              </v-card-text>
              <v-card-text>
                <ValidationProvider
                  name="詳細"
                  rules="max:1000"
                  v-slot="{ errors }"
                >
                  <v-textarea
                    v-model="event.content"
                    background-color="grey darken-4"
                    :error-messages="errors"
                    label="詳細"
                    auto-grow
                    dense
                    outlined
                  />
                </ValidationProvider>
              </v-card-text>
              <slot name="lineup" />
              <v-card-text v-if="isError">
                <v-alert
                  :value="isError"
                  type="error"
                  dense
                  outlined
                  class="mb-0"
                >
                  <slot name="error-text" />
                </v-alert>
              </v-card-text>
              <ButtonSubmitForms @submit-forms="submitForms" :invalid="invalid">
                <slot name="btn-text" />
              </ButtonSubmitForms>
            </ValidationObserver>
          </v-col>
        </v-card>
      </v-col>
    </v-row>
  </v-container>
</template>

<script>
import { ValidationProvider, ValidationObserver } from "vee-validate";
import DatePicker from "vue2-datepicker";
import "vue2-datepicker/index.css";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ValidationProvider,
    ValidationObserver,
    DatePicker,
    ButtonSubmitForms,
  },
  props: {
    value: {
      type: Object,
      require: true,
    },
    isError: {
      type: Boolean,
      require: true,
    },
  },
  data() {
    return {
      inputFlyer: null,
      flyerUrl: "",
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
    placeholder() {
      return (datetime) => {
        if (datetime) {
          return this.$dayjs(datetime).format("YYYY MMM. DD - HH:mm");
        } else return "選択してください（必須）";
      };
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
