<template>
  <ValidationProvider name="投稿の種類" rules="required" v-slot="{ errors }">
    <v-select
      v-model="format"
      :error-messages="errors"
      :items="choises"
      placeholder="投稿の種類を選択してください"
      outlined
    />
  </ValidationProvider>
</template>

<script>
import { ValidationProvider } from "vee-validate";

export default {
  components: {
    ValidationProvider,
  },
  props: {
    value: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      choises: [
        { text: "画像", value: "photo" },
        { text: "音源", value: "audio" },
        { text: "SoundCloud", value: "soundcloud" },
        { text: "YouTube", value: "youtube" },
        { text: "News", value: "news" },
      ],
    };
  },
  computed: {
    format: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
};
</script>
