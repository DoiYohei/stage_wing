<template>
  <ValidationProvider
    :name="format === 'photo' ? '画像' : '音源'"
    :rules="rules"
    v-slot="{ errors }"
  >
    <v-file-input
      v-model="file"
      @change="loadFileUrl"
      :error-messages="errors"
      placeholder="ファイルを選択してください"
      chips
    />
    <v-img v-if="showPhoto" :src="fileUrl" />
    <VuetifyAudio v-if="showAudio" :file="fileUrl" class="black" />
  </ValidationProvider>
</template>

<script>
import { ValidationProvider } from "vee-validate";
import VuetifyAudio from "vuetify-audio";

export default {
  components: {
    ValidationProvider,
    VuetifyAudio,
  },
  props: {
    value: {
      type: File,
      require: true,
    },
    format: {
      type: String,
      require: true,
    },
  },
  data() {
    return {
      fileUrl: "",
    };
  },
  computed: {
    file: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
    rules() {
      if (this.format === "photo") {
        return "ext:jpg,jpeg,gif,png|required|size:10000";
      } else return "ext:wav,mp3|required|size:10000";
    },
    showPhoto() {
      return this.fileUrl && this.format === "photo";
    },
    showAudio() {
      return this.fileUrl && this.format === "audio";
    },
  },
  watch: {
    format() {
      this.fileUrl = "";
    },
  },
  methods: {
    loadFileUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.fileUrl = fr.result;
          });
        }
      } else {
        this.fileUrl = "";
      }
    },
  },
};
</script>
