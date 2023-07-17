<template>
  <ValidationProvider
    mode="aggressive"
    :name="label"
    rules="ext:jpg,jpeg,gif,png|size:10000"
    v-slot="{ errors }"
  >
    <v-file-input
      v-model="image"
      @change="loadImageUrl"
      @click:clear="clearImage"
      :error-messages="errors"
      :label="label"
      chips
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
      type: File,
      require: true,
    },
    label: {
      type: String,
      require: true,
    },
  },
  computed: {
    image: {
      get() {
        return this.value;
      },
      set(newValue) {
        this.$emit("input", newValue);
      },
    },
  },
  methods: {
    loadImageUrl(file) {
      if (file !== undefined && file !== null) {
        if (file.name.lastIndexOf(".") <= 0) {
          return;
        } else {
          const fr = new FileReader();
          fr.readAsDataURL(file);
          fr.addEventListener("load", () => {
            this.$emit("load-image", fr.result);
          });
        }
      } else {
        this.clearImage();
      }
    },
    clearImage() {
      this.$emit("load-image", "");
    },
  },
};
</script>
