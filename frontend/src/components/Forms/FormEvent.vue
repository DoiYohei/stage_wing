<template>
  <v-row>
    <v-col>
      <v-card color="#121212" flat class="d-flex flex-wrap">
        <v-col md="7" cols="12" class="pa-0">
          <v-img :src="eventFlyer" aspect-ratio="1.25" />
        </v-col>
        <v-col class="text-left">
          <ValidationObserver v-slot="{ handleSubmit }">
            <v-card-text>
              <InputImage
                v-model="imageFile"
                label="フライヤー"
                @load-image="loadImage"
              />
              <InputName v-model="event.name" label="イベント名" max="50" />
              <InputEventDate v-model="event.date" />
              <span class="d-flex">
                <InputEventTime
                  v-model="event.open_at"
                  label="OPEN"
                  class="mr-4"
                />
                <InputEventTime v-model="event.start_at" label="START" />
              </span>
              <InputEventPlace v-model="event.place" />
              <InputEventPrice v-model="event.ticket_price" />
              <v-checkbox
                v-model="event.reservation"
                hint="利用する場合はチェックを入れてください（本サイトに登録されているバンドのみ利用可能）"
                label="チケット取り置き機能"
                persistent-hint
                class="pt-0 mb-8"
              />
              <InputTextarea v-model="event.content" label="詳細" max="1000" />
              <slot name="lineup" />
              <AlertError
                :value="isError"
                :text="`${submitText}できませんでした。`"
                class="mb-0"
              />
              <ButtonSubmitForms
                @submit-forms="handleSubmit(submitForms)"
                class="px-0"
              >
                {{ submitText }}する
              </ButtonSubmitForms>
            </v-card-text>
          </ValidationObserver>
        </v-col>
      </v-card>
    </v-col>
  </v-row>
</template>

<script>
import { ValidationObserver } from "vee-validate";
import InputImage from "@/components/Inputs/InputImage";
import InputName from "@/components/Inputs/InputName";
import InputEventDate from "@/components/Inputs/InputEventDate";
import InputEventTime from "@/components/Inputs/InputEventTime";
import InputEventPlace from "@/components/Inputs/InputEventPlace";
import InputEventPrice from "@/components/Inputs/InputEventPrice";
import InputTextarea from "@/components/Inputs/InputTextarea";
import AlertError from "@/components/Alerts/AlertError";
import ButtonSubmitForms from "@/components/Buttons/ButtonSubmitForms";

export default {
  components: {
    ValidationObserver,
    InputImage,
    InputName,
    InputEventDate,
    InputEventTime,
    InputEventPlace,
    InputEventPrice,
    InputTextarea,
    AlertError,
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
    submitText: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      imageFile: null,
      imageUrl: "",
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
      return this.imageUrl ? this.imageUrl : this.defaultUrl;
    },
    defaultUrl() {
      return this.value.flyer
        ? this.value.flyer.url
        : require("@/assets/img/no-flyer.jpg");
    },
  },
  methods: {
    loadImage(url) {
      this.imageUrl = url;
    },
    submitForms() {
      this.$emit("submit-forms", this.imageFile);
    },
  },
};
</script>
